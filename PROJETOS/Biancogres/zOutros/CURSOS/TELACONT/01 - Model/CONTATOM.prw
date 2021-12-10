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


Class CONTATOM From LongClassName 

    Data cNome
    Data cSobreNome
    Data nIdade
    
    Data lResponse
    Data cResponse
	 
	Method New() Constructor
	Method Validate()
	
EndClass

METHOD New() Class CONTATOM  
    
Return Self
