#Include 'Protheus.ch'


/*/{Protheus.doc} FA330BX
O ponto de entrada FA330BX est� dispon�vel para procedimentos internos do usu�rio, 
atrav�s dele � poss�vel ter acesso ao dados dos t�tulos a receber que ser�o baixados.
@type function
@version 1.0
@author Pontin - Facile Sistemas
@since 18/08/2021
/*/
User Function FA330BX()

  Local oRecompra as Object

  //|Projeto FIDC Recompra |
  oRecompra	:= TFPFidcRecompraReceber():New()

  oRecompra:cPrefixo          := cPrefixo
  oRecompra:cNumero           := cNum
  oRecompra:cParcela          := cParcela
  oRecompra:cTipo             := cTipoOr
  oRecompra:cCodigoCliente    := cCliente
  oRecompra:cLojaCliente      := cLoja
  oRecompra:nValorOriginal    := 0
  // oRecompra:nSaldoTitulo      := cSaldo
  // oRecompra:dVencimento       := SE1->E1_VENCREA
  oRecompra:nValorDesconto    := nValor
  oRecompra:nRecnoSE1         := 0

  oRecompra:AdicionaTituloRecompra()

  FreeObj(oRecompra)
	
Return .T.
