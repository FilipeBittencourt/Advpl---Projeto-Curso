#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function SD3250I()

/*��������������������������������������������������������������������������
Autor     := Marcos Alberto Soprani
Programa  := SD3250I
Empresa   := Biancogres Cer�mica S/A
Data      := 06/09/11
Uso       := PCP
Aplica��o := Ponto de entrada que permite grava��o de informa��es adicio-
.            nais no final da grava��o do SD3. Usado para gravar os campos:
.            APLICA��O, TAG, MATRICULA, EMPRESA, CONTA CONT�BIL
���������������������������������������������������������������������������*/

Public za_CtaPI := SB1->B1_CONTA     // Vari�vel criada em 19/03/13 para atender a grava��o da conta cont�bil do Ativo quando a OP for de PI
Public az_clvl  := SC2->C2_CLVL      // IIF(cEmpAnt == "01", "3110", IIF(cEmpAnt == "05", "3200", "")) -- Retirado em 04/06/13 por Marcos Alberto Soprani
Public az_NmDoc := SD3->D3_DOC
Public az_NmSeq := SD3->D3_NUMSEQ
Public az_Local := SD3->D3_LOCAL
Public az_NmLot := SD3->D3_NUMLOTE
Public az_LtCtl := SD3->D3_LOTECTL
Public az_NmSre := SD3->D3_NUMSERI
Public az_QtdPd := SD3->D3_QUANT     // Vari�vel para o Ponto de Entrada A250ETRAN
Public az_Prodt := SD3->D3_COD       // Vari�vel para o Ponto de Entrada A250ETRAN
Public az_TipPr := SB1->B1_TIPO      // Vari�vel para o Ponto de Entrada A250ETRAN
Public az_Pesol := SB1->B1_PESO      // Vari�vel para o Ponto de Entrada A250ETRAN
Public az_DtEms := SD3->D3_EMISSAO   // Vari�vel para o Ponto de Entrada A250ETRAN
Public az_GrpPr := SB1->B1_GRUPO     // Vari�vel para o Ponto de Entrada A250ETRAN
Public az_Ident := SD3->D3_IDENT     // Vari�vel para o Ponto de Entrada A250ETRAN
Public az_TM    := "999"             // Vari�vel para o Ponto de Entrada A250ETRAN - incluida em 28/01/13
Public az_CF    := "RE1"             // Vari�vel para o Ponto de Entrada A250ETRAN - incluida em 28/01/13

Public az_Aplic := SD3->D3_YAPLIC    // Vari�vel para o Ponto de Entrada A250ETRAN - incluida em 21/03/13
Public az_Tag   := SD3->D3_YTAG      // Vari�vel para o Ponto de Entrada A250ETRAN - incluida em 21/03/13
Public az_Matrc := SD3->D3_YMATRIC   // Vari�vel para o Ponto de Entrada A250ETRAN - incluida em 21/03/13
Public az_Emprx := SD3->D3_YEMPR     // Vari�vel para o Ponto de Entrada A250ETRAN - incluida em 21/03/13
Public az_Driver := SD3->D3_YDRIVER    // Vari�vel para o Ponto de Entrada A250ETRAN - incluida em 14/01/19

Public az_OpNum := SD3->D3_OP        // Vari�vel para o Ponto de Entrada A250ETRAN - incluida em 21/08/15

// Em 04/09/12 foi associado o programa BIA292 porque com a baixa autom�tica das caixas e demais insumos, a contabiliza��o estava ficando errada: por Marcos Alberto Soprani.
// Idenficado em 11/01/13 que quando o apontamento era autom�tico (no caso da Biancogres estava apresentando erro, no caso da Incesa n�o porque n�o � feito o apontamento autom�tico).
// Ajustada por Marcos Alberto Soprani nesta data para tratamento da rotina autom�tica.

// Em 18/03/13 ajustada grava��o do campo D3_CONTA para tratamento de OP de PI.
//       Se a OP � de PI todos os componentes baixados receber�o a conta de ativo do pr�prio PI.
//       Quando foi diferente de PI, grava a conta Custo do pr�prio insumo (mesmo sendo ele PI)

If Upper(Alltrim(FUNNAME())) $ "MATA250/BIA292/BIA742/BIA785/BIA570" .Or. IsInCallsTack("U_BIAFG120") .or. Type("_ExcAut292") <> "U"
	
	A0001 := " UPDATE "+RetSqlName("SD3")
	A0001 += "    SET D3_YAPLIC = '"+SD3->D3_YAPLIC+"',
	A0001 += "        D3_YTAG = '"+SD3->D3_YTAG+"',
	A0001 += "        D3_YDRIVER = '"+SD3->D3_YDRIVER+"',
	A0001 += "        D3_YMATRIC = '"+SD3->D3_YMATRIC+"',
	A0001 += "        D3_YEMPR = '"+SD3->D3_YEMPR+"',
	A0001 += "        D3_CC = '3000',
	A0001 += "        D3_CLVL = '"+az_clvl+"',
	If az_TipPr == "PI"
		A0001 += "        D3_CONTA = '"+za_CtaPI+"'
	Else
		A0001 += "        D3_CONTA = (SELECT B1_YCTRIND
		A0001 += "                      FROM "+RetSqlName("SB1")
		A0001 += "                     WHERE B1_FILIAL = '"+xFilial("SB1")+"'
		A0001 += "                       AND B1_COD = D3_COD
		A0001 += "                       AND D_E_L_E_T_ = ' ')
	EndIf
	A0001 += "  WHERE D3_FILIAL = '"+xFilial("SD3")+"'
	A0001 += "    AND D3_OP = '"+SD3->D3_OP+"'
	A0001 += "    AND D3_NUMSEQ = '"+SD3->D3_NUMSEQ+"'
	A0001 += "    AND D3_TM <> '010'
	A0001 += "    AND D3_ESTORNO = ' '
	A0001 += "    AND D_E_L_E_T_ = ' '
	TCSQLExec(A0001)
	
ElseIf Upper(Alltrim(FUNNAME())) == "BIA257"
	
	ef_Empz := IIF(MV_PAR10 == 1, "01", "03")
	A0001 := " UPDATE "+RetSqlName("SD3")
	A0001 += "    SET D3_YAPLIC = '"+Alltrim(Str(MV_PAR07))+"',
	A0001 += "        D3_YTAG = '"+MV_PAR08+"',
	A0001 += "        D3_YMATRIC = '"+MV_PAR09+"',
	A0001 += "        D3_YEMPR = '"+ef_Empz+"',
	A0001 += "        D3_CC = '3000',
	A0001 += "        D3_CLVL = '"+az_clvl+"',
	If az_TipPr == "PI"
		A0001 += "        D3_CONTA = '"+za_CtaPI+"'
	Else
		A0001 += "        D3_CONTA = (SELECT B1_YCTRIND
		A0001 += "                      FROM "+RetSqlName("SB1")
		A0001 += "                     WHERE B1_FILIAL = '"+xFilial("SB1")+"'
		A0001 += "                       AND B1_COD = D3_COD
		A0001 += "                       AND D_E_L_E_T_ = ' ')
	EndIf
	A0001 += "  WHERE D3_FILIAL = '"+xFilial("SD3")+"'
	A0001 += "    AND D3_OP = '"+SD3->D3_OP+"'
	A0001 += "    AND D3_NUMSEQ = '"+SD3->D3_NUMSEQ+"'
	A0001 += "    AND D3_TM <> '010'
	A0001 += "    AND D3_ESTORNO = ' '
	A0001 += "    AND D_E_L_E_T_ = ' '
	TCSQLExec(A0001)
	
ElseIf Upper(Alltrim(FUNNAME())) == "BIA570" .Or. IsInCallsTack("U_BIAFG120")
	
	// Tenho que repensar a quest�o grava��o complementar referente cancelamento de etiqueta.... 03/06/15
	If klCancCtrl
		
		GJ003 := " SELECT DISTINCT D3_COD, D3_LOCAL
		GJ003 += "   FROM " + RetSqlName("SD3")
		GJ003 += "  WHERE D3_FILIAL = '"+xFilial("SD3")+"'
		GJ003 += "    AND D3_DOC = '"+SD3->D3_DOC+"'
		GJ003 += "    AND D3_TM IN('211')
		GJ003 += "    AND D3_CF IN('DE3','RE3')
		GJ003 += "    AND D_E_L_E_T_ = ' '
		GJcIndex := CriaTrab(Nil,.f.)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,GJ003),'GJ03',.T.,.T.)
		
		GU004 := " UPDATE " + RetSqlName("SD3") + " SET D3_CF = SUBSTRING(D3_CF,1,2)+'0', D3_LOCAL = '99'
		GU004 += "   FROM " + RetSqlName("SD3")
		GU004 += "  WHERE D3_FILIAL = '"+xFilial("SD3")+"'
		GU004 += "    AND D3_DOC = '"+SD3->D3_DOC+"'
		GU004 += "    AND D3_TM IN('211')
		GU004 += "    AND D3_CF IN('DE3','RE3')
		GU004 += "    AND D_E_L_E_T_ = ' '
		TCSQLExec(GU004)
		
		dbSelectArea("GJ03")
		dbGoTop()
		ProcRegua(RecCount())
		While !Eof()
			
			// Corrige o Saldo no LOCAL corrente...
			aSaldos := CalcEst(GJ03->D3_COD, GJ03->D3_LOCAL, SD3->D3_EMISSAO+1)
			nQuant  := aSaldos[1]
			nCusto  := aSaldos[2]
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2") + GJ03->D3_COD + GJ03->D3_LOCAL)
				RecLock("SB2",.F.)
				SB2->B2_QATU     := nQuant
				SB2->B2_QTSEGUM  := ConvUM(GJ03->D3_COD, nQuant, 0, 2)
				SB2->B2_VATU1    := nCusto
				MsUnLock()
			EndIf
			
			// Corrige o Saldo no LOCAL 99...
			aSaldos := CalcEst(GJ03->D3_COD, "99", SD3->D3_EMISSAO+1)
			nQuant  := aSaldos[1]
			nCusto  := aSaldos[2]
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2") + GJ03->D3_COD + "99")
				RecLock("SB2",.F.)
				SB2->B2_QATU     := nQuant
				SB2->B2_QTSEGUM  := ConvUM(GJ03->D3_COD, nQuant, 0, 2)
				SB2->B2_VATU1    := nCusto
				MsUnLock()
			EndIf
			
			dbSelectArea("GJ03")
			dbSkip()
			
		End
		Ferase(GJcIndex+GetDBExtension())     //arquivo de trabalho
		Ferase(GJcIndex+OrdBagExt())          //indice gerado
		GJ03->(dbCloseArea())
		
	EndIf
	
EndIf

Return
