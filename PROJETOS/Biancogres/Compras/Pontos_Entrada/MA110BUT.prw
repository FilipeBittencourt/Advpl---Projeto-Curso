#INCLUDE "TOTVS.CH"

/*
|------------------------------------------------------------|
| Fun��o:	| MA110BUT																				 |
| Autor:	|	Tiago Rossini Coradini - Facile Sistemas				 |
| Data:		| 10/09/14																				 |
|------------------------------------------------------------|
| Desc.:	|	Adiciona botao na rotina de Solicita��o de Compra|
|------------------------------------------------------------|
| OS:			|	1818-14 - Usu�rio: Claudia Carvalho   		 			 |
|------------------------------------------------------------|
*/


User Function MA110BUT()
Local aButton := ParamIxb[2]
	
	aAdd(aButton, {"EDITABLE", {|| U_BIAF002("MATA110")}, "Hist. Pre�o"})
	
Return(aButton)