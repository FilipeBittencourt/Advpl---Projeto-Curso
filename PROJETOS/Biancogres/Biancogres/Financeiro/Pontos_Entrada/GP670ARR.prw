#Include 'Protheus.ch'

/*/{Protheus.doc} GP670ARR
Esse Ponto de entrada deve ser utilizado para adicionar, na integra��o do titulo, campos criados pelo usuario. 
Ele somente ser� executado quando estiver sendo efetuada a integra�cao do titulo, se isso n�o ocorrer 
sera apresentado log com os titulos n�o integrado.
@type function
@author Pontin
@since 18/07/2018
@version 1.0
/*/
User Function GP670ARR()
	
	Local aDados	:= {}
	
	aDados := {{'E2_HIST' , RC1->RC1_MAT ,Nil}} 

Return aDados

