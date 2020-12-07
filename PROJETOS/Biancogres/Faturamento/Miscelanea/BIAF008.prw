#INCLUDE "TOTVS.CH"

/* 
|------------------------------------------------------------|
| Fun��o:	| BIAF008																					 |
| Autor:	|	Tiago Rossini Coradini - Facile Sistemas				 |
| Data:		| 27/10/14																				 |
|------------------------------------------------------------|
| Desc.:	|	Valida��o no Pedido de Venda   						   		 |
| 				|	Respons�vel por executar os gatilhos do campo  	 |
| 				|	produto (C6_PRODUTO) para todos os itens ao    	 |
| 				|	alterar o conteudo dos campos: C5_CONDPAG,  	   |
| 				|	C5_YLINHA, C5_YSUBTP, C5_VLRFRET, C5_YMAXCND, 	 |
| 				|	C5_TABELA.  																		 |
| 				|	Executado via gatilho na fun��o ATU_PEDIDO()		 |
|------------------------------------------------------------|
| OS:			|	0652-14 - Usu�rio: Elaine Cristina Sales	 			 |
|------------------------------------------------------------|
*/

User Function BIAF008(oGedPedVen)
Local aArea := GetArea()
Local nLine := 0
Local nLineAux := N
	
	For nLine := 1 To Len(aCols)
	
		N := nLine
		
		If ExistTrigger("C6_PRODUTO")
			RunTrigger(2, nLine, Nil,,"C6_PRODUTO")
		EndIf
		
	Next
	
	N := nLineAux
	
	oGedPedVen:ForceRefresh()
	
	RestArea(aArea)
	
Return()