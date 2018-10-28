#Include 'Protheus.ch'
#Include 'Parmtype.ch'

/*
Fun��o: A010TOK
------------------------------------------------------------------------------------------------------------
Escopo     : Fun��o de Usu�rio
Descri��o  : PONTO DE ENTRADA ANTES DA INCLUS�O/ALTERA��O DE UM PRODUTO
Uso:       : Inclus�o, altera��o e dele��o de registros no cadastro
Par�metros : Nenhum
Retorno    : Nulo
------------------------------------------------------------------------------------------------------------
Atualiza��es:
- 21/10/2018 - FILIPE VIEIRA - Constru��o inicial
------------------------------------------------------------------------------------------------------------
*/


User Function A010TOK()

	Local lExecuta := .T. // variavel responsavel por retornar a a��o do ponto de entrada
	Local cTipo  := AllTrim(M->B1_TIPO)
	Local cConta := AllTrim(M->B1_CONTA)
	
	If(cTipo == "PA" .AND. cConta == "001")
		Alert("A conta <b>"+cConta+"</b> n�o pode estar associada a um produto do tipo <b>"+cTipo+"</b>")
		lExecuta := .F.
	EndIF
	
Return lExecuta

