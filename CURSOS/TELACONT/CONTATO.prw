//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari�veis Est�ticas
Static cTitulo := "Contatos da empresa"
User Function CONTATO()	   

	Local aArea   := GetArea()
	Local oBrowse
	Local cFunBkp := FunName()
	
	SetFunName("CONTATO")
	
	//Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("ZXV")

	//Setando a descri��o da rotina
	oBrowse:SetDescription(cTitulo)
	
	//Legendas
	oBrowse:AddLegend( "ZXV->ZXV_STATUS == '1'", "GREEN",	"Ativo" )
	oBrowse:AddLegend( "ZXV->ZXV_STATUS == '2'", "RED",	"Bloqueado" )
	
	//Filtrando LOGO QUANDO ABRE A TELA
	//oBrowse:SetFilterDefault("ZXV->ZXV_COD >= '000000' .And. ZXV->ZXV_COD <= 'ZZZZZZ'")
	
	//Ativa a Browse
	oBrowse:Activate()
	
	SetFunName(cFunBkp)
	RestArea(aArea)


/*
	Local aArea       := GetArea() 
	Local oBrowse     := nil
	private aRotina   := fMenuDef()
	private cCadastro := "Contatos" 	
   

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZXV')
	oBrowse:SetDescription(cCadastro)
	oBrowse:AddLegend("ZXV_STATUS = 'N'", "GREEN", "Novo") 
	oBrowse:AddLegend("ZXV_STATUS = 'A'", "RED"  , "Aprovado")
	oBrowse:Activate() 
	RestArea(aArea)*/
Return 

//menu
Static Function MenuDef()
	local aRotina := {}	
	//Adicionando op��es
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CONTATO' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1	
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CONTATO' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CONTATO' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CONTATO' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
	ADD OPTION aRotina TITLE 'Legenda'    ACTION 'U_CONTALEG'      OPERATION 6                      ACCESS 0 //OPERATION X	
return aRotina


Static Function ModelDef()

	//Blocos de c�digo nas valida��es
	//Local bPre := {|| u_zM1bPre()} //Antes de abrir a Tela
	//Local bPos := {|| u_zM1bPos()} //Valida��o ao clicar no Confirmar
	//Local bCom := {|| u_zM1bCom()} //Fun��o chamadao ao commit/salvar
	//Local bCan := {|| u_zM1bCan()} //Fun��o chamadao ao cancelar

	//Cria��o do objeto do modelo de dados
	Local oModel := Nil
	
	//Cria��o da estrutura de dados utilizada na interface
	Local oStZXV := FWFormStruct(1, "ZXV")
	
	//Editando caracter�sticas do dicion�rio
	oStZXV:SetProperty('ZXV_ID',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi��o
	oStZXV:SetProperty('ZXV_ID',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZXV", "ZXV_ID")'))          //Ini Padr�o
	//oStZXV:SetProperty('ZXV_NOME', MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->ZXV_NOME), .F., .T.)'))  //Valida��o de Campo
	
	
	//Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	//oModel := MPFormModel():New("MODCONTAT",/*bPre*/, /*u_zM1bPos*/, /*bCom*/, /*bCan*/) 
	 oModel := MPFormModel():New('MODCONTAT', { |oModel| CONCA01AAA(oModel)} , { |oModel| CONCA01VLD(oModel)})
	
	//Atribuindo formul�rios para o modelo
	oModel:AddFields("FORMZXV",/*cOwner*/,oStZXV)
	
	//Setando a chave prim�ria da rotina
	oModel:SetPrimaryKey({'ZXV_FILIAL','ZXV_ID'})
	
	//Adicionando descri��o ao modelo
	oModel:SetDescription(cTitulo)
	
	//Setando a descri��o do formul�rio
	oModel:GetModel("FORMZXV"):SetDescription("Formul�rio do Cadastro "+cTitulo)
Return oModel 



Static Function ViewDef()
	Local aStruZXV	:= ZXV->(DbStruct())
	
	//Cria��o do objeto do modelo de dados da Interface do Cadastro
	Local oModel := FWLoadModel("CONTATO")
	
	// o 2 � PARA VISUALIZAR NA VIEWDEF
	//Cria��o da estrutura de dados utilizada na interface
	Local oStZXV := FWFormStruct(2, "ZXV")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'ZXV_NOME|ZXV_CPF|'}
	
	//Criando oView como nulo
	Local oView := Nil

	//Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Atribuindo formul�rios para interface
	oView:AddField("VIEW_ZXV", oStZXV, "FORMZXV")  //ESSE FORMZXV � da fun��o  ModelDef ***PRECISA SER IGUAL***
	
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	
	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('VIEW_ZXV', 'Dados - '+cTitulo )  
	
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	
	//O formul�rio da interface ser� colocado dentro do container
	oView:SetOwnerView("VIEW_ZXV","TELA")
	
	/*
	//Tratativa para remover campos da visualiza��o
	For nAtual := 1 To Len(aStruZXV)
		cCampoAux := Alltrim(aStruZXV[nAtual][01])
		
		//Se o campo atual n�o estiver nos que forem considerados
		If Alltrim(cCampoAux) $ "ZXV_COD;"
			oStZXV:RemoveField(cCampoAux)
		EndIf
	Next
	*/
Return oView


User Function CONTALEG()
	Local aLegenda := {}
	
	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",		"Ativo"  })
	AADD(aLegenda,{"BR_VERMELHO",	"Bloqueado"})
	
	BrwLegenda(cTitulo, "Status", aLegenda)
Return





//----------------------------------------
//Valida��es das a��es da enchoice (crud)
//----------------------------------------


Static Function CONCA01AAA(oModel)
	Local aArea      := GetArea()		
	Local nOpc       := oModel:GetOperation()
	Local lRet       := .T.
	
	//ALERT("ENTROU NO PRE")
 
 	RestArea(aArea)
Return lRet


Static Function CONCA01VLD(oModel)   
	Local aArea      := GetArea()		
	Local nOpc       := oModel:GetOperation()
	Local lRet       := .T.
		 
	ALERT(oModel:GetValue('FORMZXV','ZXV_NOME'))
	 
	If (Empty(oModel:GetValue('FORMZXV','ZXV_NOME')) .Or. Alltrim(Upper(oModel:GetValue('FORMZXV','ZXV_NOME'))) == "")
		ALERT("aQUI") 
	EndIf
	
	//Se for Inclus�o		
	/*If nOpc == MODEL_OPERATION_INSERT .OR. nOpc == MODEL_OPERATION_UPDATE 		 	
		If Alltrim(Upper(Empty(oModel:GetValue('FORMZXV','ZXV_NOME'))))
			lRet := .F.
			Aviso('Aten��o', 'Campo nome esta em branco!', {'OK'}, 03)
		Else
			Aviso('Aten��o', 'Opera��o realizada com sucesso!', {'OK'}, 03)
			//ConfirmSX8() //Confirma a utilza��o da sequencia numerica definida
		EndIf
	EndIf*/
	RestArea(aArea)
	
Return lRet



 




 