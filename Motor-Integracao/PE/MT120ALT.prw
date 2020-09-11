#include "protheus.ch"

User Function MT120ALT()

	Local lExecuta := .T.	
    Local lCitel   :=  SuperGetMv("MV_YCITEL1",.F.,.F.)  //Parametro CITEL ON/OFF inserir, edicao, exclusao  do pedido de compra gerados pelo motor de abastecimento via WS 
    
	//INICIO - Condi��o para pedidos feitos pelo motor de abastecimento CITEL em TELA    
    If !IsBlind() .AND. lCitel
		If !Empty(SC7->C7_YIDCITE)
            FwAlertWarning('N�o � possivel modificar pedido de compra criado pelo motor de abastecimento CITEL.','ATEN��O - MT120OK')
            return lExecuta := .F.
        Endif
    Endif
    //FIM  -  Condi��o para pedidos feitos pelo motor de abastecimento CITEL em TELA

return lExecuta
