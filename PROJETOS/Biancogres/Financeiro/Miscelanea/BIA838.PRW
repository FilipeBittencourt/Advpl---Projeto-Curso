#include "rwmake.ch"
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BIA838   � Autor � Ranisses A. Corona � Data �  23/11/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Fator Vencimento - CNAB A Pagar Bradesco [191 a 194]       ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BIA838()
Local nFator := ""

If SEA->EA_MODELO $ "31"				//PAGAMENTO DE TITULOS 
	If !Empty(Alltrim(SE2->E2_CODBAR))
//		If Substr(SE2->E2_CODBAR,1,3) == "237"
			nFator := Substr(SE2->E2_CODBAR,6,4)
//		Else
//			nFator := "0000"
//		EndIf
	Else
//		If Substr(SE2->E2_YLINDIG,1,3) == "237"
			nFator := Substr(SE2->E2_YLINDIG,34,4)
//		Else
//			nFator := "0000"
//		EndIf
	EndIf
Else													
	nFator := "0000"
EndIf

Return(nFator)