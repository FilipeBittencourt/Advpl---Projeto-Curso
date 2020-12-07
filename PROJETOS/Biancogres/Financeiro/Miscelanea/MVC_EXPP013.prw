#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} MVC_ITEM
@author Tiago Rossini Coradini
@since 07/01/2020
@version 1.0
@description Pontos de entrada MVC da rotina EECAT140 - Cota��o de Moedas - O ID do modelo da dados da rotina EECAT140 � EXPP013.
@type function
/*/

User Function EXPP013()
Local aParam := ParamIxb
Local xRet := .T.
Local oObj := ""
Local cIdPonto := ""
Local cIdModel := ""
Local nOp := 0
Local aArea := GetArea()

	If !Empty(aParam)

		oObj := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]
		nOp := oObj:GetOperation()
	
    // Chamada na ativa��o do modelo de dados
    If cIdPonto == "MODELVLDACTIVE"

    // Chamada na valida��o total do modelo
    ElseIf cIdPonto == "MODELPOS"    

    // Chamada na valida��o total do formul�rio
    ElseIf cIdPonto == "FORMPOS"

    // Chamada na pr� valida��o da linha do formul�rio
    ElseIf cIdPonto == "FORMLINEPRE"

    // Chamada na valida��o da linha do formul�rio.
    ElseIf cIdPonto == "FORMLINEPOS"

    // Chamada ap�s a grava��o total do modelo e dentro da transa��o
    ElseIf cIdPonto == "MODELCOMMITTTS"
        
      // Incluir
      If nOp == 3 .Or. nOp == 4
      
      	U_BIAF141(nOp)

      // Excluir
      ElseIf nOp == 5
      	
      EndIf
        
    // Chamada ap�s a grava��o total do modelo e fora da transa��o
    ElseIf cIdPonto == "MODELCOMMITNTTS"
        
    // Chamada ap�s a grava��o da tabela do formul�rio
    ElseIf cIdPonto == "FORMCOMMITTTSPRE"
        
    // Chamada ap�s a grava��o da tabela do formul�rio
    ElseIf cIdPonto == "FORMCOMMITTTSPOS"

    // Chamada no Bot�o Cancelar
    ElseIf cIdPonto == "MODELCANCEL"
        
    // Adicionando Botao na Barra de Botoes (BUTTONBAR)
    ElseIf cIdPonto == "BUTTONBAR"

    EndIf
	    
	EndIf
	
	RestArea(aArea)	
	
Return(xRet)