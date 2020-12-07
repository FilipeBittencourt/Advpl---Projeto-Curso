#include "rwmake.ch"

/*/{Protheus.doc} BIABC004
@author Barbara Coelho
@since 14/03/2019
@version 1.0
@description Rotina para bloquear a altera��o do campo QUANTIDADE da tela MATA131
@type function
/*/

User Function BIABC004()
	If FwIsInCallStack('U_MATA131') .Or. FwIsInCallStack('U_BIPROCCT')
	    lRet := .T.
	Else
		lRet := .F.
		MsgBox("N�o � poss�vel alterar a quantidade!")
	EndIf
Return(lRet)