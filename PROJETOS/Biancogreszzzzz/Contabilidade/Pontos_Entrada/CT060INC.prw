#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*/{Protheus.doc} CT060INC
@author Marcelo Sousa - Facile Sistemas
@since 16/10/18
@version 1.0
@description O ponto de entrada CT060INC � executado na inclusao da classe de valor
@obs Criado para que no momento da cria��o de uma classe de valor, o sistema crie tamb�m um departamento com mesmo c�digo e descri��o
@type function
/*/

user function CT060INC()

	cExiste := ""

	// Verificando se j� existe o departamento criado
	DBSELECTAREA("SQB")
	SQB->(DBGOTOP())
	cExiste := SQB->(DBSEEK(CTH->CTH_FILIAL+CTH->CTH_CLVL))	
	
	IF INCLUI .AND. !cExiste
		
		RECLOCK("SQB",.T.)
		
			SQB->QB_DEPTO   := CTH->CTH_CLVL
			SQB->QB_DESCRIC := CTH->CTH_DESC01
		
		SQB->(MSUNLOCK())
			
	ELSEIF ALTERA .AND. !cExiste
	
		RECLOCK("SQB",.T.)
		
			SQB->QB_DEPTO   := CTH->CTH_CLVL
			SQB->QB_DESCRIC := CTH->CTH_DESC01
		
		SQB->(MSUNLOCK())
	
	ENDIF
	
Return