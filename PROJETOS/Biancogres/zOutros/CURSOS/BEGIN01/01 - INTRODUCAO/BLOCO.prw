#Include 'Protheus.ch'
#Include 'Parmtype.ch'
 

User Function BLOCO()

	//Local bBloco := {||nValor := 2, MsgAlert("O n�mero �: "+ cValToChar(nValor))}	 
	//EVAL(bBloco)
	
	Local bBloco := {|cMsg| Alert(cMsg)}
	EVAL(bBloco,"Que tro�o doido")
	
Return

