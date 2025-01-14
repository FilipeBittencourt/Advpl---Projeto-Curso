#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "SHELL.CH"
#include "Fileio.ch"
#include "tbiconn.ch"

User Function MT250EST()

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
Autor     := Marcos Alberto Soprani
Programa  := MT250EST
Empresa   := Biancogres Cer鈓ica S/A
Data      := 01/11/11
Uso       := PCP / Estoque Custos
Aplica玢o := Chamado apos confirma玢o de estorno de produ珲es. Este ponto
.            de entrada permite validar algum campo especifico do usuario
.            antes de se realizar o Estorno.
.            A princ韕io ele sempre retornar� .T., pois sua funcionalidade
.            inicial � efetuar o estorno da baixa de estoque intercompany
.            bem como a recupe玢o do empenho baixado na InterCompany.
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

Local gg_Ret   := .T.
Local kk_EmprG := cEmpAnt
Local lvfArea  := GetArea()

//  Implementado em 20/02/13 por Marcos Alberto Soprani para auxilio do fechamento de estoque vs movimenta珲es retroativas que poderiam
// acontecer pelo fato de o par鈓tro MV_ULMES necessitar permanecer em aberto at� que o fechamento de estoque esteja conclu韉o
If SD3->D3_EMISSAO <= GetMv("MV_YULMES")
	MsgSTOP("Imposs韛el prosseguir, pois este movimento interfere no fechamento de custo!!! Favor verificar com a contabilidade!!!","MT250EST")
	gg_Ret := .F.
EndIf

RestArea(lvfArea)

Return( gg_Ret )
