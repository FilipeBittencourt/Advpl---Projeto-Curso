#Include 'Protheus.ch'
#Include 'Parmtype.ch'
#Include 'TopConn.ch' //permite executar codigos no fonte

User Function BANCO004()

	Local aArea := SB1->(GetArea())
	Local cMsg  := ''
	
	DbSelectArea("SB1") // SELECT * FROM SB1
	SB1->(DbSetOrder(1)) // order by pelo indice 1
	SB1->(DbGoTop()) // Seleciona o primeiro registro

	// Iniciar transa��o.	
	Begin Transaction
		MsgInfo("A Descri��o do produto ser� alterada")
		IF (SB1->(DBSeek(FWXFilial("SB1")+"000002")))
			RecLock('SB1', .F.) // Trava o registro p�ra Aletra��o coloca .F. se for ,  .T. seria uma inser��o
			Replace B1_DESC With "xxxx"
			SB1->(MsUnlock()) // Libera tabela novamente
 		EndIf
 		MsgAlert("Altera��o efetuada!", "Aten��o")
 		//DisarmTransaction() // Disfaz toda altera��o no banco de dados
 	End Transaction
 	
 	RestArea(aArea)	
Return

