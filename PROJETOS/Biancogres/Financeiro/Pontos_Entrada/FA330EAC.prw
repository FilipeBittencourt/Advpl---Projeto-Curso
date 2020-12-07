#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/01/01
#include "topconn.ch"
/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � FA330EAC   � Autor � Nilton                � Data � 25/11/04 ���
���������������������������������������������������������������������������Ĵ��
���Descricao � Apagar SE3                                                   ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Interpretador x Base                                         ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FA330EAC()        // incluido pelo assistente de conversao do AP5 IDE em 29/01/01
	LOcal x
	Private aArea := GetArea(),x, lgerou
	For x:=1 to Len(atitulos)
		If aTitulos[x,11] // Checar se esta marcado
			DBSelectArea("SE3")
			nreg := Recno()
			DbSetOrder(1)
			If DbSeek(xFilial("SE3")+aTitulos[x,1]+aTitulos[x,2]+aTitulos[x,3]+aTitulos[x,8]) //Prefixo+numero+parcela+sequencia
				RecLock("SE3",.f.)
				Delete
				MsUnlock()
			EndIf          
			DbGoto(nreg)
		EndIf
	Next
	RestArea(aArea)
Return
