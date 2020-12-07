#include 'protheus.ch'
#include 'parmtype.ch'

User Function DropSFK()
Local nX := 0
	
	If MsgYesNo("Deseja realmente limpar as tabelas FKs?")
	
		cSQL := ""
		cSQL := " UPDATE " + RetSQLName("SE5") + " SET E5_MOVFKS = '', E5_IDORIG = '', E5_TABORI = '' "		
		TcSQLExec(cSQL)
		TcSQLExec('COMMIT')
	
		For nX := 1 To 10
																														
			// Dropa tabela do banco e atualiza DbAccess
			__cTab := RetSQLName("FK" + If (nX < 10, cValToChar(nX), "A"))
			
			cSQL := ""				
			cSQL := "DROP TABLE " + __cTab 		
			TcSQLExec(cSQL)
			TcSQLExec('COMMIT')
			
			// Cria tabela
			__cAlias := "FK" + If (nX < 10, cValToChar(nX), "A")
			
			DbSelectArea(__cAlias)
			DbCloseArea()			
							
		Next
									
	EndIf
	
	MsgInfo("Limpeza conclu�da com sucesso!")
	
	
	If MsgYesNo("Deseja efetuar a migra��o off-line dos registros da tabela SE5 - Baixas e Movimento Banc�rio, para a nova estrutura de tabelas da fam�lia FKx?")
	
		FinxSE5()
	
	EndIf
	
return