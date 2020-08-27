#include "Protheus.ch"
#include "rwmake.ch"

/*
------------------------------------------------------------------------------------------------------------
Fun��o		: MT103PN
Tipo			: Funcao do usuario
Descri��o		: 
Uso			: 
Par�metros	:
Retorno		:
------------------------------------------------------------------------------------------------------------
Atualiza��es:
- 09/11/2015 - Pontin - Constru��o inicial do fonte
------------------------------------------------------------------------------------------------------------
*/
User Function MT103PN()      

	Local lAtvXML	:= SuperGetMV("ZZ_ATVXML",.F.,.F.)
	
	If lAtvXML .And. SubStr(Alltrim(FunName()),1,3) == 'PTX'
		//MsgRun("Calculando impostos, aguarde...","Processando",{|| U_PTX0015(.T.) })	
		FWMsgRun(, {|| U_PTX0015(.T.) }, "Processando!", "Calculando impostos, aguarde...")			
	EndIf
	
Return .T.