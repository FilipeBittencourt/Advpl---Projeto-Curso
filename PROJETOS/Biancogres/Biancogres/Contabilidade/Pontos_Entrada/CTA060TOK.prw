#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*/{Protheus.doc} CTA060TOK
@author Marcelo Sousa - Facile Sistemas
@since 16/10/18
@version 1.0
@description O ponto de entrada CT060INC � executado na inclusao da classe de valor
@obs Criado para que no momento da cria��o de uma classe de valor, o sistema crie tamb�m um departamento com mesmo c�digo e descri��o
@type function
/*/

user function CTA060TOK()

	cExiste := ""
    
	// Verificando se j� existe o departamento criado
	DBSELECTAREA("SQB")
	SQB->(DBGOTOP())
	SQB->(DBSETORDER(1))
	cExiste := SQB->(DBSEEK(M->CTH_FILIAL+M->CTH_CLVL))	
	
	IF INCLUI .AND. !cExiste
		
		RECLOCK("SQB",.T.)
		
			SQB->QB_DEPTO   := M->CTH_CLVL
			SQB->QB_DESCRIC := M->CTH_DESC01
		
		SQB->(MSUNLOCK())
			
	ELSEIF ALTERA .AND. !cExiste
	
		RECLOCK("SQB",.T.)
		
			SQB->QB_DEPTO   := M->CTH_CLVL
			SQB->QB_DESCRIC := M->CTH_DESC01
		
		SQB->(MSUNLOCK())
	
	ELSEIF (ALTERA .OR. INCLUI) .AND. cExiste 
	
		DBSELECTAREA("SQB")
		SQB->(DBSETORDER(1))
		SQB->(DBSEEK(M->CTH_FILIAL+M->CTH_CLVL))
		
		RECLOCK("SQB",.F.)
		
			SQB->QB_DESCRIC := M->CTH_DESC01
			
		SQB->(MSUNLOCK())
	
	ELSEIF EXCLUI
	
		DBSELECTAREA("SQB")
		SQB->(DBSETORDER(1))
		SQB->(DBSEEK(M->CTH_FILIAL+M->CTH_CLVL))
		
		RECLOCK("SQB",.F.)
		
			SQB->(DBDELETE())
			
		SQB->(MSUNLOCK())	
	
	ENDIF
	
Return .T.