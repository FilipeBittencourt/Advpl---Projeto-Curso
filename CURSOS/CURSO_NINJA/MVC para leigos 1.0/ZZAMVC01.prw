#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

Static cCadastro := "Cadastro de T�cnicos"
//-------------------------------------------------------------------
/*/{Protheus.doc} ZZAMVC01
@author Filipe Vieira
@since 27/10/2018 
@version 
/*/
//-------------------------------------------------------------------
User Function ZZAMVC01()

	Local aArea  := GetArea()
	Local oBrw := FwMBrowse():New()
	oBrw:SetDescription(cCadastro) 
	oBrw:SetAlias("ZZA")
	oBrw:Activate()
	RestArea(aArea)

Return()

//----------------------------------------------------------
/*/{Protheus.doc} MenuDef()
@author Filipe Vieira 
@since 27/10/2018 
@version 
/*/
//----------------------------------------------------------
Static Function MenuDef()

   // 1 op��o
	Local oMenu := FWMVCMenu( "ZZAMVC01" )
	
	// 2 op��o
	/*Local aRot := {}	
	//Adicionando op��es
	ADD OPTION aRot Title 'Visualizar' Action 'VIEWDEF.ZAZDMVC3' OPERATION 2 ACCESS 0 //OPERATION 2 - MODEL_OPERATION_VIEW	
	ADD OPTION aRot Title 'Incluir'    Action 'VIEWDEF.ZAZDMVC3' OPERATION 3 ACCESS 0 //OPERATION 3 - MODEL_OPERATION_INSERT 
	ADD OPTION aRot Title 'Alterar'    Action 'VIEWDEF.ZAZDMVC3' OPERATION 4 ACCESS 0 //OPERATION 4 - MODEL_OPERATION_UPDATE		
	ADD OPTION aRot Title 'Excluir'    Action 'VIEWDEF.ZAZDMVC3' OPERATION 5 ACCESS 0 //OPERATION 5 - MODEL_OPERATION_DELETE (OUTRAS A�OES)
	*/
 
Return oMenu

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

	Local oStruZZA  := FwFormStruct(1,"ZZA")// Cria a estrutura a ser usada no Modelo de Dados
	Local bPosValidacao  := {|oModel| VLDGRVZZA(oModel)} 
	//Local oModel := MPFormModel():New("ZZAMVC_M")// Cria o objeto do Modelo de Dados	
	local oModel := MPFormModel():New("ZZAMVC_M", /*bPreValidacao*/, bPosValidacao,/*bCommit*/,/*bCancel*/ )	// Cria o objeto do Modelo de Dados , com valida��o 
	
	oModel:AddFields("ZZAMASTER",/*cOwner*/, oStruZZA)// 01 - Adiciona ao modelo um componente de formul�rio
	oModel:SetPrimaryKey({'ZZA_FILIAL','ZZA_COD'})// 02 -Setando a chave prim�ria da rotina ou campos do indice
	oModel:SetDescription(cCadastro)// 03 - Adiciona UM nome/descri��o do Modelo de Dados 
	oModel:GetModel("ZZAMASTER" ):SetDescription(cCadastro)// 04 Adiciona um nome/descri��o do formul�rio QUE esse nome SER� USADO na VIEWDEF()
	
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


	Local oModel   := FwLoadModel("ZZAMVC01")// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado (nome do arquivo)
	Local oStruZZA := FwFormStruct(2,"ZZA") // Cria a estrutura a ser usada na View
	Local oView // Interface de visualiza��o constru�da
	
	oView := FWFormView():New() // Cria o objeto de View
	oView:SetModel(oModel)// Define qual o Modelo de dados ser� utilizado na View
	oView:AddField("VIEW_ZZA",oStruZZA,"ZZAMASTER") // Adiciona no nosso View um controle do tipo formul�rio (antiga Enchoice) 
	oView:CreateHorizontalBox("TELA",100) // Criar um "box" horizontal para receber algum elemento da view
	oView:SetOwnerView( 'VIEW_ZZA', 'TELA' )// Relaciona o identificador (ID) da View com o "box" para exibi��o 

// Retorna o objeto de View criado
Return(oView)




// VALIDA��O DO MODELO
Static Function VLDGRVZZA(oModel)

	Local oModZZA := oModel:GetModel("ZZAMASTER")
	Local lRet    := .T.
	
	If(Empty(oModZZA:GetValue("ZZA_NOME")))
		lRet := .F.
		Help(,,"VLDGRVZZA",,"Favor preencher o nome do t�cnico.",1,0)
	EndIf
	
Return(lRet)


