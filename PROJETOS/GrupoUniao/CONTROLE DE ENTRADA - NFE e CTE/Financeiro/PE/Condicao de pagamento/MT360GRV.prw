
#INCLUDE 'FWMVCDEF.CH'
#Include "Protheus.ch"


/*/{Protheus.doc} MT360GRV
Este ponto de entrada � executado apos a atualiza��o de todas as tabelas da rotina de
condi��o de pagamento nas opera��es de inclus�o, altera��o e exclus�o.

@author Sandro Costa
@since 07/06/2017
@version 1.0

@return Nil, Nao esperado

@example
(examples)

@see (links_or_references)
/*/

User Function MT360GRV()
	
	Local nI
	Local oObj := VIXA258():New()
	
	If INCLUI .and. MsgYesNO("Deseja cadastrar essa condi��o para as demais filiais?")
		aFiliais	:= GetFiliais()
		
		If Len(aFiliais) > 0
			BEGIN TRANSACTION
			For nI := 1 to Len(aFiliais)
				cFilAtuE4 := AllTrim(aFiliais[nI])
				If !Posicione("SE4",1,cFilAtuE4+M->E4_CODIGO,"FOUND()") // Se nao existir o codigo, cadastra na filial selecionada
//					lRet := MyMata360(cFilAtuE4)
					lRet := CriaSE4(cFilAtuE4)
					If !lRet
						DisarmTransaction()
						Exit
					EndIf
				Else
					Alert("C�digo "+M->E4_CODIGO + " J� existe na filial "+cFilAtuE4)
				EndIf
			Next nI
			END TRANSACTION
		EndIf
	EndIf	

	oObj:WorkFlowSE4() // Envia email se a condi��o de pagamento for altereada, caso a mesma esteja vinculada a um fornecedor

Return()


Static Function GetFiliais
	Local aFiliais
	aFiliais := U_SelFil01() // Fun��o generica de tela de filiais
	
	If Len(aFiliais) == 0
		Alert("N�o foi selecionada ao menos 1 filial. Criando somente para a atual.")
	EndIf
	
Return aFiliais

Static Function CriaSE4(cFilialAtu)
	Local lRet := .T.
	If !Posicione("SX3",1,"SE4","FOUND()")
		Alert("SX3 da tabela SE4 n�o localizada, favor contactar o TI.")
		Return
	EndIf
	
	RECLOCK("SE4",.T.)
	//Populando Cabe�alho
	Do While !SX3->(EOF()) .and. SX3->X3_ARQUIVO == "SE4"
		cCampo := SX3->X3_CAMPO
		If AllTrim(cCampo) $ "E4_FILIAL"
			SE4->&(cCampo) := cFilialAtu
		Else
			SE4->&(cCampo) := M->&(cCampo)
		EndIf
		SX3->(DbSkip())
	EndDo
	SE4->(MsUnLock())

Return lRet

Static Function MyMata360(cFilialAtu)
	//DEFININDO vari�veis
	Local aItemAux := {} //Array auxiliar para inser��o dos itens
	Local aDados := {} //Array do cabe�alho (SE4)
	Local aItens := {} //Array que ir� conter os itens (SEC)
	Local lRet := .T.
	Private lMsErroAuto := .F. //Indicador do status p�s chamada
	
	If !Posicione("SX3",1,"SE4","FOUND()")
		Alert("SX3 da tabela SE4 n�o localizada, favor contactar o TI.")
		Return
	EndIf
	
		
	//Populando Cabe�alho
	Do While !SX3->(EOF()) .and. SX3->X3_ARQUIVO == "SE4"
		cCampo := SX3->X3_CAMPO
		If AllTrim(cCampo) $ "E4_FILIAL"
			aAdd(aDados, {cCampo , cFilialAtu, Nil})
		Else
			aAdd(aDados, {cCampo , M->&(cCampo), Nil})
		EndIf
		SX3->(DbSkip())
	EndDo
	
	
	//Chamando rotina autom�tica de inclus�o
	MSExecAuto({|x,y,z|mata360(x,y,z)},aDados,aItens, 3)
	
	//Verificando status da rotina executada
	If lMsErroAuto
		MostraErro()
		lRet := .F.
	EndIf
	
Return lRet