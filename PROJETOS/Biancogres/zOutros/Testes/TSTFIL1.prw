//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} TSTFIL1
Exemplo de Modelo 1 para cadastro de Artistas 
/*/
// U_TSTFIL1()
User Function TSTFIL1()

	Local aArea       := GetArea()
	Local oBrowse     := Nil
	Local cFunBkp     := FunName()
	Local aRet        := {}
	Local lParam      := .T.
	Local aOpSX3      := {"Tempo Carr.","No Show","Sa�de Est","Estoque","Cumpr.Prz.Disp"}


	Private oJSTela   := JsonObject():New()
	Private aParamBox := {}
	Private cTitulo   := " "

	aAdd(aParamBox,{3,"Tipo de cadastros",1,aOpSX3,50,"",.F.})

	while lParam == .T.

		If ParamBox(aParamBox,"Escolha o tipo de Meta que deseja cadastrar",@aRet)

			oJSTela["Indice"]    := aRet[1]
			oJSTela["NomeOpcao"]  := aParamBox[1,4,aRet[1]]
			oJSTela["CodigoSX3"]  := PadL(AllTrim(cValToChar(aRet[1])) , 2 , "0")

			cTitulo := "Metas Dashboard Log�stica tipo: "+UPPER(oJSTela["NomeOpcao"])

			SetFunName("TSTFIL1")

			//Inst�nciando FWMBrowse - Somente com dicion�rio de dados
			oBrowse := FWMBrowse():New()

			//Setando a tabela de cadastro de Autor/Interprete
			oBrowse:SetAlias("ZDL")

			//Setando a descri��o da rotina
			oBrowse:SetDescription(cTitulo)

			oBrowse:SetFilterDefault("ZDL->ZDL_TIPO == "+UPPER(oJSTela["CodigoSX3"])+"")
			//Ativa a Browse
			oBrowse:Activate()

		Else

			lParam := .F.

		Endif

	endDo


	SetFunName(cFunBkp)
	RestArea(aArea)

Return Nil


/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Cria��o do menu MVC                                          |
 *---------------------------------------------------------------------*/

Static Function MenuDef()
	
	Local aRot := {}
	
	//Adicionando op��es
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.TSTFIL1' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	//ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMod1Leg'      OPERATION 6                      ACCESS 0 //OPERATION X
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.TSTFIL1' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.TSTFIL1' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.TSTFIL1' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/

Static Function ModelDef()
	
	//Cria��o do objeto do modelo de dados
	
	Local oModel  := Nil
	
	//Cria��o da estrutura de dados utilizada na interface	
	Local oStZDL := NIL

	If oJSTela["CodigoSX3"] == "01"
		oStZDL := FWFormStruct(1, "ZDL", { |x| AllTrim(x) $ 'ZDL_DTINI|ZDL_DTFIM|ZDL_TIPO|ZDL_META|ZDL_MODVEI'})	
	ElseIf oJSTela["CodigoSX3"] == "02" .OR. oJSTela["CodigoSX3"] == "03"
		oStZDL := FWFormStruct(1, "ZDL", { |x| AllTrim(x) $ 'ZDL_DTINI|ZDL_DTFIM|ZDL_TIPO|ZDL_META'})	
	ElseIf oJSTela["CodigoSX3"] == "04" .OR. oJSTela["CodigoSX3"] == "05"
		oStZDL := FWFormStruct(1, "ZDL", { |x| AllTrim(x) $ 'ZDL_DTINI|ZDL_DTFIM|ZDL_TIPO|ZDL_META|ZDL_FORNO'})		
	EndIf
	
  oStZDL:SetProperty('ZDL_TIPO' , MODEL_FIELD_INIT, {|oView | oJSTela["CodigoSX3"]})	
	oStZDL:SetProperty('ZDL_TIPO' , MODEL_FIELD_WHEN,{|oView | .F. } ) // BLOQUEIA O CAMPO


  //Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	
	oModel := MPFormModel():New("TSTFIL1M",/*bPreValid*/,{|oModel| fTdOk(oModel)},/*<bCommit >*/,/*bCancel*/)  
  

	//Atribuindo formul�rios para o modelo
	oModel:AddFields("FORMZDL",/*cOwner*/,oStZDL)
	
	//Setando a chave prim�ria da rotina
	oModel:SetPrimaryKey({'ZDL_FILIAL','ZDL_TIPO'})
	
	//Adicionando descri��o ao modelo
	oModel:SetDescription(cTitulo)
	
	//Setando a descri��o do formul�rio
	oModel:GetModel("FORMZDL"):SetDescription(cTitulo)
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Cria��o da vis�o MVC                                         |
 *---------------------------------------------------------------------*/

Static Function ViewDef()

	Local aStruZDL	:= ZDL->(DbStruct())	
	Local oModel := FWLoadModel("TSTFIL1")	//Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete	
	Local oView := Nil //Criando oView como nulo	
	Local oStZDL := NIL //Cria��o da estrutura de dados utilizada na interface do cadastro
	
	If oJSTela["CodigoSX3"] == "01"
		oStZDL := FWFormStruct(2, "ZDL", { |x| AllTrim(x) $ 'ZDL_DTINI|ZDL_DTFIM|ZDL_TIPO|ZDL_META|ZDL_MODVEI'})	
	ElseIf oJSTela["CodigoSX3"] == "02" .OR. oJSTela["CodigoSX3"] == "03"
		oStZDL := FWFormStruct(2, "ZDL", { |x| AllTrim(x) $ 'ZDL_DTINI|ZDL_DTFIM|ZDL_TIPO|ZDL_META'})	
	ElseIf oJSTela["CodigoSX3"] == "04" .OR. oJSTela["CodigoSX3"] == "05"
		oStZDL := FWFormStruct(2, "ZDL", { |x| AllTrim(x) $ 'ZDL_DTINI|ZDL_DTFIM|ZDL_TIPO|ZDL_META|ZDL_FORNO'})		
	EndIf
	

	//Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Atribuindo formul�rios para interface
	oView:AddField("VIEW_ZDL", oStZDL, "FORMZDL")  //ESSE FORMZDL � da fun��o  ModelDef ***PRECISA SER IGUAL***
	
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	
	//Colocando t�tulo do formul�rio
	//oView:EnableTitleView('VIEW_ZDL', 'Dados - '+cTitulo )  
	
	//For�a o fechamento da janela na confirma��o
	//oView:SetCloseOnOk({||.T.})
	
	//O formul�rio da interface ser� colocado dentro do container
	oView:SetOwnerView("VIEW_ZDL","TELA")
		
Return oView


Static Function fTdOk(oModel)

	Local lRet   := .T.	
	Local cQuery := ""
	Local dDTINI := oModel:GetModel("FORMZDL"):GetValue('ZDL_DTINI')	
	Local dDTFIM := oModel:GetModel("FORMZDL"):GetValue('ZDL_DTFIM')	
	Local cQry   := GetNextAlias()

	If  EMPTY(dDTINI) .OR.EMPTY(dDTINI)
    	Help(,,"Help",,"Favor informar as datas de inicio e fim.", 1, 0,,,,,,{" "})
			RETURN .F.
	EndIf

	If oJSTela["CodigoSX3"] == "01"
		If EMPTY(oModel:GetModel("FORMZDL"):GetValue('ZDL_MODVEI'))
			Help(,,"Help",,"Favor informar o modelo do ve�culo.", 1, 0,,,,,,{" "})
			RETURN .F.
		EndIf
	EndIf

	If oJSTela["CodigoSX3"] $ "04#05"
		If EMPTY(oModel:GetModel("FORMZDL"):GetValue('ZDL_FORNO'))
    	Help(,,"Help",,"Favor informar o tipo do forno.", 1, 0,,,,,,{" "})
			RETURN .F.
		EndIf
	EndIf

	cQuery += " select * from ZDL010 "  + CRLF
	cQuery += " WHERE D_E_L_E_T_ = '' "  + CRLF
	cQuery += " AND ZDL_TIPO = "+ValToSql(oJSTela["CodigoSX3"])+ " "+ CRLF
	cQuery += " AND ZDL_DTFIM BETWEEN  "+ValToSql(dDTINI)+" AND " +ValToSql(dDTFIM)+" " + CRLF

	If oJSTela["CodigoSX3"] $ '04#05'
		
		cQuery += " AND ZDL_FORNO = "+ValToSql(oJSTela["CodigoSX3"])+ " "+ CRLF

	ElseIf oJSTela["CodigoSX3"] $ '01'

	  cQuery += " AND ZDL_MODVEI = "+ValToSql(oJSTela["CodigoSX3"])+ " "+ CRLF

	EndIf

	TcQuery cQuery New Alias (cQry)

	If !EMPTY((cQry)->ZDL_TIPO)
    lRet := .F.
		Help(NIL, NIL, "Help", NIL, "J� existe dados cadastrados com essas informa��es.", 1, 0,,,,,,{"Mude as datas de inicio e fim"})
	EndIf


Return (lRet)