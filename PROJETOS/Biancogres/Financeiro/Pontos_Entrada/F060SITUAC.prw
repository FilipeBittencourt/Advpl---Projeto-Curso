#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
|-----------------------------------------------------------|
| Fun��o: | F060SITUAC									    |
| Autor:  | Tiago Rossini Coradini - Facile Sistemas	    |
| Data:	  | 05/05/15									    |
|-----------------------------------------------------------|
| Desc.:  | Ponto de entrada para adicionar novas carteiras |
|		  | de cobran�a. 									|
| Desc.:  | Refer�ncia tabela 07 - Situa��es de Cobran�as 	|
|-----------------------------------------------------------|
| OS:	  |	1307-15, 1308-15 - Usu�rio: Vagner Salles		|
|-----------------------------------------------------------|
*/

User Function F060SITUAC()
Local aSituacoes := ParamIxb

//	Add(aSituacoes, "L Creditos Incobraveis")
	
Return(aSituacoes)