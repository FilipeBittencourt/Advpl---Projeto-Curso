#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} TMKBARLA
@author Marcos Alberto Soprani
@since 06/11/2011
@version 1.0
@description Ponto de entrada para inclus�o de rotinas barra lateral da tela de Telecobran�a.
@type function
/*/

User Function TMKBARLA(aBotao, aTitulo)
	
	aAdd(aBotao, {"POSCLI", {|| U_ATALHOS() }, "Posi��o de Cliente"})
	aAdd(aBotao, {"BAIXATIT", {|| U_IMP_SK1() }, "Imp.Tit. p/ Cliente"})
	
	// Tiago Rossini Coradini - 25/10/2016 - OS: 3762-16 - Clebes Jose - Inclus�o da rotina de Hist�rico de Tarifas na tela de Telecobran�a. 
	aAdd(aBotao, {"BUDGETY", {|| U_BIAF050() }, "Hist�rico de Tarifas"})

Return(aBotao)