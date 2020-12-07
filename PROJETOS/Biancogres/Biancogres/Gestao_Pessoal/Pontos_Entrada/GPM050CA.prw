#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} GPM5002
@author Marcos Alberto Soprani
@since 02/08/2016
@version 1.0
@description Este ponto de entrada destina-se � valida��o de usu�rio, para permitir a execu��o da rotina do c�lculo do vale-transporte.
.            Contudo, para o nosso caso, ele foi utilizado para criar uma vari�vel p�blica de controle de filtro de tipo de vale - bpmFiltM0Tr
@obs OS: 2536-16 - Jessica Silva
@type function
/*/

USER FUNCTION GPM050CA()

	Local cgrRet := .T.
	Public bpmFiltM0Tr := Space(200)

Return ( cgrRet )