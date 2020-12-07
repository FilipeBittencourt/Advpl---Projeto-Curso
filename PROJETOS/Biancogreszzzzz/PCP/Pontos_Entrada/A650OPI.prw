#include "protheus.ch"

/*/{Protheus.doc} A650OPI
@author Marcos Alberto Soprani
@since 09/09/11
@version 1.0
@description Verifica necessidade de gera��o da OP. Respons�vel por inibir a
.            gera��o de Ordens de Produ��o Intermedi�ria a partir do produto
.            acabado na inclus�o das Ordens de Produ��o de Cer�mica.
.            Inicialmente usada para inibir a gera��o dos PI-MASSA.
@obs Em 08/03/17... Por Marcos Alberto Soprani... Ajustada controle para n�o
.            gera OPs filhas para produtos cuja propriedade SB1->B1_YTPPROD == 'RP'
@type function
/*/

User Function A650OPI()

	Local iksfArea := GetArea()
	Local ik_GerOk := .T.

	// N�o pode gerar OPs filhas para PI-MASSA
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+SG1->G1_COD))
	If SB1->B1_GRUPO $ "PI01"
		ik_GerOk := .F.
	EndIf

	//  Em 17/10/11 foi identificado que ao aglutinar um ordem de produ��o pela rotina de montagem de carga de esmalte, o sistema estava criando ordens
	// de produ��o intermedi�rias para os PI's internedi�rios. Isto n�o pode acontecer porque acaba duplicando os Empenhos de MP, al�m de prejudicar o entendimento por
	// parte da montagem de carga.
	If Alltrim(Upper(FunName())) == "BIA257"
		If SC2->C2_SEQUEN == "001"
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SG1->G1_COD))
			If SB1->B1_TIPO $ "PI"
				ik_GerOk := .F.
			EndIf
		EndIf
	EndIf

	// Implementado por Marcos Alberto Soprani em 07/11/13 para tratamento do processo de RETIFICA PR�PRIA
	// Em 28/01/14 foi necess�rio retirar a regra abaixo e incluir esta regra para a gera��o correta do OP e inibi��o da gera��o das OP's filhas.
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	If SB1->B1_YFORMAT $ "B9/BO/C6"
		ik_GerOk := .F.
	EndIf

	// Em 08/03/17... Por Marcos Alberto Soprani, conforme OS effettivo 0879-17
	If SB1->B1_YTPPROD == 'RP'
		ik_GerOk := .F.
	EndIf

	//  Tratamento para n�o permitir redund�ncia quanto a abertura de OPs filhas para os casos de PA ou PS Classe 2 ou 3. Por Marcos Alberto Soprani 06/12/13.
	If ik_GerOk
		gtRegSc2 := SC2->(Recno())
		gtNumOp  := SC2->C2_NUM
		gtItmOp  := SC2->C2_ITEM
		SC2->(dbSetOrder(1))
		If SC2->(dbSeek(xFilial("SC2")+gtNumOp+gtItmOp+"001"))
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			If !SB1->B1_YCLASSE $ " /1" .and. Substr(SC2->C2_PRODUTO,1,2) <> "AU"
				If Alltrim(SG1->G1_COD) <> Substr(SC2->C2_PRODUTO,1,7)
					ik_GerOk := .F.
				EndIf
			EndIf
		EndIf
		SC2->(dbGoTo(gtRegSc2))
	EndIf

	//  Tratamento implementado por em 30/12/14 por Marcos Alberto Soprani, para atender ao projeto de empenho de OP para pedido de vendas.
	//  Para que o projeto entre em opera��o atraso, porque foi identificado nesta data que para a empresa MUNDI seria interessante ler a carteira de pedido de compras em aberto ao inv�s de OP, foi adaptado para que o comercial
	// inclu�sse ordens de produ��o, mas esta n�o deveriam gerar empenho.
	If cEmpAnt $ "13"
		ik_GerOk := .F.
	EndIf

	// 26/07/17... Por Marcos Alberto Soprani
	// Projeto outsourcing = Canal de comercializa��o Fabrica ==>> Fabrica (Originalmente Biancogres ==>> Incesa)
	// Em 24/09/18... retirado de uso
	// Em 15 de outubro 2018 . Conforme defini��o com Marcos e Camila. As movimenta��es feitas na linha 003 Incesa n�o gerar�o empenho
	if cEmpAnt $ "05"
		uoRegSc2 := SC2->(Recno())
		uoNumOp  := SC2->C2_NUM
		uoItmOp  := SC2->C2_ITEM
		SC2->(dbSetOrder(1))
		If SC2->(dbSeek(xFilial("SC2") + uoNumOp + uoItmOp + "001"))
			If Alltrim(SC2->C2_LINHA) $ ("003/L03/E3A")
				ik_GerOk := .F.
			EndIf
		EndIf
		SC2->(dbGoTo(uoRegSc2))
	EndIf

	RestArea(iksfArea)

Return( ik_GerOk )
