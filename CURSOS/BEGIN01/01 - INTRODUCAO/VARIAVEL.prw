#Include 'Protheus.ch'
#Include 'Parmtype.ch'
 

User Function VARIAVEL()

	// As lestras  que come�am na frente dos nomes das variaveis servem para mostrar o tipo das mesmas. � uma boa pratica feita pela comunidade.
	
	Local nNumero := 66  // 3  |  21.000  |  0.4  | 20000  
	Local lLogico := .T. // .F. 
	Local nCaracter :=  "Nome" // "D"  |  'C' 
	Local dData :=  DATE()
	Local aArray := {"Jo�o","Maria","Pedro"}	 
	Local bBloco := {||;
		 nValor := 2,; 
		 MsgAlert("O n�mero �: "+ cValToChar(nValor));
	}  // cValToChar � uma fun��o que converte um valor para string, para ser exibida quando for CONCATENADO SOMENTE. Caso contrario dar� erro.  
	
	
	Alert(nNumero)
	Alert(lLogico)
	Alert(nCaracter) // Sempre que for exibir uma variavel do tipo caracter para o user, sempre usar a fun��o cValToChar
	Alert(dData)
	Alert(aArray[1])	
	Eval(bBloco) //Sempre que for necessario retornar o resultado de um bloco de codigo.
	

Return

