#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
|-----------------------------------------------------------|
| Funcao: | Pe01NfeSefaz																		|
| Autor:	| Tiago Rossini Coradini - Facile Sistemas			  |
| Data:		| 02/02/15																			  |
|-----------------------------------------------------------|
| Desc.:	| Ponto de entrada localizado na fun��o XmlNfeSef |
| 				| do rdmake NFESEFAZ. Atrav�s deste ponto 				|
| 				| � poss�vel realizar manipula��es nos dados 			|
| 				| do produto, mensagens adicionais, destinat�rio, |
| 				| dados da nota, pedido de venda ou compra, 			|
| 				| antes da montagem do XML, no momento da 				|
| 				| transmiss�o da NFe.															|
|-----------------------------------------------------------|
*/

User Function Pe01NfeSefaz()
Local aRet := {}
Local oNfeSefaz := TBiaNfeSefaz():New(ParamIxb)

	oNfeSefaz:Validate()
	
	aRet := oNfeSefaz:Update()

Return(aRet)