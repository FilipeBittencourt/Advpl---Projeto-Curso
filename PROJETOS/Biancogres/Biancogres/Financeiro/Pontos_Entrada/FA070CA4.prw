#include "rwMake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FA070CA4 � Autor � MADALENO              � Data � 26/03/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � FUNCAO VALIDAR A DATA DA BAIXA COM O PARAMETRO MV_DATAFIN  ���
���          � NO MOMENTO DO CANCELAMENTO DA BAIXA DO CONTAS A RECEBER    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FA070CA4()
LOCAL LRET := .T.
                                                 	
If SE5->E5_DATA <= GetMv("MV_DATAFIN") //.AND. SE5->E5_DATA == DDATABASE
	MsgBox("Nao e permitida o cancelamento de baixa, com data anterior a "+Dtoc(GetMv("MV_DATAFIN"))+". ","DATA INVALIDA","INFO")
	LRET := .F.
EndIf

If SE5->E5_DATA <> DDATABASE
	MsgBox("Nao e permitida o cancelamento de baixa, com data anterior a "+Dtoc(DDATABASE)+". ","DATA INVALIDA","INFO")
	LRET := .F.
EndIf

RETURN(LRET)