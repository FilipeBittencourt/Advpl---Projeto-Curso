#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} F340VLD
@author Marcos Alberto Soprani
@since 14/12/17
@version 1.0
@description Ponto de Entrada que permite validar se um t�tulo ser� ou n�o compensado.
@obs O motivo da implementa��o original deste ponto de entrada foi a necessidade de controlar qual titulo deveria estar posicionodo no browser para que a compensa��o
.    contabilizasse corretamente  
@type function
/*/

USER FUNCTION F340VLD()

	Local lRetComp := .T.

	If MV_PAR02 == 2

		If !SE2->E2_TIPO $ "PA /NDF"

			lRetComp := .F.
			MsgINFO("Para o processo de compensa��o com fornecedores DIFERENTES somente � permitido estando posicionando em T�TULOS do TIPO = PA")

		EndIf 

	EndIf

Return lRetComp
