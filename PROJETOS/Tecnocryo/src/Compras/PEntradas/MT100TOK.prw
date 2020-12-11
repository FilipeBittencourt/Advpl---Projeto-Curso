/*
------------------------------------------------------------------------------------------------------------
Fun��o		: MT100TOK
Tipo			: Ponto de entrada
Descri��o		: Valida dos dados da tela
Uso			: 
Par�metros	:
Retorno		:
------------------------------------------------------------------------------------------------------------
Atualiza��es:
- 09/11/2012 - Pontin - Constru��o inicial do fonte
------------------------------------------------------------------------------------------------------------
*/
User Function MT100TOK()

	Local aArea		:= GetArea()
	local lret		:= paramixb[1]
	Local lAtvXML	:= SuperGetMV("ZZ_ATVXML",.F.,.F.)
	
	If lAtvXML .And. Alltrim(FunName()) $ "MATA103/PTX0007/PTX0018/PTX0008/PTX0001"  
		lret := U_PTX0010()
	EndIf
	
	RestArea(aArea)
	
Return lret          

