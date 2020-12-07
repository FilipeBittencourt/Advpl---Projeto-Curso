#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} MT440GR
@author Tiago Rossini Coradini
@since 14/11/2016
@version 1.0
@description Ponto de entrada ap�s a confirma��o da libera��o do pedido de venda (Libera��o manual).
@obs OS: 4060-15 - Claudeir Fadini
@type function
/*/

User Function MT440GR()
Local aArea := GetArea() 	
	
	If ParamIxb[1] == 1
	
		// Tiago Rossini Coradini - 14/11/2016 - OS: 4060-15 - Claudeir Fadini - Workflow de altera��o de data de necessidade de engenharia
		U_BIAF037()	
		
	EndIf
	
	RestArea(aArea)
	
Return(.T.)