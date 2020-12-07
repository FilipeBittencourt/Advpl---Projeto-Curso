#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} MVC_ITEM
@author Tiago Rossini Coradini
@since 07/01/2020
@version 1.0
@description Pontos de entrada MVC da rotina MATA010 - Produto - O ID do modelo da dados da rotina MATA010 � ITEM.
@type function
/*/

User Function Item()
Local aParam := ParamIxb
Local xRet := .T.
Local nDesc := ""
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
    
    	If oObj <> NIL
         
            //Ticket 24840 - N�o permitir caracter especial em cadastro de produtos.
            //Esta valida��o j� � feita pelo BIAF027 no gatilho do campo B1_DESC, mas aqui adicionamos < e > para serem removidos
	    	nDesc := oObj:GetModel():GetValue('SB1MASTER', 'B1_DESC') 
            
            //remover caracteres especiais > e <
	        nDesc := StrTran(nDesc,CHR(60),"") //simbolo <
	        nDesc := StrTran(nDesc,CHR(62),"") //simbolo >
	        oObj:SetValue("B1_DESC", nDesc)
             
	    EndIf
    	
    // Chamada na pr� valida��o da linha do formul�rio
    ElseIf cIdPonto == "FORMLINEPRE"

    // Chamada na valida��o da linha do formul�rio.
    ElseIf cIdPonto == "FORMLINEPOS"

    // Chamada ap�s a grava��o total do modelo e dentro da transa��o
    ElseIf cIdPonto == "MODELCOMMITTTS"
       
      // Incluir
      If nOp == 3
      	
      	U_BIAF157(nOp)
      	
				If Alltrim(SB1->B1_TIPO) $ GetMv("MV_YEXPECO") .And. (Substr(Alltrim(SB1->B1_COD), Len(Alltrim(SB1->B1_COD)), 1) $ "1_2_3")
			
					Processa({|| U_EXPECO(1)})
			
				EndIf
			
				// Projeto PDM - Fernando em 14/08/2018 - Gravar dados das caracteristicas do PDM relacionado ao produto. Vem da classe TPDMProduto ap�s tela de sele��o
				If !Empty(SB1->B1_YPDM) .And. Type("__MEMPDM_ALST") <> "U"
			
					oPDMPrd := TPDMProduto():New()		
					oPDMPrd:Tipo := SB1->B1_TIPO
			
					If oPDMPrd:SetPDM(SB1->B1_YGRPPDM, SB1->B1_YSUBPDM, SB1->B1_YFAMPDM)
			
						oPDMPrd:aLstValCar := AClone(__MEMPDM_ALST)
			
						oPDMPrd:IncluiZD7(SB1->B1_COD)
			
						__MEMPDM_ALST := Nil
			
					EndIf
			
				EndIf
				
				If Type("_ObjCrePd_") == "O"
				
					_ObjCrePd_:SalvarMarca()
					
					_ObjCrePd_ := Nil
				
				EndIf			
			
				If SB1->B1_TIPO == "PA" .and. SB1->B1_YCLASSE = "1"
			
					U_BIA736Prc(SB1->B1_COD, SB1->B1_COD)
			
				EndIf
      	
      // Alterar
      ElseIf nOp == 4

      	U_BIAF157(nOp)

      // Excluir
      ElseIf nOp == 5

	      // Exclui o SB5	
				DbSelectArea("SB5")
				SB5->(DbSetOrder(1))
				If SB5->(DbSeek(xFilial("SB5") + SB1->B1_COD))

					Reclock("SB5", .F.)
					
						SB5->(DbDelete())
						
					MsUnlock()
					
				EndIf
			
      	
      EndIf
        
    // Chamada ap�s a grava��o total do modelo e fora da transa��o
    ElseIf cIdPonto == "MODELCOMMITNTTS"
        
    // Chamada ap�s a grava��o da tabela do formul�rio
    ElseIf cIdPonto == "FORMCOMMITTTSPRE"
        
        
    // Chamada ap�s a grava��o da tabela do formul�rio
    ElseIf cIdPonto == "FORMCOMMITTTSPOS"

    // Chamada no Bot�o Cancelar
    ElseIf cIdPonto == "MODELCANCEL"
    
    	If nOp == 5
    		
    		ResSBZ()
    		
    	EndIf
    	
    // Adicionando Botao na Barra de Botoes (BUTTONBAR)
    ElseIf cIdPonto == "BUTTONBAR"
    	
    	If nOp == 5
    	
    		xRet := {{"Excluir Indicador", "EXINDI", {|| DelSBZ()}} }
    			
    	EndIf
    	 
    EndIf
	    
	EndIf
	
	RestArea(aArea)	
	
Return(xRet)


Static Function ResSBZ()
Local cQuery 	:= ""
Local cCodigo	:= SB1->B1_COD
	
	DbSelectArea("SBZ")
	SBZ->(DbSetOrder(1))
	If SBZ->(DbSeek(xFilial("SBZ")+SB1->B1_COD))
		
		cQuery := "UPDATE "+ RetSqlName("SBZ")+" SET D_E_L_E_T_ = '', R_E_C_D_E_L_ = 0  WHERE BZ_COD = '"+cCodigo+"' AND D_E_L_E_T_ = '*' "
		TCSQLEXEC(cQuery)

	EndIf			

Return


Static Function DelSBZ()
Local cQuery 	:= ""
Local cCodigo	:= SB1->B1_COD
	
	
	DbSelectArea("SBZ")
	SBZ->(DbSetOrder(1))
	If SBZ->(DbSeek(xFilial("SBZ")+SB1->B1_COD))
		
		If MsgYesNo("Produto possui informa��es cadastrado na tabela SBZ: 'Indicadores'. Deseja excluir para continuar?","ATEN��O - Exclus�o de Produto")
		   
		   cQuery := "UPDATE "+ RetSqlName("SBZ")+" SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_  WHERE	BZ_COD = '"+cCodigo+"' AND D_E_L_E_T_ = '' "
		   
		   TCSQLEXEC(cQuery)
		   
		EndIf

	EndIf		
		
Return