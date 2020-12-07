#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} BIAF095
@author Tiago Rossini Coradini
@since 07/02/2018
@version 1.0
@description Rotina para atualiza��o dos motivos de cancelamento dos pedidos de venda 
@obs Ticket: 2123
@type Function
/*/

User Function BIAF095()
Local aArea := GetArea()
Local aFil := {}
Local nCount := 0
	
	If MsgYesNo("Deseja realmente atualizar os motivos de cancelamento dos pedidos de venda?")			
					
		If FWModeAccess("SX5") == "C"
		
			fDelete(xFilial("SX5"))

			fInsert(xFilial("SX5"))
		
		Else
		
			aFil := FWAllFilial()
			
			For nCount := 1 To Len(aFil)
			
				fDelete(aFil[nCount])
	
				fInsert(aFil[nCount])
		
			Next
		
		EndIf
		
	EndIf
	
	RestArea(aArea)

Return()


Static Functio fDelete(cFil)

	DbSelectArea("SX5")
	DbSetOrder(1)		
	If SX5->(DbSeek(cFil + "ZZ"))
	
		While !SX5->(Eof()) .And. SX5->X5_TABELA == "ZZ"
		
			Reclock("SX5", .F.)
				
				SX5->(DbDelete())
							
			MsUnLock()
			
			SX5->(DbSkip())
		
		EndDo()
	
	EndIf

Return()


Static Function fInsert(cFil)
Local aMot := {}
Local nCount := 0
		
	aAdd(aMot, {"200", "ALTERA��O DA QUANTIDADE"})
	aAdd(aMot, {"201", "ALTERA��O DO PRE�O/DESCONTO"})
	aAdd(aMot, {"202", "ALTERA��O NA CONDI��O DE PAGAMENTO"})
	aAdd(aMot, {"203", "ALTERA��O DE CNPJ"})
	aAdd(aMot, {"204", "CANCELADO POR INADIMPL�NCIA/CR�DITO"})
	aAdd(aMot, {"205", "ERRO SISTEMICO NA IMPLANTA��O"})
	aAdd(aMot, {"206", "CANCELADO PARA ENVIAR VIA PROPOSTA"})
	aAdd(aMot, {"207", "PEDIDO EM DUPLICIDADE"})
	aAdd(aMot, {"208", "PEDIDO PARADO EM CARTEIRA"})
	aAdd(aMot, {"209", "PRODUTO N�O LOCALIZADO NO F�SICO/QUEBRA"})
	aAdd(aMot, {"210", "PRODUTO FORA DE LINHA SEM ESTOQUE"})
	aAdd(aMot, {"211", "CLIENTE DESISTIU DA MERCADORIA/RES�DUO"})
	aAdd(aMot, {"212", "ALTERA��O DO PRODUTO"})
	aAdd(aMot, {"213", "PEDIDO PARA TESTE"})
	aAdd(aMot, {"214", "REMANEJAMENTO DE PRODUTO PARA OUTRO CLIENTE"})
	aAdd(aMot, {"215", "OR�AMENTO RECUSADO - PEDIDO EM DESACORDO COM POL�TICA"})
	aAdd(aMot, {"216", "MIGRA��O DE CARTEIRA"})
	
	For nCount := 1 To Len(aMot)
		
		Reclock("SX5", .T.)
			
			SX5->X5_FILIAL := cFil
			SX5->X5_TABELA := "ZZ"
			SX5->X5_CHAVE := aMot[nCount, 1]
			SX5->X5_DESCRI := aMot[nCount, 2]
			SX5->X5_DESCSPA := aMot[nCount, 2]
			SX5->X5_DESCENG := aMot[nCount, 2]
		
		MsUnLock()
	
	Next

Return()