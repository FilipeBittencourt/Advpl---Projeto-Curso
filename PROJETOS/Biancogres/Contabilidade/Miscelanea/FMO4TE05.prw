#include "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"

/*/{Protheus.doc} FMO4TE05
@description MO 4.0 Valores Auxiliares - Deprecia��o Or�ada
@author Ranisses A. Corona
@since 31/01/2021
@version 1.0
@type function
/*/
User Function FMO4TE05()

	Local aArea       := GetArea()
	Local oBrowse     := nil

	private aRotina   := fMenuDef()
	private cCadastro := "MO 4.0 Valores Auxiliares - Deprecia��o Realizada"

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZFG')
	oBrowse:SetDescription(cCadastro)
	oBrowse:Activate()

	RestArea(aArea)

Return   

Static Function fMenuDef()

	local aRotina := {} 
	aRotina := {{"Pesquisar"   	,"AxPesqui"   , 0, 1},;     
	{            "Visualizar"  	,"AxVisual" , 0, 2},; 
	{            "Incluir"		,"AxInclui" , 0, 3},;
	{            "Alterar"		,"AxAltera" , 0, 4},;
	{            "Excluir"		,"AxDeleta" , 0, 5}}	

return aRotina