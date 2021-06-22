/*---------+-----------+-------+----------------------+------+------------+
|Funcao    |BIAFM008   | Autor | Marcelo Sousa        | Data | 03.10.2018 |
|          |           |       | Facile Sistemas      |      |            |
+----------+-----------+-------+----------------------+------+------------+
|Descricao |GRID PARA INFORMAR O HIST�RICO DE REPROGRAMA��O               |
|          |DOS TREINAMENTOS.       									  |
+----------+--------------------------------------------------------------+
|Uso       |TREINAMENTO			                                          |
+----------+-------------------------------------------------------------*/
#include "protheus.ch"
#Include "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"



User Function BIAFM008()
	
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
	
	cCalend := RA2->RA2_CALEND
	cCurso := GDFIELDGET("RA2_CURSO")
 	
	/*������������������������������������������������������������������������ٱ�
	�� Verificando se h� algum acesso na vaga, caso seja edi��o                ��
	ٱ�������������������������������������������������������������������������*/
	dbSelectArea("ZR5")
	dbSetOrder(1)
	dbSeek(xFilial("ZR5")+cCalend+cCurso)
	
	While !eof() .and. ZR5->ZR5_CALEND == RA2->RA2_CALEND
		
		AADD(_aCols,{ZR5_CALEND,ZR5_CURSO,ZR5_DATAIN,ZR5_DATAFI,ZR5_DATAAL,ZR5_JUST,.F.})
		
		ZR5->(dbSkip())
	
	Enddo
	
	/*������������������������������������������������������������������������ٱ�
	�� Montando o GRID com os dados.                                           ��
	ٱ�������������������������������������������������������������������������*/
	oDlg := MSDIALOG():New(0,0,300,1200, "Hist�rico de Mudan�a Treinamentos",,,,,,,,,.T.)
	oGetD:= MsNewGetDados():New( 053, 078, 415, 775,,,,,,,nMax,,,, oDLG, GetFieldProperty(), _aCols)
	oGetD:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	ACTIVATE MSDIALOG oDlg CENTERED
	

	
Return                                                                                 

/*������������������������������������������������������������������������ٱ�
�� Funcao que busca a propriedade dos campos para montagem do grid.        ��
ٱ�������������������������������������������������������������������������*/
Static function GetFieldProperty() 

	oField := TGDField():New()

	oField:Clear()

	// Adciona coluna para tratamento de marcacao no grid
	oField:AddField("ZR5_CALEND") 	
	
	oField:AddField("ZR5_CURSO")
	
	oField:AddField("ZR5_DATAIN")
	
	oField:AddField("ZR5_DATAFI")
	
	oField:AddField("ZR5_DATAAL")
	
	oField:AddField("ZR5_JUST")
	
Return(oField:GetHeader())