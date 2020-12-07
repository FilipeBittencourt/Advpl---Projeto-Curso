#INCLUDE "TOTVS.CH"

/*
|------------------------------------------------------------|
| Funcao:	| BIAF025																					 |
| Autor:	|	Tiago Rossini Coradini - Facile Sistemas				 |
| Data:		| 17/08/15																				 |
|------------------------------------------------------------|
| Desc.:	|	Fun��o para pesquisa de precos de produtos			 |
|------------------------------------------------------------|
| OS:			|	0069-15 - Usu�rio: Claudia Carvalho   		 			 |
|------------------------------------------------------------|
*/

User Function BIAF025()
Local oObj := Nil

	If U_VALOPER("022")
		
		oObj := TWPesquisaPrecoProduto():New()
		
		oObj:Activate()
		
	EndIf
	
Return()