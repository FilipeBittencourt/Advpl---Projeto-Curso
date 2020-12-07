#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} F420FIL
@author Wlysses Cerqueira (Facile)
@since 24/09/2018
@project Automa��o Financeira
@version 1.0
@description Classe com as regras para gera��o de borderos de recebimento, agrupados por regras/banco
@type class
/*/

User Function F420FIL()

	Local oObj := TAFCnabPagar():New()

	oObj:SetPergunte()

Return()