#Include "Protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"
#include "tbiconn.ch"

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
Autor     := Marcos Alberto Soprani
Programa  := A650LEMP
Empresa   := Biancogres Cer鈓ica S/A
Data      := 23/05/14
Uso       := PCP
Aplica玢o := Altera almoxarifado padr鉶 dos itens de empenho para atender
.            a baixa autom醫ica do produto ret韋ica - PR覲RIA
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

User Function A650LEMP()

	Local cRetLocal := PARAMIXB[3]
	Local _aArea	:=	GetArea()
	Local _cAlias	:=	GetNextAlias()
	Local _cLocal	:=	""
	
	BeginSql Alias _cAlias
	
		SELECT C2_LINHA
		FROM %TABLE:SC2% SC2
		WHERE C2_FILIAL = %XFILIAL:SC2%
			AND C2_NUM = %Exp:SC2->C2_NUM%
			AND C2_ITEM = %Exp:SC2->C2_ITEM%
			AND C2_SEQUEN = '001'
			AND %NotDel%
	
	EndSql
	
	If cRetLocal <> '99' .And. !Empty((_cAlias)->C2_LINHA) .And. U_BFG73LIN((_cAlias)->C2_LINHA,PARAMIXB[1],@_cLocal,.F.)
		
		cRetLocal := _cLocal
		
	EndIf
	(_cAlias)->(DbCloseArea())
	RestArea(_aArea)
Return ( cRetLocal )
