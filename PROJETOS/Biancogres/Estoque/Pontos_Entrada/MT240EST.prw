#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"

User Function MT240EST()

/*��������������������������������������������������������������������������
Autor     := Marcos Alberto Soprani
Programa  := MT240EST
Empresa   := Biancogres Ceramica S.A.
Data      := 20/02/13
Uso       := Estoque / Custo
Aplica��o := Valida estorno do movimento - Internos Mod I
���������������������������������������������������������������������������*/

Local zlRet := .T.
Local oEntEPI := TEntregaEPI():New()

//  Implementado em 20/02/13 por Marcos Alberto Soprani para auxilio do fechamento de estoque vs movimenta��es retroativas que poderiam
// acontecer pelo fato de o par�mtro MV_ULMES necessitar permanecer em aberto at� que o fechamento de estoque esteja conclu�do
If SD3->D3_EMISSAO <= GetMv("MV_YULMES")
	MsgSTOP("Imposs�vel prosseguir, pois este movimento interfere no fechamento de custo!!! Favor verificar com a contabilidade!!!", "MT240EST")
	zlRet := .F.
EndIf

	If zlRet
		
		// Deleta EPI associada a movimenta��o interna
		oEntEPI:Delete(SD3->D3_NUMSEQ)
		
	EndIf

Return ( zlRet )
