//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


/*/{Protheus.doc} TSTFIL1
Exemplo de Modelo 1 para cadastro de Artistas 
/*/
// U_TSTFIL1()
User Function TSTFIL1()
	Local aArea   := GetArea()
	Local oBrowse
	Local cFunBkp := FunName()
	/* Favor n�o alterar a ordem
		1   Tela do Tempo Carr.
		2   Tela do No Show.
		3   Tela do Sa�de Est.
		4   Tela do Estoque
		5   Tela do Cumpr.Prz.Disp.
	*/

	Private oJSTela := 	TSTFIL001()
	Private cTitulo := "Metas Dashboard Log�stica tipo: "+UPPER(oJSTela["NomeOpcao"])


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

	SetFunName(cFunBkp)
	RestArea(aArea)
Return Nil



Static Function TSTFIL001()

	Local aRet        := {}
	Local aOpSX3      := {"Tempo Carr.","No Show","Sa�de Est","Estoque","Cumpr.Prz.Disp"}
	Local oJSParam    := JsonObject():New()
	Private aParamBox := {}

	aAdd(aParamBox,{3,"Tipo de cadastros",1,aOpSX3,50,"",.F.})

	If ParamBox(aParamBox,"Escolha o tipo de Meta que deseja cadastrar",@aRet)

		oJSParam["Indice"]    := aRet[1]
		oJSParam["NomeOpcao"] := aParamBox[1,4,aRet[1]]
		oJSParam["CodigoSX3"]  := PadL(AllTrim(cValToChar(aRet[1])) , 2 , "0")

	Endif

Return oJSParam


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
	oModel := MPFormModel():New("TSTFIL1M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/)  
//	oModel := MPFormModel():New('TSTFIL1M', {|oModel| fPreValidCad(oModel)},{|oModel| fTudoOK(oModel)},{|oModel| fCommit(oModel)},{|oModel| fCancel(oModel)} )

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
	oView:SetCloseOnOk({||.T.})
	
	//O formul�rio da interface ser� colocado dentro do container
	oView:SetOwnerView("VIEW_ZDL","TELA")
		
Return oView


/*User Function zMod1Leg()
	Local aLegenda := {}

	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",		"Menor ou igual a 5"  })
	AADD(aLegenda,{"BR_VERMELHO",	"Maior que 5"})

	BrwLegenda(cTitulo, "Status", aLegenda)
Return*/