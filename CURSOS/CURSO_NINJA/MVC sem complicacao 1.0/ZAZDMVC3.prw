//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

Static cCadastro := "Chamados por atendente"
//-------------------------------------------------------------------
/*/{Protheus.doc} ZAZDMV3

Cadastro MVC de Tela de Chamado por atendente

@author Filipe Vieira
@since 27/10/2018 
@version 
/*/
//-------------------------------------------------------------------
User Function ZAZDMVC3()

	Local aArea  := GetArea()
	Local oBrw := FwMBrowse():New()
	oBrw:SetDescription(cCadastro) 
	oBrw:SetAlias("ZZA")
	oBrw:Activate()
	RestArea(aArea)

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef

Funcao generica MVC do model

@return oModel - Objeto do Modelo MVC

@author Filipe Vieira
@since 27/10/2018 
@version 
/*/
//-------------------------------------------------------------------
Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oModel		:= Nil
	Local oStruZZA  := FwFormStruct(1,"ZZA")  // N�o filtre campos da ModelDef, deixe isso apenas para ViewDef
	Local oStruZZD  := FwFormStruct(1,"ZZD") // N�o filtre campos da ModelDef, deixe isso apenas para ViewDef	 
	Local bPosValidacao  := {|oModel| PosValid(oModel)}	
	
	Local bLinePre  := {|oModelGrid, nLine, cAction, cField| LinePre(oModelGrid, nLine, cAction, cField)} //http://tdn.totvs.com/display/framework/MPFormModel
	Local bLinePost  := {|oModelGrid| LinePos(oModelGrid)}	
	//Local bInitDados  := {|oModelGrid| InitDados(oModelGrid)}
	Local aZZDRel		:= {}
	Local nMax := Val(Replicate("9",TamSX3("ZZD_COD")[1]))

	 
	
	//Cria/Instanciando o objeto do Modelo de Dados, n�o � recomendado, respeitar 10 caracteres no ID(ZAZDMV3_M) 
	oModel := MPFormModel():New("ZAZDMV3_M", /*bPreValidacao*/,bPosValidacao,/*bCommit*/,/*bCancel*/ ) 
	oModel:AddFields("ZZAMASTER",/*cOwner*/,oStruZZA, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )// Adiciona ao modelo um componente de formul�rio
		 
	//oModel:AddTrigger("ZZD_TECNIC","ZZD_NOMTEC","Gatilhos()",.F.,Nil,Nil,Nil,)//Cria gatilhos

	
	//Amarra��o das tabelas. Aqui voc� diz que o filho(ZZDDETAIL) pertence ao pai(ZZAMASTER) passando a estrutura do filho oStruZZD
	//oModel:AddGrid( "ZZDDETAIL", "ZZAMASTER", oStruZZD,/*bLinePre*/, /*bLinePos*/ ,/*bPreVal*/ , , /*bLoad*/)	
	oModel:AddGrid( "ZZDDETAIL", "ZZAMASTER", oStruZZD, /*bLinePre*/, bLinePost ,/*bPreVal*/, , /*bLoad*/)
		
	//Os relacionamentos s�o sempre do filho(ZZDDETAIL) e os campos seguem a mesma ordem do FILHO para o PAI SEMPRE!!!		  
	aAdd(aZZDRel, {"ZZD_FILIAL","xFilial('ZZA')"} )
	aAdd(aZZDRel, {"ZZD_TECNIC",'ZZA_COD'} )
	//oModel:SetRelation( "ZZDDETAIL", { { "ZZD_FILIAL", "xFilial('ZZA')" }, { "ZZD_TECNIC", "ZZA_COD" } }, ZZD->(IndexKey(1)) )	
	oModel:SetRelation( "ZZDDETAIL", aZZDRel , ZZD->(IndexKey(1)) )

	
	oModel:SetDescription(cCadastro) // Nome do modelo	
	oModel:GetModel("ZZAMASTER" ):SetDescription("Cabe�alho")// Adiciona a descri��o do Componente do Modelo de Dados
	oModel:GetModel("ZZDDETAIL" ):SetDescription("Itens")// Adiciona a descri��o do Componente do Modelo de Dados			
	
	oModel:GetModel("ZZDDETAIL" ):SetMaxLine(nMax) // Limita a quantidades de linhas de uma grid.

	//Permiss�o da linha
	oModel:GetModel('ZZDDETAIL'):SetNoInsertLine(.T.)
	oModel:GetModel('ZZDDETAIL'):SetNoDeleteLine(.T.)


	oModel:SetPrimaryKey({'ZZA_FILIAL','ZZA_COD'}) // ou 	oModel:SetPrimaryKey({}) //Defina a chave primaria  

	oModel:GetModel('ZZDDETAIL'):SetOptional(.T.) // Para permitir que o Grid sem dados ou n�o  .T. � opcional
	
	oModel:SetActivate()
	
	// Retorna o Modelo de dados 
Return(oModel)

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef

Funcao generica MVC do View

@return oView - Objeto da View MVC

@author Filipe Vieira 
@since 27/10/2018 
@version 
/*/
//-------------------------------------------------------------------
Static Function ViewDef()

	Local oModel  := FwLoadModel("ZAZDMVC3") // Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado
	Local oStrZZA := FWFormStruct(2, "ZZA" , {|cCpo| AllTrim(cCpo)$'ZZA_COD+ZZA_NOME' } )// Cria a estrutura a ser usada na View 
	Local oStrZZD := FWFormStruct(2, "ZZD")
	 
	Local oView := FWFormView():New() // Cria o objeto de View
	
	oStrZZD:SetNoFolder()// ABAS	
	oView:SetModel(oModel)// Define qual o Modelo de dados ser� utilizado na View

	// Adiciona no nosso View um controle do tipo formul�rio (antiga Enchoice)
	oView:AddField( 'VIEW_ZZA' , oStrZZA, 'ZZAMASTER' )
	oView:AddGrid ( 'VIEW_ZZD' , oStrZZD, 'ZZDDETAIL' )

	// Criar um "box" horizontal para receber algum elemento da view 
	oView:CreateHorizontalBox ( 'SUPERIOR' , 15 )
	oView:CreateHorizontalBox ( 'INFERIOR' , 85 )

	// Relaciona o identificador (ID) da View com o "box" para exibi��o 
	oView:SetOwnerView( 'VIEW_ZZA' , 'SUPERIOR' ) 
	oView:SetOwnerView( 'VIEW_ZZD' , 'INFERIOR' )
	
	//Habilitando t�tulo
	oView:EnableTitleView('VIEW_ZZA', 'Tecnico')
	oView:EnableTitleView('VIEW_ZZD', 'Chamados')

	//Tratativa padr�o para fechar a tela
	oView:SetCloseOnOk({||.T.})

// Retorna o objeto de View criado
Return(oView)


//----------------------------------------------------------
/*/{Protheus.doc} MenuDef()
MenuDef   

@author Rog�rio O Candisani 
@since 
@version 
/*/
//----------------------------------------------------------

Static Function MenuDef()
	
	Local aRotina := {}	
	//Adicionando op��es	
		ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.ZAZDMVC3' OPERATION 2 ACCESS 0 //OPERATION 2 - MODEL_OPERATION_VIEW	
		ADD OPTION aRotina Title 'Incluir'    Action 'VIEWDEF.ZAZDMVC3' OPERATION 3 ACCESS 0 //OPERATION 3 - MODEL_OPERATION_INSERT 
		ADD OPTION aRotina Title 'Alterar'    Action 'VIEWDEF.ZAZDMVC3' OPERATION 4 ACCESS 0 //OPERATION 4 - MODEL_OPERATION_UPDATE		
		ADD OPTION aRotina Title 'Excluir'    Action 'VIEWDEF.ZAZDMVC3' OPERATION 5 ACCESS 0 //OPERATION 5 - MODEL_OPERATION_DELETE (OUTRAS A�OES)
				
		ADD OPTION aRotina TITLE 'Legenda'    ACTION 'VIEWDEF.ZAZDMVC3' OPERATION 6 ACCESS 0 //OPERATION 6 - (OUTRAS A�OES)
		ADD OPTION aRotina TITLE 'QQ coisa'    ACTION 'VIEWDEF.ZAZDMVC3' OPERATION 6 ACCESS 0 //OPERATION 7 - (OUTRAS A�OES)
		ADD OPTION aRotina Title 'Imprimir'   Action 'VIEWDEF.ZAZDMVC3' OPERATION 8 ACCESS 0 //OPERATION 8 - (OUTRAS A�OES) 
		ADD OPTION aRotina Title 'Copiar'     Action 'VIEWDEF.ZAZDMVC3' OPERATION 9 ACCESS 0 //OPERATION 9 - (OUTRAS A�OES)

Return aRotina

//----------------------------------------------------------
/*/{Protheus.doc} U_ChamAten
Fun��o para os chamados do atendente   

@author Rog�rio O Candisani 
@since 
@version 
/*/
//----------------------------------------------------------
User Function ChamAten(cCodAtend)

Local lRetorno := .T. 		// Retorno na rotina.

If !Empty(cCodAtend)
	
	DbSelectArea("ZZD")
	DbSetOrder(1)
	
	If DbSeek(xFilial("ZZD")+cCodAtend)
		FWExecView(Upper("Visualizar"),"VIEWDEF.ZAZDMVC3",1,/*oDlg*/,/*bCloseOnOk*/,/*bOk*/,/*nPercReducao*/)    // Visualizar
	EndIf
	
Else
	MsgAlert("Selecione um atendente para visualizar","Aten��o") 
EndIf

Return( lRetorno )




 
//----------------------------------------------------------
// VALIDA��O DO MODELO
//----------------------------------------------------------
Static Function PosValid(oModel)

	Local oModZZA := oModel:GetModel("ZZAMASTER")
	Local oModZZD := oModel:GetModel("ZZDDETAIL")
	Local lRet    := .T.
	Local nI := 0
	
	If(Empty(oModZZA:GetValue("ZZA_NOME")))
		lRet := .F.
		Help(,,"VLDGRVZZA",,"Favor preencher o nome do t�cnico.",1,0)
	EndIf
	
	For nI := 1 to oModZZD:Length(.T.) // oModZZD:Length(.T.) =  ignora linhas deletadas, se for apenas oModZZD:Length() trar� todas as linhas
		oModZZD:GoLine(nI)
		// MsgAlert("O n�mero linhas �: "+ cValToChar(oModZZD:Length()) + " E o valor do campo �: " + cValToChar(oModZZD:GetValue('ZZD_COD')) )			 	
	Next nI
	
Return(lRet)



//----------------------------------------------------------
// VALIDA DA GRID 
//----------------------------------------------------------
Static Function LinePre(oModelGrid, nLine, cAction, cField)


	Local lRet       := .T. 	
	Local oModel     := oModelGrid:GetModel()
	Local nOperation := oModelGrid:GetOperation()	
	Local oModZZD  := oModel:GetModel("ZZDDETAIL")

	
   If cAction == "DELETE" .AND. nOperation == 4	 // pega o valor do campo na grid	
		lRet := .F.				
		Help(NIL, NIL, "HELP", NIL, "A��o n�o permitida.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Favor informar com F3"}) //http://tdn.totvs.com/display/public/PROT/Help	
	EndIf	

	
	If Empty(FWFLDGET("ZZD_TIPO"))	 // pega o valor do campo no grid na linha selecionada
		lRet := .F.
		MsgStop("O tipo de de atendimento n�o foi informado.","Stop")		
		//Help(NIL, NIL, "VLDGRIZZD", NIL, "O tipo de de atendimento n�o foi informado.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Favor informar com F3"}) //http://tdn.totvs.com/display/public/PROT/Help
	EndIf 

Return( lRet )


Static Function LinePos(oModelGrid)
	
	//Local oModZZD  := oModelGrid:GetModel("ZZDDETAIL")
		
	Local lRet     := .T. 	
	Local nI       := 0
	Local oModel   := FWModelActive()
	Local oModZZD  := oModel:GetModel("ZZDDETAIL")
	
	
	//valida��o dos dados  de cada linha carregada do campo ZZD_TIPO
	
	If Empty(FWFLDGET("ZZD_TIPO"))	 // pega o valor do campo na grid	
		lRet := .F.		
		Help(NIL, NIL, "VLDGRIZZD", NIL, "O tipo de de atendimento n�o foi informado.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Favor informar com F3"}) //http://tdn.totvs.com/display/public/PROT/Help
	EndIf
	
	If oModZZD:IsDeleted()	
		lRet := .F.				
		Help(NIL, NIL, "LinePos", NIL, "N�o pode deletar chamados", 1, 0, NIL, NIL, NIL, NIL, NIL, {""}) //http://tdn.totvs.com/display/public/PROT/Help
	ElseIf oModZZD:IsInserted()
		lRet := .F.				
		Help(NIL, NIL, "LinePos", NIL, "N�o � permitido inserir chamados nessa tela", 1, 0, NIL, NIL, NIL, NIL, NIL, {""}) //http://tdn.totvs.com/display/public/PROT/Help
	ElseIf oModZZD:IsUpdated()
		lRet := .F.				
		Help(NIL, NIL, "LinePos", NIL, "N�o � permitido alterar chamados chamados nessa tela", 1, 0, NIL, NIL, NIL, NIL, NIL, {""}) //http://tdn.totvs.com/display/public/PROT/Help		
	
	EndIf

Return( lRet )

 

 //----------------------------------------------------------
// GATILHO
//----------------------------------------------------------

Static Function Gatilhos(tabela,indice,campo,campoRet)

	Local cNomTec := ""
	
	//cNomTec := AllTrim(Posicione("ZZA",1,XFilial("ZZA")+FWFLDGET("ZZE_TECNIC"),"ZZA_NOME"))
	cNomTec := AllTrim(Posicione(tabela,indice,XFilial(tabela)+FWFLDGET(campo),campoRet))

Return  (cNomeTec)


User Function VIX256IG(cTab, nIndex, cConteudo, cCampoRet, lTrigger, aCampoDest)

	Local lRet 		:= .T.
	Local oModel	:= FWModelActive()
	Local oView		:= FwViewActive()
	Local cRetorno	:= ""
	
	Default cTab		:= ""
	Default lTrigger 	:= .F.
	Default aCampoDest	:= {}

	If (!oView:IsActive() .And. !INCLUI) .Or. lTrigger

		If ! Empty(cTab)

			cRetorno := PadL(Posicione(cTab, nIndex, xFilial(cTab) + cConteudo, cCampoRet), TamSx3(cCampoRet)[1])

		EndIf

	EndIf

Return(cRetorno)
