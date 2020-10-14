#include "protheus.ch"


/*/{Protheus.doc} MT120ALT
PE que Valida o registro do PC e retorna andamento do processo. Apos o usuario clicar em alterar o registro posicionado
@author Filipe - Facile
@programa inicial em 14/09/2020
@Fonte/Link://https://tdn.totvs.com/display/public/PROT/MT120ALT+-+Valida+o+registro+do+PC+e+retorna+andamento+do+processo
@return boolean
*/

User Function MT120ALT()

	Local lExecuta := .T.
    Local lBlind   := IsBlind()
    Local nOpc     := Paramixb[1] == 4

    lExecuta := MTALT001(lBlind, nOpc)

return lExecuta


Static Function MTALT001(lBlind, nOpc)

	Local lRet := .T.	
    Local lMOTOR   :=  SuperGetMv("MV_YMOTOR1",.F.,.F.)  //Parametro MOTOR ON/OFF inserir, edicao, exclusao  do pedido de compra gerados pelo motor de abastecimento via WS  

	//INICIO - Condi��o para pedidos feitos pelo motor de abastecimento MOTOR em TELA    
    If !lBlind .AND. lMOTOR .AND. nOpc == 4
		If !Empty(SC7->C7_YIDCITE)
            FwAlertWarning('N�o � possivel modificar pedido de compra criado pelo motor de abastecimento MOTOR.','ATEN��O - MT120ALT')
            return lRet := .F.
        Endif
    Endif
    //FIM  -  Condi��o para pedidos feitos pelo motor de abastecimento MOTOR em TELA

return lRet



