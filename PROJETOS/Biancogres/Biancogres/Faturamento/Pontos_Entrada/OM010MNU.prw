#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} OM010MNU
@author Tiago Rossini Coradini
@since 04/07/2016
@version 1.0
@description Ponto de entrada para inclus�o de novas op��es de menu na rotina de tabela de pre�os. 
@obs OS: 4470-15 - Claudeir Fadini
@type function
/*/

User Function OM010MNU()
	
	Aadd(aRotina, {'Replicar','U_BIAF039' , 0, 4, 0, Nil})
		
Return()