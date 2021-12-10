#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} MTA161BUT
@author Tiago Rossini Coradini
@since 25/02/2021
@version 1.0
@description O Ponto de Entrada MTA161BUT, est� localizado na rotina Analise da Cota��o (MATA161), permite adicionar novas op��es no bot�o Outras A��es. 
@type functio
/*/

User Function MTA161BUT()
Local aRotina := PARAMIXB[1]

	aAdd(aRotina, {"Portal WebSC", "U_A130WEB", 0, 6, 0, Nil})
	aAdd(aRotina, {"Env.Email", "U_REENVIAEML", 0, 2, 0, Nil})
	
Return(aRotina)
