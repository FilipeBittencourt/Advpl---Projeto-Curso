#include "rwmake.ch"
#include "topconn.ch"

User Function MT100GRV()

/*��������������������������������������������������������������������������
Autor     := Marcos Alberto Soprani
Programa  := MT100GRV
Empresa   := Biancogres Cer�mica S/A
Data      := 11/10/2011
Uso       := Compras
Aplica��o := PONTO DE ENTRADA executado antes da Inclus�o / Dele��o da nota
.            fiscal de entrada. Valida ou n�o a a��o
���������������������������������������������������������������������������*/

Local fpArea := GetArea()
Local xt_RetOk := .T.
Local xt_DelOk := PARAMIXB[1]

// Processo de Devolu��o. Inclu�do por Marcos Alberto em 11/10/11 a pedido da Diretoria.
// Rotinas envolvidas: BIA267, SF1100I, SF1100E, SD1100I, MT100LOK, MT100GRV
If xt_DelOk
	If cTipo == "D"
		
		A0002 := " SELECT DISTINCT Z26_NUMPRC
		A0002 += "   FROM "+ RetSqlName("Z26")
		A0002 += "  WHERE Z26_FILIAL = '"+xFilial("Z26")+"'
		A0002 += "    AND Z26_OBS = '"+cNFiscal+cSerie+"'
		A0002 += "    AND Z26_ITEMNF = 'XX'
		A0002 += "    AND D_E_L_E_T_ = ' '
		TcQuery A0002 New Alias "A002"
		dbSelectArea("A002")
		dbGoTop()
		
		dbSelectArea("Z25")
		dbSetOrder(1)
		If dbSeek(xFilial("Z25")+A002->Z26_NUMPRC)
			If !Empty(Z25->Z25_APRFIS) .or. !Empty(Z25->Z25_APRFIN)
				xt_RetOk := .F.
				MsgBox("N�o ser� poss�vel excluir a digita��o desta nota fiscal de devolu��o porque o processo de devolu��o j� passou pelo parecer f�sico/Financeiro!!!", "MT100LOK", "ALERT")
			Endif
		EndIf
		A002->(dbCloseArea())
		
	EndIf
EndIf

RestArea(fpArea)

//TESTE CONEXAO INICIO
	conout(" ----------------------------------------------- ")
	conout(" ["+ Time() +"] Mensagem Conex�oNF-e")
	conout(" > MT100GRV:")

	If Type("cEspecie") <> "U"
		conout("    cEspecie: '" + cEspecie + "'")
	else
		conout("    cEspecie n�o declarada")
	EndIf

	If Empty(SF1->F1_ESPECIE)
		conout("    SF1->F1_ESPECIE = ''")
	else
		conout("    SF1->F1_ESPECIE = '" + SF1->F1_ESPECIE + "'")
	EndIf
//TESTE CONEXAO FIM

Return( xt_RetOk )
