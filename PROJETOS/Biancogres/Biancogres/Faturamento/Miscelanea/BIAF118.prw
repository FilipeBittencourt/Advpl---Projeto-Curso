#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} BIAF118
@author Tiago Rossini Coradini
@since 15/08/2018
@version 1.0
@description Preenchimento automatico do campo de autidoria na analise de cotacao
@obs Ticket: 5115
@type function
/*/

User Function BIAF118()
Local lRet := .T.
Local cEmpFat := M->Z68_EMPFAT 
	
	If Inclui .Or. Altera
			
		If M->Z68_EMPFAT <> "07"
		
			If !MsgYesNo("Aten��o, a altera��o da empresa de faturamento, atualizar� o pre�os."+ Chr(13) + Chr(10) +; 
									 "Deseja realmente alterar?")								
				
				lRet := .F.
			
			EndIf
				
		EndIf
	
	EndIf
	
Return(lRet)