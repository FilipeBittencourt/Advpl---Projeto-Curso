#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/01/01
#include "topconn.ch"
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un嚻o    � FA330EAC   � Autor � Nilton                � Data � 25/11/04 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Apagar SE3                                                   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Interpretador x Base                                         潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
