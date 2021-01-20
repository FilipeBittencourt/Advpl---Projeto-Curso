#include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWMVCDEF.CH'
/*/{Protheus.doc} BIABC020
@author Barbara Luan Gomes Coelho
@since 03/11/20
@version 1.1
@description Tela de c�lculo de consumo m�dio
@type function
/*/                                                                                               

User Function BIABC020()
	Private sdtInicial := "DATEADD(DAY, +1,EOMONTH(DATEADD(MONTH, -4,GETDATE())))"
	Private sdtFinal   := "EOMONTH(DATEADD(MONTH,-1,GETDATE())) "
	Private sAnoMes    := AnoMes ( Date() )
	Private bInsere    := .T.
	cEnter             := Chr(13) + Chr(10)
	
	Aviso('C�lculo de Consumo M�dio', ;
	'Data Refer�ncia:' + MesExtenso(Month2Str( Date() ) ) + '/' + Year2Str( Date() ) + cEnter +;
	'Pol�ticas: 4 e 8 ' + cEnter + 'Per�odo: 3 meses',{'Ok'})


	cQuery := "SELECT DISTINCT BM_GRUPO, BM_DESC, " + cEnter
	cQuery += "       ROUND(SUM(CUSTO)/(DATEDIFF(DAY," + sdtInicial +", " + sdtFinal + ")/30), 2) CUSTO" + cEnter
	cQuery += "  FROM (SELECT DISTINCT SBM.BM_GRUPO, SBM.BM_DESC," + cEnter
	cQuery += "               CASE WHEN D3_TM >= '500' THEN D3_QUANT" + cEnter
	cQuery += "               ELSE D3_QUANT * (-1) END QUANT," + cEnter
	cQuery += "               CASE WHEN D3_TM >= '500' THEN D3_CUSTO1 " + cEnter
	cQuery += "               ELSE D3_CUSTO1 * (-1) END CUSTO " + cEnter
	cQuery += "          FROM SBM010 SBM WITH (NOLOCK)" + cEnter
	cQuery += "         INNER JOIN SB1010 SB1  WITH (NOLOCK)" + cEnter 
	cQuery += "            ON B1_GRUPO = SBM.BM_GRUPO " + cEnter
	cQuery += "           AND SB1.D_E_L_E_T_ = ''" + cEnter
	cQuery += "         INNER JOIN ZCN010 ZCN  WITH (NOLOCK) " + cEnter
	cQuery += "            ON B1_COD = ZCN_COD " + cEnter
	cQuery += "           AND ZCN_POLIT IN ('4','8') " + cEnter
	cQuery += "           AND ZCN.D_E_L_E_T_ = ''" + cEnter
	cQuery += "         INNER JOIN SD3010 SD3  WITH (NOLOCK) " + cEnter
	cQuery += "            ON D3_COD = ZCN_COD " + cEnter
	cQuery += "           AND D3_LOCAL = ZCN_LOCAL " + cEnter
	cQuery += "           AND D3_YPARADA <> 'S' " + cEnter
	cQuery += "            AND SD3.D_E_L_E_T_ = ' '" + cEnter
	cQuery += "         WHERE D3_EMISSAO BETWEEN " + sdtInicial +" AND " + sdtFinal + cEnter
	cQuery += "           AND SBM.D_E_L_E_T_ = '')TBL" + cEnter
	cQuery += " GROUP BY BM_GRUPO, BM_DESC " + cEnter

	TCQUERY cQuery ALIAS "QRY1" NEW

	DbSelectArea("QRY1")
	DbGotop()

	While !EOF()
		DbSelectArea("ZG1")
		DbSetOrder(1)
		
		IF DbSeek(xFilial("ZG1") + QRY1->BM_GRUPO + sAnoMes)
			bInsere    := .F.
			Aviso('C�lculo Limite de Compras por Grupo de Produto', "Aten��o! O c�lculo j� havia sido executado para o per�odo : " + sAnoMes ,{'Ok'})
			EXIT
		ELSE	
			RecLock("ZG1",.T.)
			ZG1->ZG1_FILIAL := xFilial("ZG1")
			ZG1->ZG1_GRPROD := QRY1->BM_GRUPO
			ZG1->ZG1_VLCM   := QRY1->CUSTO
			ZG1->ZG1_ANOMES := sAnoMes

			MsUnLock("ZG1")
		ENDIF
		DbSelectArea("QRY1")
		DbSkip()
	END
	DbCloseArea("QRY1")
	
	if bInsere
		Aviso('C�lculo Limite de Compras por Grupo de Produto', "Sucesso! C�lculo executado sem problemas para o per�odo : " + sAnoMes ,{'Ok'})
	endif
Return