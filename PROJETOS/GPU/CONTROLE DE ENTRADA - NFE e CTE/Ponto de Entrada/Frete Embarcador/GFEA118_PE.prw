#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH" 

/*/{Protheus.doc} CUSTOMERVENDOR
PE AP�S A GRAVA��O DO FORNECEDOR NO BANCO DE DADOS.
PARAMETROS -> INCLUIR = 3 ALTERAR = 4 EXCLUIR = 5
@type function
@author WLYSSES CERQUEIRA (FACILE)
@since 12/11/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function GFEA118()

	Local xRet 		:= .T.	

	If PARAMIXB <> NIL
		
		If PARAMIXB[2] == "BUTTONBAR"
						
			xRet := {{"Autoriz. Gerente", "SALVAR", {|| U_VIX259GF()}}}		

		EndIf

	Endif

Return(xRet)