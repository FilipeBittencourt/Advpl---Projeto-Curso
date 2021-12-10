#include "PROTHEUS.CH"
#include "FWMBROWSE.CH"
#include "FWMVCDEF.CH"
#include "rwmake.ch"


#define STRU_CAB "CamposZKO"
#define cTitle "FIDC - Recompra"

/*/{Protheus.doc} BIAFP004
Tela para manuten��o do processo de recompra a receber
@type function
@version 1.0
@author Pontin - Facile Sistemas
@since 16/08/2021
/*/
User Function BIAFP004()

	Local aArea := ZKO->(GetArea())

	Private oMark

	SetKey(VK_F11, { || U_BIAFP04F() } )// Atalho para o filtro

	oMark:=FWMarkBrowse():NEW()		      // Cria o objeto oMark - MarkBrowse   

  oMark:AddLegend("ZKO_SITUAC = 'A'", "GREEN"   , "Em Aberto") 
	oMark:AddLegend("ZKO_SITUAC = 'P'", "YELLOW"  , "Pendente FIDC")
	oMark:AddLegend("ZKO_SITUAC = 'F'", "RED"     , "Finalizado")

	oMark:SetAlias("ZKO")			          // Define a tabela do MarkBrowse
	oMark:SetDescription(cTitle)	      // Define o titulo do MarkBrowse
	oMark:SetFieldMark("ZKO_OK")	      // Define o campo utilizado para a marcacao
	oMark:SetFilterDefault()		        // Define o filtro a ser aplicado no MarkBrowse  

	oMark:SetAllMark( { || AllMark() } )

	oMark:Activate()  

	SetKey( VK_F11, { || } )  //Atalho para o filtro

	RestArea(aArea)
  
Return 


// Montar o menu Funcional
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE "Visualizar" 							ACTION "VIEWDEF.BIAFP004" 	  OPERATION 2 ACCESS 0
  ADD OPTION aRotina TITLE "Filtrar"    							ACTION "U_BIAFP04F" 		      OPERATION 3 ACCESS 0
  ADD OPTION aRotina TITLE "Enviar Workflow FIDC"			ACTION "U_BIAFP04W" 		      OPERATION 8 ACCESS 0
  ADD OPTION aRotina TITLE "Buscar Confirma��o FIDC"	ACTION "U_BIAFP04B" 		      OPERATION 8 ACCESS 0

Return aRotina


//Funcoes auxiliares para controle de filtro e marcacao
Static Function AllMark()

	oMark:GoTop()

	While (.T.)
		If !oMark:IsMark()
			oMark:MarkRec()
		EndIf

		oMark:GoDown()
		If ( oMark:At() == oMark:oBrowse:nLen ) 
			If !oMark:IsMark()
				oMark:MarkRec()
			EndIf
			Exit
		EndIf	
	EndDo

	oMark:GoTop()
	oMark:Refresh()

Return 


Static Function ClearMark()

	oMark:GoTop()

	While (.T.)
		If oMark:IsMark()
			oMark:MarkRec()
		EndIf

		oMark:GoDown()
		If ( oMark:At() == oMark:oBrowse:nLen ) 
			If !oMark:IsMark()
				oMark:MarkRec()
			EndIf
			Exit
		EndIf	
	EndDo

	oMark:GoTop()
	oMark:Refresh()

Return


//Perguntas para Filtro da Tela
User Function BIAFP04F()

	Local aPergs  := {}
	Local aRet    := { 1, Space(6) }

	aAdd( aPergs ,{3,"Situa��o: ",1,{"Em Aberto","Pendente Retorno FIDC","Finalizado"},300,Nil,.T.,Nil})

	aAdd( aPergs ,{1,"Cliente: ",Space(6),"@!","","SA1","",20,.F.})

	If ParamBox(aPergs ,"Filtrar T�tulos de recompra",aRet,,,,,,,,.F.,.F.)  
		U_BIAMsgRun("Filtrando...",, { || FilProc(aRet) } )
	EndIf   

Return


Static Function FilProc(aRet)

	Local _cFiltro  := ""
	Local _bAnd     := {|| IIf(!Empty(_cFiltro)," .And. ","") }

	ClearMark()         
	oMark:CleanFilter()   

	//STATUS                                   
	If ( aRet[1] == 1 )
		_cFiltro += " ZKO_SITUAC == 'A' "
	ElseIf ( aRet[1] == 2 )                   
		_cFiltro += " ZKO_SITUAC == 'P' "
  ElseIf ( aRet[1] == 2 )                   
		_cFiltro += " ZKO_SITUAC == 'F' "
	EndIf

	If !Empty(aRet[2])
		_cFiltro += Eval(_bAnd)+" ZKO_CLIENT == '"+aRet[2]+"' "
	EndIf

	oMark:SetFilterDefault(_cFiltro)

Return


//Definicoes da View
Static Function ViewDef()

	Local oView
	Local oModel	:= ModelDef()
	Local oStr1		:= FWFormStruct(2, 'ZKO')
	// Local nOpc		:= oModel:GetOperation()

	// Cria o objeto de View
	oView := FWFormView():New()     

	// Define qual o Modelo de dados ser� utilizado
	oView:SetModel(oModel)

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField('Formulario' , oStr1, STRU_CAB)

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'PAI', 100)

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView('Formulario','PAI')
	oView:EnableTitleView('Formulario' , cTitle )
	oView:SetViewProperty('Formulario' , 'SETCOLUMNSEPARATOR', {10})

	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})

Return oView


//Definicoes do Model
Static Function ModelDef()

	Local oModel
	Local oStr1   := FWFormStruct( 1, 'ZKO', /*bAvalCampo*/,/*lViewUsado*/ )   // Constru��o de uma estrutura de dados

	//Cria o objeto do Modelo de Dados
	//Irie usar uma fun��o MVC001V que ser� acionada quando eu clicar no bot�o "Confirmar"
	oModel := MPFormModel():New(cTitle, /*bPreValid*/ , , { | oMdl | MVCConfirm( oModel ) } ,, /*bCancel*/ )
	oModel:SetDescription(cTitle)

	// Adiciona ao modelo uma estrutura de formul�rio de edi��o por campo - Enchoice
	oModel:addFields(STRU_CAB,,oStr1,{|oModel|MVC001T(oModel)},,)

	oModel:SetPrimaryKey({'ZKO_FILIAL', 'ZKO_SITUAC'})

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:getModel(STRU_CAB):SetDescription(STRU_CAB)

Return oModel


//Apos gravar registro
Static Function MVCConfirm(oModel)

	// Local nOpc      := oModel:GetOperation()

	FWFormCommit(oModel)

Return .T.


Static Function MVC001T( oModel )

	Local lRet      := .T.

Return(lRet)



User Function BIAFP04W()
	
	Local cRecProcessa as Character
	Local cMensagem as Character
	Local lEnviaWF as Logical
	Local oRecompra as Object

	Default cMensagem := ""

	ZKO->(DbSetOrder(0))
	ZKO->(DbGoTop())

	While !ZKO->( EoF() )

		If ZKO->ZKO_OK == oMark:Mark()

			cRecProcessa	:= "Prefixo: " + ZKO->ZKO_PREFIX + " / Numero: " + AllTrim(ZKO->ZKO_NUM ) + " / Parcela: " + ZKO->ZKO_PARCEL

			If ZKO->ZKO_SITUAC == "F"
				cMensagem += cRecProcessa + CRLF
			Else

				lEnviaWF	:= .T.

				If ZKO->ZKO_SITUAC == "P"
					lEnviaWF	:= MsgYesNo("A recompra abaixo j� foi enviada para o FIDC, deseja enviar novamente?" + CRLF + CRLF + cRecProcessa, FunName())
				EndIf

				If lEnviaWF

					oRecompra	:= TFPFidcRecompraReceber():New()
					oRecompra:EnviaWorkflow( ZKO->( Recno() ) )

					FreeObj(oRecompra)

				EndIf

			EndIf

		EndIf

		ZKO->( dbSkip() )

	EndDo

	If !Empty(cMensagem)

			MsgInfo("As recompras abaixos n�o foram enviadas por e-mail devido a estarem Finalizadas!" + CRLF + CRLF + cMensagem, FunName())

	EndIf

	MsgInfo("Processo de envio de workflow finalizado!", FunName())

	oMark:GoTop()
	oMark:Refresh()

Return


User Function BIAFP04B()
	
	Local cRecProcessa as Character
	Local cMensagem as Character
	Local oRecompra as Object
	Local oResult as Object

	Default cMensagem := ""

	ZKO->(DbSetOrder(0))
	ZKO->(DbGoTop())

	While !ZKO->( EoF() )

		If ZKO->ZKO_OK == oMark:Mark()

			cRecProcessa	:= "Prefixo: " + ZKO->ZKO_PREFIX + " / Numero: " + AllTrim(ZKO->ZKO_NUM ) + " / Parcela: " + ZKO->ZKO_PARCEL

			If ZKO->ZKO_SITUAC $ "A/F"
				cMensagem += cRecProcessa + CRLF
			Else

				If ZKO->ZKO_SITUAC == "P"
					
					oRecompra	:= TFPFidcRecompraReceber():New()

					//|Verifica se o FIDC retornou a ocorr�ncia |
					If oRecompra:ValidaRetornoFIDC( ZKO->( Recno() ) )

						//|Gera t�tulo a pagar contra o FIDC |
						FWMsgRun(, {|| oResult := oRecompra:GeraContasPagar( ZKO->( Recno() ) ) }, "Processando", "Aguarde... Gerando t�tulo a pagar.")
						
						If !oResult:lOk

							Aviso(FunName(),"N�o foi poss�vel gerar o t�tulo a pagar da Recompra abaixo, seguem detalhes: " + CRLF +;
											cRecProcessa + CRLF + CRLF +;
											oResult:cMensagem,{"OK"},3)

						EndIf

					Else

						MsgAlert("N�o foi localizado ocorr�ncia de retorno do FIDC para o t�tulo abaixo: " + CRLF + CRLF+;
											cRecProcessa, FunName())
					
					EndIf

					FreeObj(oRecompra)

				EndIf

			EndIf

		EndIf

		ZKO->( dbSkip() )

	EndDo

	If !Empty(cMensagem)

			MsgInfo("As recompras abaixos n�o foram processadas devido a estarem Finalizadas ou em abertas!" + CRLF + CRLF + cMensagem, FunName())

	EndIf

	MsgInfo("Busca de confirma��o do FIDC finalizada!", FunName())

	oMark:GoTop()
	oMark:Refresh()

Return

