/*
Descri��o:
Inclus�o de Bot�es. 
O ponto � chamado no momento da defini��o dos bot�es padr�o do or�amento. Para adicionar mais de um bot�o adicionar mais subarrays ao array.
*/

User Function AT400BUT()
Local aBotao := {} 

	aAdd( aBotao, { "PRODUTO", { || U_FWordR01() }, "Imp. Prop. Serv - ATLAS" } )  
	aAdd( aBotao, { "PRODUTO", { || U_FWordR0B() }, "Imp. Prop. Serv - WEG" } ) 
	aAdd( aBotao, { "PRODUTO", { || U_FWordR0C() }, "Imp. Prop. Pe�as- ATLAS" } ) 
	aAdd( aBotao, { "PRODUTO", { || U_FWordR0D() }, "Imp. Prop. Pe�as- WEG" } ) 	
   //	aAdd( aBotao, { "PRODUTO", { || U_FWordR03() }, "Imp. Prop. Serv - WEG" } ) 
  //	aAdd( aBotao, { "PRODUTO", { || U_FWordR04() }, "Imp. Prop. Pe�as- WEG" } ) 	

Return (aBotao)