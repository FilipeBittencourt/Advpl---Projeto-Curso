#include "rwmake.ch"
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BIA837   � Autor � Ranisses A. Corona � Data �  23/11/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Nosso Numero - CNAB A Pagar Bradesco [139 a 150]           ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BIA837()
Local nNosso := ""

If SEA->EA_MODELO $ "31"				//PAGAMENTO DE TITULOS 
	If !Empty(Alltrim(SE2->E2_CODBAR))
		If Substr(SE2->E2_CODBAR,1,3) == "237"
			nNosso := StrZero(Val(Substr(SE2->E2_CODBAR,26,11)),11)
			nNosso := nNosso+U_DigitoRR(U_BIA836(),nNosso)			
		Else
			nNosso := "000000000000"
		EndIf
	Else
		If Substr(SE2->E2_YLINDIG,1,3) == "237"
			nNosso := Substr(SE2->E2_YLINDIG,12,09)+Substr(SE2->E2_YLINDIG,22,2)
			nNosso := nNosso+U_DigitoRR(U_BIA836(),nNosso)
		Else
			nNosso := "000000000000"
		EndIf
	EndIf
Else													
	nNosso := "000000000000"
EndIf

Return(nNosso)