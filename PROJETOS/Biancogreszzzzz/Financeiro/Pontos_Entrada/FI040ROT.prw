#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"         
#Include "PROTHEUS.CH" 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FI040ROT � Autor � MADALENO              � Data � 09/07/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � PONTO DE ENTRADA PARA ADICIONAR NOVAS ROTINAS NO CONTAS    ���
���          � A RECEBER                                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MP 10                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION FI040ROT()
	
	Local aRot := If(IsInCallStack("U_FA740BRW"), {}, ParamIxb)
	Local aSubRot := {}
	
	aAdd(aRot, {"Checa Comiss�o"		, "U_GRAVA_FLAF", 0, 5})
	aAdd(aRot, {"Hist�rico de Tarifas"	, "U_BIAF051()", 0, 5})
	aAdd(aRot, {"Amarra��o Pedido x RA"	, "U_fAmPeRA", 0, 5})
	
	aAdd(aSubRot, {"Reenvio boletos receber"				, "U_BAF012", 0, 8})
	aAdd(aSubRot, {"Atualizar Dados Banc�rios - Fornecedor"	, "U_BAF007", 0, 8})
	aAdd(aSubRot, {"Relat. Cep. Diverg."					, "U_BIACEPX", 0, 8})
	aAdd(aSubRot, {"Remessa automatica Receber"				, "U_BAF008", 0, 8})
	aAdd(aSubRot, {"Relat. Deposito Identificado"			, "U_BAF020R", 0, 8})
	aAdd(aSubRot, {"Deposito Identificado"					, "U_BAF020", 0, 8})

	aAdd(aRot, {"Posi��o de T�tulos a Receber", "FINC040(2)", 0, 8, 0, NIL})
	aAdd(aRot, {"Automa��o Financeira", aSubRot, 0, 8, 0, NIL})
	
Return(aRot)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �GRAVA_FLAF� Autor � MADALENO              � Data � 09/07/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � rotina para gravar o flag de verificacao da comissao       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION GRAVA_FLAF()

RecLock('SE1',.F.)
Replace E1_YCFCOM   With "S"
MsUnLock()

MsgBox("TITULO CONFERIDO!","FI040ROT","INFO")

RETURN


/*
##############################################################################################################
# PROGRAMA...: fAmPeRA
# AUTOR......: Ranisses A. Corona
# DATA.......: 21/10/2015  
# DESCRICAO..: Trata amarra��o de Pedido x RA
##############################################################################################################     
*/
User Function fAmPeRA()
Local nMsg := ""

If !U_VALOPER("023",.F.)
	MsgBox("Voc� n�o possui permiss�o para utilizar essa rotina.","OP 023 - FI040ROT","STOP")
Else
	If !Alltrim(SE1->E1_TIPO) == "RA"
		MsgBox("Esta altera��o s� � permitida para T�tulos de RA.","FI040ROT","STOP")
	Else
			
		If Empty(Alltrim(SE1->E1_PEDIDO))  
			nMsg := "Este RA n�o possui amarra��o com Pedido de Venda. Deseja realizar amarra��o com algum Pedido de Venda?"
		Else
			nMsg := "Este RA est� amarrado ao Pedido de Venda "+SE1->E1_PEDIDO+". Deseja remover a amarra��o ou alterar o n�mero do Pedido de Venda?"
		EndIf
		
		If MsgBox(nMsg,"FI040ROT","YesNo")				
			//Altera Titulo
			uAltera()		
			//Grava Status do RA na Libera��o dos Pedidos		
			U_BIAMsgRun("Aguarde... Atualizando Pedidos j� Liberados...",,{|| U_BIA859(SE1->E1_CLIENTE,SE1->E1_LOJA) })			
			MsgBox("Altera��o realizada com sucesso!","FI040ROT","INFO")
		EndIf		
		
	EndIf
EndIf

Return

//Monta tela para altera��o do pedido
Static Function uAltera()
Private oGet1
Private cGet1	:= SE1->E1_PEDIDO
Private oGroup1
Private oSay1
Private oSButton1
Static  oDlg

  DEFINE MSDIALOG oDlg TITLE "Amarra��o Pedido Venda x RA" FROM 000, 000  TO 100, 230 COLORS 0, 16777215 PIXEL

    @ 006, 004 GROUP oGroup1 TO 040, 108 OF oDlg COLOR 0, 16777215 PIXEL
    @ 012, 013 SAY oSay1 PROMPT "Pedido de Venda" SIZE 052, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 013 MSGET oGet1 VAR cGet1 SIZE 048, 010 OF oDlg COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 019, 072 TYPE 01 OF oDlg ENABLE ACTION uSalvar()

  ACTIVATE MSDIALOG oDlg CENTERED

Return

//Grava o novo Pedido e fecha a tela.
Static Function uSalvar()

SE1->(RecLock("SE1",.F.))
SE1->E1_PEDIDO := cGet1
SE1->(MsUnLock())        
Close(oDlg)

Return