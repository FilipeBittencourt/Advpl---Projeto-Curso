#INCLUDE "TOTVS.CH"

/*
|------------------------------------------------------------|
| Fun��o:	| BIAF002																					 |
| Autor:	|	Tiago Rossini Coradini - Facile Sistemas				 |
| Data:		| 22/09/14																				 |
|------------------------------------------------------------|
| Desc.:	|	Fun��o para visualiza��o do historico de precos  |
| 				| de produtos  																		 |
|------------------------------------------------------------|
| OS:			|	1818-14 - Usu�rio: Claudia Carvalho   		 			 |
|------------------------------------------------------------|
*/


User Function BIAF002(cId)
Local aArea := GetArea()
  
	U_BIAMsgRun("Carregando historico de precos...", "Aguarde!", {|| fLoad(cId) })
	
	Restarea(aArea)
	
Return()


Static Function fLoad(cId)
Local oWObj := TWHistoricoPrecoProduto():New(cId)

	oWObj:Activate()
	
Return()