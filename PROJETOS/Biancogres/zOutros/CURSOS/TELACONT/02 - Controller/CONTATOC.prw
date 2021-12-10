//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*
Fun��o: CONTATOC
------------------------------------------------------------------------------------------------------------
Escopo         : CONTATOC.prw
Descri��o/Uso  : Regras de neg�cio e valida��es do fonte CONTATO.prw
Par�metros     : Nenhum
Retorno        : Nulo
------------------------------------------------------------------------------------------------------------
Atualiza��es   : 99/99/9999 - FILIPE VIEIRA FACILE - Constru��o inicial
------------------------------------------------------------------------------------------------------------
*/


Class CONTATOC From LongClassName 

    Data lResponse
    Data cResponse
	 
	Method New() Constructor
    
	Method Validate()
	
EndClass

METHOD New() Class CONTATOC  
    ::lResponse := .T.
Return Self

METHOD Validate(oContato) Class CONTATOC    
    
    If oContato:cNome  == "" .OR. EMPTY(oContato:cNome)
       oContato:lResponse := .F.
       oContato:cResponse := "O nomde do user N�o pode ser Vazio"
    Else
        oContato:cResponse := "Tudo certo"
    EndIf

Return oContato
