#include "rwmake.ch"  

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � BIA006     � Autor � MICROSIGA VITORIA     � Data � 19/04/99 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Determina a descricao do produto                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Interpretador x Base                                         潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/

User Function Bia006()

Private wAlias	:= Alias()
Private wCod	:= Gdfieldget('C6_PRODUTO',N) 
Private wDesc   := SPACE(1)

Private cArq	:= ""
Private cInd	:= 0
Private cReg	:= 0

Private cArqSB1	:= ""
Private cIndSB1	:= 0
Private cRegSB1	:= 0

cArq := Alias()
cInd := IndexOrd()
cReg := Recno()

DbSelectArea("SB1")
cArqSB1 := Alias()
cIndSB1 := IndexOrd()
cRegSB1 := Recno()

DbSelectArea("SB1")
DbSetOrder(1)
If DbSeek(xFilial("SB1")+wCod,.f.)
	If Alltrim(SB1->B1_GRUPO) == "PA"
		wDesc := SB1->B1_YREF
	Else
		wDesc := SB1->B1_DESC
	EndIf
EndIf

dbSelectArea(wAlias)

If cArqSB1 <> ""
	dbSelectArea(cArqSB1)
	dbSetOrder(cIndSB1)
	dbGoTo(cRegSB1)
	RetIndex("SB1")
EndIf

DbSelectArea(cArq)
DbSetOrder(cInd)
DbGoTo(cReg)

Return(wDesc)