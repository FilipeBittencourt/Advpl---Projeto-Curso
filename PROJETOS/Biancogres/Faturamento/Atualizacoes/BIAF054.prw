#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} BIAF054
@author Tiago Rossini Coradini
@since 28/11/2016
@version 1.0
@description Rotina para efetuar cancelamento de elimina��o de res�duo (Pedidos de venda) 
@obs OS: 3844-16 - Ranisses Corona
@type function
/*/

User Function BIAF054()
Local oObj := TWCancelarEliminacaoResiduo():New()
	
	If cEmpAnt $ "01/05/13" 
	
		If U_VALOPER("038") .And. oObj:oParam:Box()
		
			U_BIAMsgRun("Selecionando Pedidos de Venda...", "Aguarde!", {|| oObj:Activate() })
			
		EndIf
	
	Else
		
		MsgStop("Empresa n�o autorizada para utilizar a rotina.")
		
	EndIf

Return()