#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
|-----------------------------------------------------------|
| Fun��o: | OS01ACOL, OM010DA1, OS010GRV 										|
| Autor:	| Tiago Rossini Coradini - Facile Sistemas			  |
| Data:		| 02/03/15																			  |
|-----------------------------------------------------------|
| Desc.:	| Ponto de entrada na grava��o do cabe�alho da 		|
| 				| tabela de pre�os 														  	|
|-----------------------------------------------------------|
| OS:			|	0406-14 - Usu�rio: Claudia Carvalho							|
|-----------------------------------------------------------|
*/

Static __lExec_OS01ACOL := .T.
Static __aDA1 := {}
Static __aDA1Alt := {}


// Ponto de entrada para manipula��o do aCols da tabela de pre�o
User Function OS01ACOL()
	Local nCount := 0
	Local nUsado := Len(aHeader)

	If Altera .And. __lExec_OS01ACOL

		For nCount := 1 To Len(aCols)

			aAdd(__aDA1, {aCols[nCount, nUsado], GdFieldGet("DA1_PRCVEN", nCount)} )

		Next				

		__lExec_OS01ACOL := .F.

	EndIf

Return()


// Ponto de entrada ap�s a grava��o dos itens da tabela de pre�os
User Function OM010DA1()

	aAdd(__aDA1Alt, {DA1->(RecNo()), DA1->DA1_PRCVEN} )	

Return()


// Ponto de entrada ap�s a grava��o da tabela de pre�os
User Function OS010GRV()
	Local aArea := DA1->(GetArea())
	Local nX 

	If Len(__aDA1Alt) > 0

		For nX := 1 To Len(__aDA1Alt)

			nPos := aScan(__aDA1, {|x| x[1] == __aDA1Alt[nX,1] .And. x[2] <> __aDA1Alt[nX,2] })

			If nPos > 0

				DA1->(DbGoto(__aDA1[nPos,1]))

				RecLock("DA1", .F.)

				DA1->DA1_YUPRCV := __aDA1[nPos, 2]
				DA1->DA1_YDATAL := dDataBase
				DA1->DA1_YUSUAL := __cUserId + "-" + AllTrim(cUserName)

				DA1->(MsUnlock())

			EndIf

		Next

	EndIf

	__lExec_OS01ACOL := .T.

	__aDA1 := {}

	__aDA1Alt := {}

	RestArea(aArea)

Return()