#Include 'Protheus.ch'
#Include 'Parmtype.ch'
 
Static cStat := '' 

User Function OPERADOR()
	 
	Local nNum1 := 10
	Local nNum2 := 20	
	
	//OPERADORES  MATEMATICOS	
	//Alert(nNum1 + nNum2)
	//Alert(nNum2 - nNum1) 
	//Alert(nNum1 * nNum2)   
	//Alert(nNum2 / nNum1)
	//Alert(nNum2 % nNum1)
	
    //OPERADORES  RELACIONAIS	
	Alert(nNum1 < nNum2)
	Alert(nNum1 > nNum2) 
	Alert(nNum1 = nNum2)  // COMPARA��O DE IGUALDADE  
	Alert(nNum1 == nNum2) // EXATAMENTE IGUAL, MAS � MAIS USADO PARA COMPARAR CARACTERES
	Alert(nNum1 <= nNum2)
	Alert(nNum1 >= nNum2)
	Alert(nNum1 != nNum2)
	
	//OPERADORES  DE ATRIBUI��ES	
	nNum1 := 10    //  ATRIBUI��ES SIMPLES
	nNum1 += nNum2 //  nNum1 = nNum1 + nNum2
	nNum2 -= nNum1 //  nNum2 = nNum2 - nNum1
	nNum1 *= nNum2 //  nNum1 = nNum1 * nNum2
	nNum2 /= nNum1 //  nNum2 = nNum2 / nNum1
	nNum2 %= nNum1 //  nNum2 = nNum2 % nNum1
	
//Os operadores utilizados em AdvPl para opera��es e avalia��es l�gicas s�o:
/*

.And.	E l�gico
.Or.	OU l�gico
.Not.  ou !	N�O l�gico


*/	
		
	
	
Return