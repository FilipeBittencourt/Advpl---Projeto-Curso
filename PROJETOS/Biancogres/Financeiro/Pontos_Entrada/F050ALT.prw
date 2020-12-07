#INCLUDE "TOTVS.CH"

/*
|------------------------------------------------------------|
| Fun��o:	| F050ALT																					 |
| Autor:	|	Tiago Rossini Coradini - Facile Sistemas				 |
| Data:		| 02/09/14																				 |
|------------------------------------------------------------|
| Desc.:	|	Ponto de entrada utilizado na confirma��o da  	 |
| 				| altera��o do contas a pagar											 |
|------------------------------------------------------------|
| OS:			|	1496-14 - Usu�rio: Alessa Feliciano   		 			 |
|------------------------------------------------------------|
*/

User Function F050ALT()
Local nOpc := ParamIXB[1]
	
	// Varifica se a data de vencimento � maior que 45 dias da data de emiss�o
	// Se o vencimento for maior que 45 dias, envia workflow para gestor 	
	// If nOpc == 1 .And. AllTrim(SE2->E2_TIPO) <> "PR" .And. (SE2->E2_VENCTO > DaySum(SE2->E2_EMISSAO, 45) .Or. SE2->E2_VENCREA > DaySum(SE2->E2_EMISSAO, 45))
	
	// Altera��o: OS: 1555-15 - Mikaelly Gentil
	If nOpc == 1 .And. AllTrim(SE2->E2_TIPO) <> "PR" .And. (SE2->E2_VENCTO <> M->E2_VENCTO .Or. SE2->E2_VENCREA <> M->E2_VENCREA)
		U_BIAF004()
	EndIf

Return()