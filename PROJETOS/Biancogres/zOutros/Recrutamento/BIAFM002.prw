/*---------+-----------+-------+----------------------+------+------------+
|Funcao    |BIAFM002   | Autor | Marcelo Sousa        | Data | 31.07.2018 |
|          |           |       | Facile Sistemas      |      |            |
+----------+-----------+-------+----------------------+------+------------+
|Descricao |GRID PARA ESCOLHA DE QUAIS ACESSOS SER�O NECESS�RIOS          |
|          |NO CADASTRAMENTO DA VAGA.									  |
+----------+--------------------------------------------------------------+
|Uso       |RECRUTAMENTO E SELE��O                                        |
+----------+-------------------------------------------------------------*/
#include "protheus.ch"
#Include "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"



User Function BIAFM002()
	
	/*������������������������������������������������������������������������ٱ�
	�� Declara��o de Variaveis Private dos Objetos                             ��
	ٱ�������������������������������������������������������������������������*/
	Local nI
	Private lRefresh := .T.
	Private _aCols := {}
	Private nMax 			:= 999
	Private oGetD
	Private oDlg
	_aCols := {}
	
	/*������������������������������������������������������������������������ٱ�
	�� Verificando se h� algum acesso na vaga, caso seja edi��o                ��
	ٱ�������������������������������������������������������������������������*/
	dbSelectArea("ZR1")
	dbSetOrder(1)
	dbSeek(xFilial("ZR1")+SQS->QS_VAGA)
	
	While !eof() .and. ZR1->ZR1_VAGA == SQS->QS_VAGA
		
		AADD(_aCols,{ZR1_ITEM,ZR1_TIPO,ZR1_DESC,ZR1_OBS,.F.})
		
		dbSkip()
	
	Enddo
	
	/*������������������������������������������������������������������������ٱ�
	�� Montando o GRID com os dados.                                           ��
	ٱ�������������������������������������������������������������������������*/
	oDlg := MSDIALOG():New(0,0,300,1200, "Acessos para a Vaga",,,,,,,,,.T.)
	oGetD:= MsNewGetDados():New( 053, 078, 415, 775,GD_INSERT+GD_DELETE+GD_UPDATE,,,, {"ZR1_TIPO","ZR1_DESC","ZR1_OBS"}, , nMax,,,, oDLG, GetFieldProperty(), _aCols)
	oGetD:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	EnchoiceBar(oDlg, {|| fGrava(),oDlg:END() }, {|| oDlg:END() },,)
	
	ACTIVATE MSDIALOG oDlg CENTERED
	

	
Return                                                                                 

/*������������������������������������������������������������������������ٱ�
�� Funcao que busca a propriedade dos campos para montagem do grid.        ��
ٱ�������������������������������������������������������������������������*/
Static function GetFieldProperty() 

	oField := TGDField():New()

	oField:Clear()

	// Adciona coluna para tratamento de marcacao no grid
	oField:AddField("ZR1_ITEM") 	
	
	oField:AddField("ZR1_TIPO")
	
	oField:AddField("ZR1_DESC")
	
	oField:AddField("ZR1_OBS")
	
Return(oField:GetHeader())

/*������������������������������������������������������������������������ٱ�
�� Funcao que grava os dados de acesso na tabela ZR1                       ��
ٱ�������������������������������������������������������������������������*/
Static Function fGrava()

	Local n := 0
	Local cCont	:= 0
	
	/*������������������������������������������������������������������������ٱ�
	�� Buscando os dados para refazer a tabela.                                ��
	ٱ�������������������������������������������������������������������������*/
	For n := 1 to Len(oGetD:aCols)
	
		dbSelectArea("ZR1")
		dbSetOrder(1)
		dbSeek(xFilial("ZR1")+SQS->QS_VAGA)
			
		IF !eof() .and. ZR1->ZR1_VAGA == SQS->QS_VAGA
			
			Reclock("ZR1",.F.)
			ZR1->(DBDELETE())
			ZR1->(MsUnlock())
		
		ENDIF 
	
	NEXT
	
	/*������������������������������������������������������������������������ٱ�
	�� Gravando os dados atualizados na tabela.                                ��
	ٱ�������������������������������������������������������������������������*/	
	For n := 1 to Len(oGetD:aCols)
		
		dbSelectArea("ZR1")
		dbSetOrder(1)
		dbSeek(xFilial("ZR1")+M->QS_VAGA)
		
		
		
		Reclock("ZR1",.T.)
		
		ZR1->ZR1_VAGA := M->QS_VAGA 
		ZR1->ZR1_ITEM := strzero(n,3)  
		ZR1->ZR1_TIPO := GDFIELDGET("ZR1_TIPO",n,,oGetD:aheader,oGetD:aCols)
		ZR1->ZR1_DESC := GDFIELDGET("ZR1_DESC",n,,oGetD:aheader,oGetD:aCols)
		ZR1->ZR1_OBS  := GDFIELDGET("ZR1_OBS",n,,oGetD:aheader,oGetD:aCols)
		
		ZR1->(MsUnlock())
			
		ZR1->(DBCLOSEAREA())
		
	Next


Return