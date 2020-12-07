#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"

User Function MA261EST()

/*��������������������������������������������������������������������������
Autor     := Marcos Alberto Soprani
Programa  := MA261EST
Empresa   := Biancogres Ceramica S.A.
Data      := 20/02/13
Uso       := Estoque / Custo
Aplica��o := Valida estorno do movimento - Transferencia Mod II
���������������������������������������������������������������������������*/

Local zlRet := .T.

//  Implementado em 20/02/13 por Marcos Alberto Soprani para auxilio do fechamento de estoque vs movimenta��es retroativas que poderiam
// acontecer pelo fato de o par�mtro MV_ULMES necessitar permanecer em aberto at� que o fechamento de estoque esteja conclu�do
If Da261Data <= GetMv("MV_YULMES")
	MsgSTOP("Imposs�vel prosseguir, pois este movimento interfere no fechamento de custo!!! Favor verificar com a contabilidade!!!","MA261EST")
	zlRet := .F.
EndIf

Return ( zlRet )
