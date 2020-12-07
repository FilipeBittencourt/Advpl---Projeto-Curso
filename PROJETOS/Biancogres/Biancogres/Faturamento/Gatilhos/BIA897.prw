#include "rwmake.ch"
User Function BIA897()
/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � BIA897     � Autor � Ranisses A. Corona    � Data � 04/05/04 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Gatilho na solicitacao do Tipo de Venda                      ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Interpretador x Base                                         ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Private aRadio := {"SIM   ","NAO   "}
Private	nRadio := 2
Private	wFim   := .T., lret := "N"
Private wReCr  := M->C5_YRECR

Private cArq	:= ""
Private cInd	:= 0
Private cReg	:= 0

Private cArqSA1	:= ""
Private cIndSA1	:= 0
Private cRegSA1	:= 0

cArq := Alias()
cInd := IndexOrd()
cReg := Recno()

DbSelectArea("SA1")
cArqSA1 := Alias()
cIndSA1 := IndexOrd()
cRegSA1 := Recno()

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE))

If M->C5_YSUBTP $ "A ,B ,D " .and. (SA1->A1_YRECR <> "3" .or. SA1->A1_YRECR <> M->C5_YLINHA) .and. M->C5_YRECR == "N"
	While wfim
		@ 0,0 TO 070,500 DIALOG oDlg1 TITLE "O Cliente � Distribuidor '(S/N) ?'"
		@ 000,010 TO 30,70 TITLE "Opcoes"
		@ 007,020 RADIO aRadio VAR nRadio
		@ 010,087 BMPBUTTON TYPE 1 ACTION fSC5()
		ACTIVATE DIALOG oDlg1 CENTER
	EndDo
Else
	lret := wReCr
EndIf

If M->C5_YSUBTP == "N " .and. SA1->A1_YRECR <> "3" .and. SA1->A1_YRECR <> M->C5_YLINHA
	lret := "N"
EndIf

If cArqSA1 <> ""
	dbSelectArea(cArqSA1)
	dbSetOrder(cIndSA1)
	dbGoTo(cRegSA1)
	RetIndex("SA1")
EndIf

DbSelectArea(cArq)
DbSetOrder(cInd)
DbGoTo(cReg)

Return(lret)

//���������������������������������������������������������������������Ŀ
//� Atualizar os campos do arquivo SC5                                  �
//�����������������������������������������������������������������������
Static Function fSC5()
If nradio == 1
	lret := "S"
Else
	lret := "N"
EndIf
Close(oDlg1)
wFim := .F.
Return
