#INCLUDE "TOTVS.CH"

/*
|------------------------------------------------------------|
| Fun��o:	| BIAF007																					 |
| Autor:	|	Tiago Rossini Coradini - Facile Sistemas				 |
| Data:		| 27/10/14																				 |
|------------------------------------------------------------|
| Desc.:	|	Aprova��o do Or�amento de Venda   						   |
| 				|	Respons�vel por executar os gatilhos do campo  	 |
| 				|	produto (C6_PRODUTO) ao aprovar um or�amento     |
|------------------------------------------------------------|
| OS:			|	0652-14 - Usu�rio: Elaine Cristina Sales	 			 |
|------------------------------------------------------------|
*/

User Function BIAF007(aHeaderSC6, aColsSC6, nLine)
Local aArea := GetArea()
Private aHeader	:= aHeaderSC6
Private aCols := aColsSC6
Private N := nLine

	If ExistTrigger("C6_PRODUTO")
		RunTrigger(2, nLine, Nil,,"C6_PRODUTO")
	EndIf

	RestArea(aArea)
	
Return()