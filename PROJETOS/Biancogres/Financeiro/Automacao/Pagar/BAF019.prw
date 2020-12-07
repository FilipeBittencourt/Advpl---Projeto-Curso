#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} BAF019
@author Tiago Rossini Coradini
@since 13/03/2019
@project Automa��o Financeira
@version 1.0
@description Processa retorno, baixas e concilia��o de DDA de titulos a pagar manualmente
@type function
/*/

User Function BAF019(cPar)

	If cPar == "A"
	
		If MsgYesNo("Deseja realmente processar os retornos banc�rios?", "Automa��o Financeira")
			
			U_BIAMsgRun("Processando retornos banc�rios...", "Aguarde!", {|| fRetornoPagar() })
			
		EndIf
		
	ElseIf cPar == "B"
		
		If MsgYesNo("Deseja realmente baixar automaticamente os t�tulos a pagar?", "Automa��o Financeira")
	
			U_BIAMsgRun("Baixando automaticamente os t�tulos...", "Aguarde!", {|| fBaixaPagar() })
			
		EndIf
	
	ElseIf cPar == "C"
		
		If MsgYesNo("Deseja realmente conciliar os t�tulos de DDA?", "Automa��o Financeira")
	
			U_BIAMsgRun("Conciliando t�tulos de DDA...", "Aguarde!", {|| fConciliacaoDDA() })
			
		EndIf
		
	ElseIf cPar == "D"
		
		If MsgYesNo("Deseja realmente processar os retornos de concilia��o banc�ria?", "Automa��o Financeira")
			
			U_BIAMsgRun("Processando retornos de concilia��o banc�ria...", "Aguarde!", {|| fRetornoConciliacao() })
			
		EndIf
		
	EndIf
					
Return()


Static Function fRetornoPagar()
Local oObj := Nil

	// Retorno de pagamentos
	oObj := TAFRetornoPagar():New()
	oObj:Receive()

Return()


Static Function fBaixaPagar()
Local oObj := Nil
		
	// Baixas a pagar
	oObj := TAFBaixaPagar():New()
	oObj:Process()

Return()


Static Function fConciliacaoDDA()
Local oObj := Nil

	// Conciliacao de DDA
	oObj := TAFConciliacaoDDA():New()			
	oObj:Process()	

Return()


Static Function fRetornoConciliacao()
Local oObj := Nil

	// Retorno de Conciliacao Bancaria
	oObj := TAFRetornoConciliacao():New()
	oObj:Receive()
	
	// Conciliacao Bancaria
	oObj := TAFConciliacaoBancaria():New()
	oObj:Process()
	
	// Deposito Identificado
	oObj := TAFDepositoIdentificado():New()
	oObj:Process()

Return()