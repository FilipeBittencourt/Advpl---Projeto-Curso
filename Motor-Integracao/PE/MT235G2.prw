#include "protheus.ch"

/*/{Protheus.doc} MT235G2
PE Antes de processar a elimina��o de cada Pedido de Compra, por residuo
@author Filipe - Facile
@programa inicial em 14/09/2020
@Fonte/Link: https://tdn.totvs.com/display/public/PROT/MT235G2
@return boolean
*/


User Function MT235G2()

	Local lExecuta := .T.	
    Local nCount   := .T.	
    Local lCitel   :=  SuperGetMv("MV_YCITEL1",.F.,.F.)  //Parametro CITEL ON/OFF inserir, edicao, exclusao  do pedido de compra gerados pelo motor de abastecimento via WS 
    
	//INICIO - Condi��o para pedidos feitos pelo motor de abastecimento CITEL em TELA  

    If !IsBlind() .AND. lCitel
		If !Empty(SC7->C7_YIDCITE)            
            FwAlertWarning('N�o � possivel modificar pedido de compra criado pelo motor de abastecimento CITEL.','ATEN��O - MT235G2')
            lExecuta := .F.             
        Endif
    Endif
    //FIM  -  Condi��o para pedidos feitos pelo motor de abastecimento CITEL em TELA

return lExecuta

