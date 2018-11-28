#Include 'Protheus.ch'
#Include 'Parmtype.ch'
#include "fwmvcdef.ch"

// https://www.youtube.com/watch?v=R3yjwYMkAhA        - AdvPL 017 - MVC
// https://www.youtube.com/watch?v=03fZSQpR3Rs&t=42s  - AdvPL 018 - Modelo 1 em MVC
// https://www.youtube.com/watch?v=iG1WClMfMiQ        - AdvPL 019 - Valida��es em MVC


//Vari�veis Est�ticas
Static cTitulo := "test"

User Function MVCMOD01()

	Local oBrowse
	Local aArea := GetAera()
	Local cFunBkp := FunName()
	
	SetFunName("MVCMOD01")
	
	oBrowse := FWMBrowse():New() // Fornece um objeto do tipo grid, bot�es laterais e detalhes das colunas baseado no dicion�rio de dados
	oBrowse:SetAlias('ZXV') // SELECINA A TABELA QUE IR� SER EXIBIDA
	oBrowse:SetDescription(cTitulo) // NOME DO TITULO Que aparece no topo
	
	
	oBrowse:AddLegend("ZXV->ZXV_STATUS == 'A'" ,"GREEN","Ativo")
	oBrowse:AddLegend("ZXV->ZXV_STATUS == 'B'" ,"RED","Bloqueado")
	oBrowse:AddLegend("ZXV->ZXV_STATUS != 'B' .Or. ZXV->ZXV_STATUS != 'A'" ,"BLACK","XXX")			
	oBrowse:Activate() // ativa  a fun��o para aparecer
	
	SetFunName(cFunBkp)
	RestArea(aArea)
	
Return Nil


//------------------------------
//Defini��o do menu da rotina
//------------------------------
Static Function MenuDef()
	
	Local aRotina := {}	
	ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.MVCMOD01' OPERATION 1 ACCESS 0
	//ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.MVCMOD01' OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Incluir'    Action 'VIEWDEF.MVCMOD01' OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar'    Action 'VIEWDEF.MVCMOD01' OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir'    Action 'VIEWDEF.MVCMOD01' OPERATION 5 ACCESS 0	
	ADD OPTION aRotina Title 'Legenda'    Action 'U_MVC01LEG' OPERATION 6 ACCESS 0                                                                                             

Return(aRotina)



//------------------------------
//Defini��o do modelo de dados
//------------------------------
Static Function ModelDef()
	//Cria��o do objeto do modelo de dados
	Local oModel := Nil
	
	//Cria��o da estrutura de dados utilizada na interface
	Local oStZXV := FWFormStruct(1, "ZXV")
	
	//Editando caracter�sticas do dicion�rio
	oStZXV:SetProperty('ZXV_ID',   MODEL_FIELD_WHEN,  FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.')) //Modo de Edi��o
	oStZXV:SetProperty('ZXV_ID',   MODEL_FIELD_INIT,  FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZXV", "ZXV_ID")'))         //Ini Padr�o
	//oStZXV:SetProperty('ZXV_CPF',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->ZXV_DESC), .F., .T.)'))   //Valida��o de Campo
	//oStZXV:SetProperty('ZXV_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigat�rio
	
	//Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("zModel1M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
	
	//Atribuindo formul�rios para o modelo
	oModel:AddFields("FORMZXV",/*cOwner*/,oStZXV)
	
	//Setando a chave prim�ria da rotina
	oModel:SetPrimaryKey({'ZXV_FILIAL'})
	
	//Adicionando descri��o ao modelo
	oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
	
	//Setando a descri��o do formul�rio
	oModel:GetModel("FORMZXV"):SetDescription("Formul�rio do Cadastro "+cTitulo)
Return oModel


Static Function ViewDef()
	Local aStruZXV	:= ZXV->(DbStruct())
	
	//Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
	Local oModel := FWLoadModel("MVCMOD01")
	
	//Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStZXV := FWFormStruct(2, "ZXV")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZXV_NOME|SZXV_DTAFAL|'}
	
	//Criando oView como nulo
	Local oView := Nil

	//Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Atribuindo formul�rios para interface
	oView:AddField("VIEW_ZXV", oStZXV, "FORMZXV")
	
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


User Function U_MVC01LEG()
	Local aLegenda := {}
	
	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",		"Ativo"  })
	AADD(aLegenda,{"BR_VERMELHO",	"Bloqueado"})
	AADD(aLegenda,{"BR_PRETO",	"INDEFINIDO"})
	
	BrwLegenda(cTitulo, "Status", aLegenda)
Return



