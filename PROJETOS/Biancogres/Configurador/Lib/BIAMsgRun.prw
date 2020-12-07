#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} BIAMsgRun
@author Tiago Rossini Coradini
@since 13/11/2017
@version 1.0
@description Fun��o generica que exibe um painel com anima��o e texto durante o processamento de um bloco de c�digo permite atualizar o texto em tempo de execu��o 
@type function
/*/

User Function BIAMsgRun(cText, cHeader, bAction)
	
	Default bAction := {|| .T.}
	Default cHeader := "Processando"
	Default cText := "Processando a rotina..."
	
	FWMsgRun(, bAction, cHeader, cText)

Return()