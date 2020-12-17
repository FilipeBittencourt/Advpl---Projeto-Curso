#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} BIA628
@author Wlysses Cerqueira (Facile)
@since 14/12/2020
@version 1.0
@Projet A-35
@description DRE - Percentual / Valor para apura��o do DRE. 
@type Program
/*/

User Function BIA628()

	Local _aSize 		:= {}
	Local _aObjects		:= {}
	Local _aInfo		:= {}
	Local _aPosObj		:= {}

	Local _aHeader		:= {}
	Local _aCols		:= {}

	Local cSeek	        := xFilial("ZOC") + SPACE(TAMSX3("ZOC_VERSAO")[1]) + SPACE(TAMSX3("ZOC_REVISA")[1]) + SPACE(TAMSX3("ZOC_ANOREF")[1])
	Local bWhile	    := {|| ZOC_FILIAL + ZOC_VERSAO + ZOC_REVISA + ZOC_ANOREF }

	Local aNoFields     := {"ZOC_VERSAO", "ZOC_REVISA", "ZOC_ANOREF"}

	Local oFont         := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	Local _nOpcA	    := 0
	Local _aButtons	    := {}

	Private _oDlg
	Private _oGetDados	:= Nil

	Private _cVersao	:= SPACE(TAMSX3("ZOC_VERSAO")[1])
	Private _oGVersao
	Private _cRevisa	:= SPACE(TAMSX3("ZOC_REVISA")[1])
	Private _oGRevisa
	Private _cAnoRef	:= SPACE(TAMSX3("ZOC_ANOREF")[1])
	Private _oGAnoRef
	Private _cDataRef	:= ctod("  /  /  ")
	Private _oGDataRef
	// Private _cHistFil	:= SPACE(TAMSX3("ZOC_HIST")[1])
	Private _oGHistFil

	_aSize := MsAdvSize(.T.)

	AAdd(_aObjects, {100, 10, .T. , .T. })
	AAdd(_aObjects, {100, 90, .T. , .T. })

	_aInfo   := {_aSize[1], _aSize[2], _aSize[3], _aSize[4], 5, 5}

	_aPosObj := MsObjSize(_aInfo, _aObjects, .T. )

	FillGetDados(4,"ZOC",1,cSeek,bWhile,,aNoFields,,,,,,@_aHeader,@_aCols)

	Define MsDialog _oDlg Title "DRE - Percentual / Valor para apura��o do DRE" From _aSize[7],0 To _aSize[6],_aSize[5] Of oMainWnd Pixel

	@ 050,010 SAY "Vers�o:" SIZE 55, 11 OF _oDlg PIXEL FONT oFont
	@ 048,050 MSGET _oGVersao VAR _cVersao Picture "@!" F3 "ZB5" SIZE 50, 11 OF _oDlg PIXEL VALID fBIA628A()

	@ 050,110 SAY "Revis�o:" SIZE 55, 11 OF _oDlg PIXEL FONT oFont
	@ 048,150 MSGET _oGRevisa VAR _cRevisa  SIZE 50, 11 OF _oDlg PIXEL VALID fBIA628B()

	@ 050,210 SAY "AnoRef:" SIZE 55, 11 OF _oDlg PIXEL FONT oFont
	@ 048,250 MSGET _oGAnoRef VAR _cAnoRef  SIZE 50, 11 OF _oDlg PIXEL VALID fBIA628C()

	// @ 050,310 SAY "DataRef:" SIZE 55, 11 OF _oDlg PIXEL FONT oFont
	// @ 048,350 MSGET _oGDataRef VAR _cDataRef  SIZE 50, 11 OF _oDlg PIXEL VALID fBIA628D()

	// @ 050,410 SAY "HistFiltro:" SIZE 55, 11 OF _oDlg PIXEL FONT oFont
	// @ 048,450 MSGET _oGHistFil VAR _cHistFil  SIZE 100, 11 OF _oDlg PIXEL VALID fBIA628G()

	_oGetDados := MsNewGetDados():New(_aPosObj[2,1], _aPosObj[2,2], _aPosObj[2,3], _aPosObj[2,4], 7, "U_B628LOK()" /*[ cLinhaOk]*/, /*[ cTudoOk]*/, "+++ZOC_LINHA" /*[ cIniCpos]*/, /*Acpos*/, /*[ nFreeze]*/, 99999 /*[ nMax]*/, "U_B628FOK()" /*cFieldOK*/, /*[ cSuperDel]*/,"U_B628DOK()" /*[ cDelOk]*/, _oDlg, _aHeader, _aCols)

	ACTIVATE DIALOG _oDlg CENTERED on Init EnchoiceBar(_oDlg, {||_nOpcA := 1, If(_oGetDados:TudoOk(),fGrvDados(),_nOpcA := 0)}, {|| _oDlg:End()},,_aButtons)

Return()

Static Function fBIA628A()

	If Empty(_cVersao)
		MsgInfo("O preenchimento do campo Vers�o � Obrigat�rio!!!")
		Return(.F.)
	EndIf

	_cRevisa := ZB5->ZB5_REVISA
	_cAnoRef := ZB5->ZB5_ANOREF

	//If !MsgYesNo("Deseja filtrar por data antes de prosseguir?", "Aten��o")
	If !Empty(_cVersao) .and. !Empty(_cRevisa) .and. !Empty(_cAnoRef)
		_oGetDados:oBrowse:SetFocus()
		Processa({ || cMsg := fBIA628F() }, "Aguarde...", "Carregando dados...",.F.)
	EndIf
	//EndIf

Return(.T.)

Static Function fBIA628B()

	If Empty(_cRevisa)
		MsgInfo("O preenchimento do campo Revis�o � Obrigat�rio!!!")
		Return(.F.)
	EndIf

	//If !MsgYesNo("Deseja filtrar por data antes de prosseguir?", "Aten��o")
	If !Empty(_cVersao) .and. !Empty(_cRevisa) .and. !Empty(_cAnoRef)
		_oGetDados:oBrowse:SetFocus()
		Processa({ || cMsg := fBIA628F() }, "Aguarde...", "Carregando dados...",.F.)
	EndIf
	//EndIf

Return()

Static Function fBIA628C()

	If Empty(_cAnoRef)
		MsgInfo("O preenchimento do campo Ano � Obrigat�rio!!!")
		Return(.F.)
	EndIf

	//If !MsgYesNo("Deseja filtrar por data antes de prosseguir?", "Aten��o")
	If !Empty(_cVersao) .and. !Empty(_cRevisa) .and. !Empty(_cAnoRef)
		_oGetDados:oBrowse:SetFocus()
		Processa({ || cMsg := fBIA628F() }, "Aguarde...", "Carregando dados...",.F.)
	EndIf
	//EndIf

Return()

Static Function fBIA628D()

	If !Empty(_cVersao) .and. !Empty(_cRevisa) .and. !Empty(_cAnoRef)
		_oGetDados:oBrowse:SetFocus()
		Processa({ || cMsg := fBIA628F() }, "Aguarde...", "Carregando dados...",.F.)
	EndIf

Return()

Static Function fBIA628G()

	If !Empty(_cVersao) .and. !Empty(_cRevisa) .and. !Empty(_cAnoRef)
		_oGetDados:oBrowse:SetFocus()
		Processa({ || cMsg := fBIA628F() }, "Aguarde...", "Carregando dados...",.F.)
	EndIf

Return()

Static Function fBIA628F()

	Local _cAlias   := GetNextAlias()
	Local M001      := GetNextAlias()
	Local _msc

	Private msrhEnter := CHR(13) + CHR(10)

	If Empty(_cVersao) .or. Empty(_cRevisa) .or. Empty(_cAnoRef)
		MsgInfo("Favor verificar o preenchimento dos campos da capa do cadastro!!!")
		Return(.F.)
	EndIf

	xfMensCompl := ""
	xfMensCompl += "Tipo Or�amento igual CONTABIL" + msrhEnter
	xfMensCompl += "Status igual Aberto" + msrhEnter
	xfMensCompl += "Data Digita��o diferente de branco e menor ou igual DataBase" + msrhEnter
	xfMensCompl += "Data Concilia��o igual branco" + msrhEnter
	xfMensCompl += "Data Encerramento igual branco" + msrhEnter

	BeginSql Alias M001
		SELECT COUNT(*) CONTAD
		FROM %TABLE:ZB5% ZB5
		WHERE ZB5_FILIAL = %xFilial:ZB5%
		AND ZB5.ZB5_VERSAO = %Exp:_cVersao%
		AND ZB5.ZB5_REVISA = %Exp:_cRevisa%
		AND ZB5.ZB5_ANOREF = %Exp:_cAnoRef%
		AND RTRIM(ZB5.ZB5_TPORCT) = 'CONTABIL'
		AND ZB5.ZB5_STATUS = 'A'
		AND ZB5.ZB5_DTDIGT <> ''
		AND ZB5.ZB5_DTDIGT <= %Exp:dtos(Date())%
		AND ZB5.ZB5_DTCONS = ''
		AND ZB5.ZB5_DTENCR = ''
		AND ZB5.%NotDel%
	EndSql

	(M001)->(dbGoTop())

	If (M001)->CONTAD <> 1
		MsgALERT("A vers�o informada n�o est� ativa para execu��o deste processo." + msrhEnter + msrhEnter + "Favor verificar o preenchimento dos campos no tabela de controle de vers�o conforme abaixo:" + msrhEnter + msrhEnter + xfMensCompl + msrhEnter + msrhEnter + "Favor verificar com o respons�vel pelo processo Or�ament�rio!!!")
		(M001)->(dbCloseArea())
		Return(.F.)
	EndIf

	(M001)->(dbCloseArea())

	BeginSql Alias _cAlias

        SELECT *,
        (SELECT COUNT(*)
        FROM %TABLE:ZOC% ZOC
        WHERE ZOC_FILIAL = %xFilial:ZOC%
        AND ZOC_VERSAO = %Exp:_cVersao%
        AND ZOC_REVISA = %Exp:_cRevisa%
        AND ZOC_ANOREF = %Exp:_cAnoRef%
        // AND ZOC_DATA = %Exp:_cDataRef%
        //AND ZOC_ORIPRC = 'CONTABIL'
        AND ZOC.%NotDel%
        ) NUMREG
        FROM %TABLE:ZOC% ZOC
        WHERE ZOC_FILIAL = '%xFilial:ZOC%'
        AND ZOC_VERSAO = %Exp:_cVersao%
        AND ZOC_REVISA = %Exp:_cRevisa%
        AND ZOC_ANOREF = %Exp:_cAnoRef%
        // AND ZOC_DATA = %Exp:_cDataRef%
        //AND ZOC_ORIPRC = 'CONTABIL'
        AND ZOC.%NotDel%
        ORDER BY ZOC_VERSAO, ZOC_REVISA, ZOC_ANOREF, ZOC_LINHA

	EndSql

	xtrTot :=  (_cAlias)->(NUMREG)

	ProcRegua(xtrTot)

	(_cAlias)->(dbGoTop())

	_oGetDados:aCols :=	{}

	If (_cAlias)->(!Eof())

		While (_cAlias)->(!Eof())

			IncProc("Carregando dados " + AllTrim(Str((_cAlias)->(Recno()))) + " de " + AllTrim(Str(xtrTot)))

			AADD(_oGetDados:aCols, Array(Len(_oGetDados:aHeader)+1) )

			For _msc := 1 To Len(_oGetDados:aHeader)

				If Alltrim(_oGetDados:aHeader[_msc][2]) == "ZOC_ALI_WT"
					_oGetDados:aCols[Len(_oGetDados:aCols), _msc] := "ZOC"

				ElseIf Alltrim(_oGetDados:aHeader[_msc][2]) == "ZOC_REC_WT"
					_oGetDados:aCols[Len(_oGetDados:aCols), _msc] := R_E_C_N_O_

				ElseIf Alltrim(_oGetDados:aHeader[_msc][2]) == "ZOC_DDEB"
					_oGetDados:aCols[Len(_oGetDados:aCols), _msc] := Posicione("CT1", 1, xFilial("CT1") + (_cAlias)->ZOC_DEBITO, "CT1_DESC01")

				ElseIf Alltrim(_oGetDados:aHeader[_msc][2]) == "ZOC_DCRD"
					_oGetDados:aCols[Len(_oGetDados:aCols), _msc] := Posicione("CT1", 1, xFilial("CT1") + (_cAlias)->ZOC_CREDIT, "CT1_DESC01")

				ElseIf Alltrim(_oGetDados:aHeader[_msc][2]) == "ZOC_DCVDB"
					_oGetDados:aCols[Len(_oGetDados:aCols), _msc] := Posicione("CTH", 1, xFilial("CTH") + (_cAlias)->ZOC_CLVLDB, "CTH_DESC01")

				ElseIf Alltrim(_oGetDados:aHeader[_msc][2]) == "ZOC_DCVCR"
					_oGetDados:aCols[Len(_oGetDados:aCols), _msc] := Posicione("CTH", 1, xFilial("CTH") + (_cAlias)->ZOC_CLVLCR, "CTH_DESC01")

				ElseIf Alltrim(_oGetDados:aHeader[_msc][2]) == "ZOC_DATA"
					_oGetDados:aCols[Len(_oGetDados:aCols), _msc] := stod((_cAlias)->ZOC_DATA)

				ElseIf Alltrim(_oGetDados:aHeader[_msc][2]) == "ZOC_YDELTA"
					_oGetDados:aCols[Len(_oGetDados:aCols), _msc] := stod((_cAlias)->ZOC_YDELTA)

				Else

					_oGetDados:aCols[Len(_oGetDados:aCols), _msc] := &(Alltrim(_oGetDados:aHeader[_msc][2]))

				EndIf

			Next _msc

			_oGetDados:aCols[Len(_oGetDados:aCols), _msc] := .F.

			(_cAlias)->(dbSkip())

		EndDo

		(_cAlias)->(dbCloseArea())

	Else

		_oGetDados:aCols :=	{}

		_oGetDados:AddLine(.F., .F.)

	EndIf

	_oGetDados:Refresh()

Return(.T.)

Static Function fGrvDados()

	Local _nI
	Local _msc

	Local nPosRec := aScan(_oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZOC_REC_WT"})

	Local nPosDel	:=	Len(_oGetDados:aHeader) + 1

	dbSelectArea('ZOC')
	For _nI	:=	1 To Len(_oGetDados:aCols)

		If _oGetDados:aCols[_nI,nPosRec] > 0

			ZOC->(dbGoTo(_oGetDados:aCols[_nI,nPosRec]))

			Reclock("ZOC",.F.)

			If !_oGetDados:aCols[_nI,nPosDel]

				For _msc := 1 To Len(_oGetDados:aHeader)

					If _oGetDados:aHeader[_msc][10] == "R" .and. _oGetDados:aHeader[_msc][8] <> "D"

						nPosColG := aScan(_oGetDados:aHeader,{|x| AllTrim(x[2]) == Alltrim(_oGetDados:aHeader[_msc][2])})
						&("ZOC->" + Alltrim(_oGetDados:aHeader[_msc][2])) := _oGetDados:aCols[_nI, nPosColG]

					ElseIf _oGetDados:aHeader[_msc][10] == "R" .and. _oGetDados:aHeader[_msc][8] == "D"

						nPosColG := aScan(_oGetDados:aHeader,{|x| AllTrim(x[2]) == Alltrim(_oGetDados:aHeader[_msc][2])})
						&("ZOC->" + Alltrim(_oGetDados:aHeader[_msc][2])) := IIF( Valtype(_oGetDados:aCols[_nI, nPosColG]) == "D", _oGetDados:aCols[_nI, nPosColG], ctod(_oGetDados:aCols[_nI, nPosColG]) )

					EndIf

				Next _msc

			Else

				ZOC->(DbDelete())

			EndIf

			ZOC->(MsUnlock())

		Else

			If !_oGetDados:aCols[_nI,nPosDel]

				Reclock("ZOC",.T.)

				ZOC->ZOC_FILIAL  := xFilial("ZOC")
				ZOC->ZOC_VERSAO  := _cVersao
				ZOC->ZOC_REVISA  := _cRevisa
				ZOC->ZOC_ANOREF  := _cAnoRef

				// ZOC->ZOC_ORIPRC  := "CONTABIL"
				// ZOC->ZOC_LOTE    := "004100"
				// ZOC->ZOC_SBLOTE  := "001"

				For _msc := 1 To Len(_oGetDados:aHeader)

					If _oGetDados:aHeader[_msc][10] == "R" .and. _oGetDados:aHeader[_msc][8] <> "D"

						nPosColG := aScan(_oGetDados:aHeader,{|x| AllTrim(x[2]) == Alltrim(_oGetDados:aHeader[_msc][2])})
						&("ZOC->" + Alltrim(_oGetDados:aHeader[_msc][2])) := _oGetDados:aCols[_nI, nPosColG]

					ElseIf _oGetDados:aHeader[_msc][10] == "R" .and. _oGetDados:aHeader[_msc][8] == "D"

						nPosColG := aScan(_oGetDados:aHeader,{|x| AllTrim(x[2]) == Alltrim(_oGetDados:aHeader[_msc][2])})
						&("ZOC->" + Alltrim(_oGetDados:aHeader[_msc][2])) := IIF( Valtype(_oGetDados:aCols[_nI, nPosColG]) == "D", _oGetDados:aCols[_nI, nPosColG], ctod(_oGetDados:aCols[_nI, nPosColG]) )

					EndIf

				Next _msc

				ZOC->(MsUnlock())

			EndIf

		EndIf

	Next

	_cVersao := SPACE(TAMSX3("ZOC_VERSAO")[1])
	_cRevisa := SPACE(TAMSX3("ZOC_REVISA")[1])
	_cAnoRef := SPACE(TAMSX3("ZOC_ANOREF")[1])

	_oGetDados:aCols :=	{}

	_oGetDados:AddLine(.F., .F.)

	_oGVersao:SetFocus()
	_oGVersao:Refresh()
	_oGetDados:Refresh()

	_oDlg:Refresh()

	MsgInfo("Registro Inclu�do com Sucesso!")

Return()

User Function B628FOK()

	Local cMenVar    := ReadVar()
	Local vfArea     := GetArea()
	Local _cAlias
	Local _nAt       := _oGetDados:nAt
	Local _nI
	Local isDC       := ""
	Local isDEBITO   := ""
	Local isCREDIT   := ""
	Local isCLVLDB   := ""
	Local isCLVLCR   := ""
	Local isITEMD    := ""
	Local isITEMC    := ""

	If !GDdeleted(_nAt)

		Do Case

		Case Alltrim(cMenVar) == "M->ZOC_DC"
			isDC       := M->ZOC_DC
			isDEBITO   := GdFieldGet("ZOC_DEBITO",_nAt)
			isCREDIT   := GdFieldGet("ZOC_CREDIT",_nAt)
			isCLVLDB   := GdFieldGet("ZOC_CLVLDB",_nAt)
			isCLVLCR   := GdFieldGet("ZOC_CLVLCR",_nAt)
			isITEMD    := GdFieldGet("ZOC_ITEMD",_nAt)
			isITEMC    := GdFieldGet("ZOC_ITEMC",_nAt)
			If !isDC $ "1/2/3"
				MsgINFO("Somente s�o permitidos os valores 1=D�bito; 2=Cr�dito; 3=Partida Dobrada")
				Return(.F.)
			EndIf
			GdFieldPut("ZOC_ORGLAN" , IIF(isDC == "1", "D", IIF(isDC == "2", "C", IIF(isDC == "3", "P", ""))) , _nAt)

		Case Alltrim(cMenVar) == "M->ZOC_DEBITO"
			isDC       := GdFieldGet("ZOC_DC",_nAt)
			isDEBITO   := M->ZOC_DEBITO
			isCREDIT   := GdFieldGet("ZOC_CREDIT",_nAt)
			isCLVLDB   := GdFieldGet("ZOC_CLVLDB",_nAt)
			isCLVLCR   := GdFieldGet("ZOC_CLVLCR",_nAt)
			isITEMD    := GdFieldGet("ZOC_ITEMD",_nAt)
			isITEMC    := GdFieldGet("ZOC_ITEMC",_nAt)
			If !Empty(isDEBITO)
				If !ExistCPO("CT1")
					Return(.F.)
				EndIf
			EndIf
			GdFieldPut("ZOC_DDEB"     , Posicione("CT1", 1, xFilial("CT1") + isDEBITO, "CT1_DESC01") , _nAt)

		Case Alltrim(cMenVar) == "M->ZOC_CREDIT"
			isDC       := GdFieldGet("ZOC_DC",_nAt)
			isDEBITO   := GdFieldGet("ZOC_DEBITO",_nAt)
			isCREDIT   := M->ZOC_CREDIT
			isCLVLDB   := GdFieldGet("ZOC_CLVLDB",_nAt)
			isCLVLCR   := GdFieldGet("ZOC_CLVLCR",_nAt)
			isITEMD    := GdFieldGet("ZOC_ITEMD",_nAt)
			isITEMC    := GdFieldGet("ZOC_ITEMC",_nAt)
			If !Empty(isCREDIT)
				If !ExistCPO("CT1")
					Return(.F.)
				EndIf
			EndIf
			GdFieldPut("ZOC_DCRD"     , Posicione("CT1", 1, xFilial("CT1") + isCREDIT, "CT1_DESC01") , _nAt)

		Case Alltrim(cMenVar) == "M->ZOC_CLVLDB"
			isDC       := GdFieldGet("ZOC_DC",_nAt)
			isDEBITO   := GdFieldGet("ZOC_DEBITO",_nAt)
			isCREDIT   := GdFieldGet("ZOC_CREDIT",_nAt)
			isCLVLDB   := M->ZOC_CLVLDB
			isCLVLCR   := GdFieldGet("ZOC_CLVLCR",_nAt)
			isITEMD    := GdFieldGet("ZOC_ITEMD",_nAt)
			isITEMC    := GdFieldGet("ZOC_ITEMC",_nAt)
			If !Empty(isCLVLDB)
				If !ExistCPO("CTH")
					Return(.F.)
				EndIf
			EndIf
			If !U_B628VdCl(isCLVLDB)
				MsgINFO("A classe de valor informada n�o est� associada a empresa or�ament�ria posicionada.")
				Return(.F.)
			EndIf
			GdFieldPut("ZOC_DCVDB"    , Posicione("CTH", 1, xFilial("CTH") + isCLVLDB, "CTH_DESC01") , _nAt)

		Case Alltrim(cMenVar) == "M->ZOC_CLVLCR"
			isDC       := GdFieldGet("ZOC_DC",_nAt)
			isDEBITO   := GdFieldGet("ZOC_DEBITO",_nAt)
			isCREDIT   := GdFieldGet("ZOC_CREDIT",_nAt)
			isCLVLDB   := GdFieldGet("ZOC_CLVLDB",_nAt)
			isCLVLCR   := M->ZOC_CLVLCR
			isITEMD    := GdFieldGet("ZOC_ITEMD",_nAt)
			isITEMC    := GdFieldGet("ZOC_ITEMC",_nAt)
			If !Empty(isCLVLCR)
				If !ExistCPO("CTH")
					Return(.F.)
				EndIf
			EndIf
			If !U_B628VdCl(isCLVLCR)
				MsgINFO("A classe de valor informada n�o est� associada a empresa or�ament�ria posicionada.")
				Return(.F.)
			EndIf
			GdFieldPut("ZOC_DCVCR"    , Posicione("CTH", 1, xFilial("CTH") + isCLVLCR, "CTH_DESC01") , _nAt)

		Case Alltrim(cMenVar) == "M->ZOC_ITEMD"
			isDC       := GdFieldGet("ZOC_DC",_nAt)
			isDEBITO   := GdFieldGet("ZOC_DEBITO",_nAt)
			isCREDIT   := GdFieldGet("ZOC_CREDIT",_nAt)
			isCLVLDB   := GdFieldGet("ZOC_CLVLDB",_nAt)
			isCLVLCR   := GdFieldGet("ZOC_CLVLCR",_nAt)
			isITEMD    := M->ZOC_ITEMD
			isITEMC    := GdFieldGet("ZOC_ITEMC",_nAt)
			If !ExistCPO("CTD")
				Return(.F.)
			EndIf

		Case Alltrim(cMenVar) == "M->ZOC_ITEMC"
			isDC       := GdFieldGet("ZOC_DC",_nAt)
			isDEBITO   := GdFieldGet("ZOC_DEBITO",_nAt)
			isCREDIT   := GdFieldGet("ZOC_CREDIT",_nAt)
			isCLVLDB   := GdFieldGet("ZOC_CLVLDB",_nAt)
			isCLVLCR   := GdFieldGet("ZOC_CLVLCR",_nAt)
			isITEMD    := GdFieldGet("ZOC_ITEMD",_nAt)
			isITEMC    := M->ZOC_ITEMC
			If !ExistCPO("CTD")
				Return(.F.)
			EndIf

		EndCase

	EndIf

Return(.T.)

User Function B628LOK()

	Local _lRet	:=	.T.
	xxDC       := GdFieldGet("ZOC_DC", n)
	xxDEBITO   := GdFieldGet("ZOC_DEBITO", n)
	xxCREDIT   := GdFieldGet("ZOC_CREDIT", n)
	xxCLVLDB   := GdFieldGet("ZOC_CLVLDB", n)
	xxCLVLCR   := GdFieldGet("ZOC_CLVLCR", n)
	xxITEMD    := GdFieldGet("ZOC_ITEMD", n)
	xxITEMC    := GdFieldGet("ZOC_ITEMC", n)

	If xxDC == "1"
		If Empty(xxDEBITO) .or. Empty(xxCLVLDB) .or. !Empty(xxCREDIT) .or. !Empty(xxCLVLCR) .or. !Empty(xxITEMC)
			MsgINFO("Favor verificar o tipo de lan�amento vs conta e classe de valor preenchidos, pois s�o conflitantes!!!")
			Return(.F.)
		EndIf
	EndIf

	If xxDC == "2"
		If Empty(xxCREDIT) .or. Empty(xxCLVLCR) .or. !Empty(xxDEBITO) .or. !Empty(xxCLVLDB) .or. !Empty(xxITEMD)
			If Alltrim(xxCREDIT) == "41301001"
				If !Empty(xxCLVLCR) .or. !Empty(xxCLVLDB)
					MsgINFO("Favor verificar, pois a conta 41301001 quanto receita n�o pode ter classe de valor associada!!!")
					Return(.F.)
				EndIf
			Else
				MsgINFO("Favor verificar o tipo de lan�amento vs conta e classe de valor preenchidos, pois s�o conflitantes!!!")
				Return(.F.)
			EndIf
		EndIf
	EndIf

	If xxDC == "3"
		If Empty(xxDEBITO) .or. Empty(xxCLVLDB) .or. Empty(xxCREDIT) .or. Empty(xxCLVLCR)
			MsgINFO("Favor verificar o tipo de lan�amento vs conta e classe de valor preenchidos, pois s�o conflitantes!!!")
			Return(.F.)
		EndIf
	EndIf

Return(_lRet)

User Function B628DOK()

	Local _lRet	:=	.T.

Return(_lRet)

User Function B628VdCl(ksCLVL)

	Local ukRet := .T.

	dbSelectArea("CTH")
	dbSetOrder(1)
	If !Empty(Alltrim(ksCLVL))
		If dbSeek(xFilial("CTH") + ksCLVL)
			If cEmpAnt <> Substr(CTH->CTH_YEFORC,1,2)
				ukRet   := .F.
			EndIf
		EndIf
	EndIf

Return(ukRet)

/*___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun�ao    � B628IEXC � Autor � Marcos Alberto S      � Data � 21/06/17 ���
��+----------+------------------------------------------------------------���
���Descri��o � Importa��o planilha Excel para Or�amento - Custo Vari�vel  ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function B628IEXC()

	Local aSays	   		:= {} 
	Local aButtons 		:= {}  
	Local lConfirm 		:= .F. 
	Private cArquivo	:= space(100)

	If !Empty(_cDataRef) .or. !Empty(_cHistFil)
		MsgSTOP("Somente poder� ser usada a rotina de importa��o quando DataRef e HistFiltro estiverem vazios", "Controle de Importa��o!!!")
		Return()
	EndIf

	fPergunte()

	AADD(aSays, OemToAnsi("Rotina para importa��o dos ajustes or�ament�rio direto para a tabela ZOC."))   
	AADD(aSays, OemToAnsi("Antes de continuar, verifique os par�metros!"))   
	AADD(aSays, OemToAnsi(""))   
	AADD(aSays, OemToAnsi("IMPORTANTE: >>>> n�o � permitido importar arquivos que esteja com prote��o"))   
	AADD(aSays, OemToAnsi("                 de planilha ativada!!!"))   
	AADD(aSays, OemToAnsi("               * O nome do arquivo n�o pode ter espa�o ou caracter especial"))   
	AADD(aSays, OemToAnsi("Deseja Continuar?"))   

	AADD(aButtons, { 5,.T.,{|| fPergunte() } } )
	AADD(aButtons, { 1,.T.,{|o| lConfirm := .T. , o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( OemToAnsi('Importa��o de �ndices...'), aSays, aButtons ,,,500)

	If lConfirm

		If !empty(cArquivo) .and. File(cArquivo)
			Processa({ || fProcImport() },"Aguarde...","Carregando Arquivo...",.F.)
		Else
			MsgStop('Informe o arquivo valido para importa��o!')
		EndIf

	EndIf

Return()

//Parametros
Static Function fPergunte()

	Local aPergs 	:= {}
	Local cLoad	    := 'B628IEXC' + cEmpAnt
	Local cFileName := RetCodUsr() +"_"+ cLoad
	cArquivo		:= space(100) 

	aAdd( aPergs ,{6,"Arquivo para Importa��o: " 	,cArquivo  ,"","","", 75 ,.T.,"Arquivo * |*",,GETF_LOCALHARD+GETF_NETWORKDRIVE} )		

	If ParamBox(aPergs ,"Importar Arquivo",,,,,,,,cLoad,.T.,.T.)
		cArquivo  := ParamLoad(cFileName,,1,cArquivo) 
	Endif

Return()

//Processa importa��o
Static Function fProcImport()

	Local aArea 			:= GetArea()
	Local oArquivo 			:= nil
	Local aArquivo 			:= {}
	Local aWorksheet 		:= {}
	Local aCampos			:= {}
	Local cTemp 			:= ''
	Local cTabImp			:= 'ZOC'
	Local aItem 			:= {}
	Local aLinha			:= {}
	Local aErro				:= {}
	Local cErro 			:= ''
	Local nImport			:= 0
	Local cConteudo			:= ''
	Local nTotLin			:= 0
	Local vnb
	Local ny
	Local _msc
	Local nx

	Local nPosRec  := aScan(_oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZOC_REC_WT"})
	Local vtRecGrd := {}

	_ImpaColsBkp  := aClone(_oGetDados:aCols)

	For vnb := 1 To Len(_ImpaColsBkp)
		AADD(vtRecGrd, _ImpaColsBkp[vnb][nPosRec])	
	Next vnb

	If Len(vtRecGrd) == 1
		nPrimeralin := _ImpaColsBkp[Len(_ImpaColsBkp)][nPosRec]
		If nPrimeralin == 0
			_oGetDados:aCols := {}
		EndIf
	EndIf

	ProcRegua(0) 

	msTmpINI := Time()
	oArquivo := TBiaArquivo():New()
	aArquivo := oArquivo:GetArquivo(cArquivo)

	msDtProc  := Date()
	msHrProc  := Time()
	msTmpRead := Alltrim(ElapTime(msTmpINI, msHrProc))

	If Len(aArquivo) > 0

		msTpLin   := Alltrim( Str( ( ( Val( Substr(msTmpRead,1,2)) * 3600 ) + ( Val(Substr(msTmpRead,4,2)) * 360 ) + ( Val(Substr(msTmpRead,7,2)) ) ) / Len(aArquivo[1]) ) )

		aWorksheet 	:= aArquivo[1]	
		nTotLin		:= len(aWorksheet)

		ProcRegua(nTotLin)

		For nx := 1 To len(aWorksheet)

			IncProc("Tmp Leit:(" + msTmpRead + ") Proc: " + StrZero(nx,6) + "/" + StrZero(nTotLin,6) )	

			If nx == 1

				aCampos := aWorksheet[nx]
				For ny := 1 To len(aCampos)
					cTemp := SubStr(UPPER(aCampos[ny]),AT(cTabImp+'_',UPPER(aCampos[ny])),10)
					aCampos[ny] := cTemp
				Next ny

			Else

				aLinha    := aWorksheet[nx]
				aItem     := {}
				cConteudo := ''

				nLinReg   := 0
				nPosRec   := aScan(aCampos,{|x| AllTrim(x) == "ZOC_REC_WT"})

				If nPosRec <> 0

					nLinReg := aScan(vtRecGrd,{|x| x == Val(Alltrim(aLinha[nPosRec]))})
					If nLinReg == 0 .or. Val(Alltrim(aLinha[nPosRec])) == 0

						_oGetDados:aCols :=	{}

						_oGetDados:AddLine(.F., .F.)

						_oGetDados:Refresh()

						nLinReg := Len(_oGetDados:aCols)

					EndIf

					For _msc := 1 To Len(aCampos)

						xkPosCampo := aScan(_oGetDados:aHeader,{|x| AllTrim(x[2]) == aCampos[_msc]})
						If xkPosCampo <> 0
							If _oGetDados:aHeader[xkPosCampo][8] == "N"
								_oGetDados:aCols[nLinReg, xkPosCampo] := Val(Alltrim(aLinha[_msc]))
							Else
								_oGetDados:aCols[nLinReg, xkPosCampo] := aLinha[_msc]
							EndIf
						EndIf

					Next _msc

					_oGetDados:aCols[nLinReg, Len(_oGetDados:aHeader)+1] := .F.	
					nImport ++

				Else

					MsgALERT("Erro no Layout do Arquivo de Importa��o!!!")
					nImport := 0
					Exit

				EndIf

			EndIf

		Next nx

	EndIf

	If nImport > 0

		MsgInfo("Registros importados com sucesso")

	Else

		MsgStop("Falha na importa��o dos registros")

		_oGetDados:aCols := {}

		_oGetDados:AddLine(.F., .F.)

		_oGetDados:Refresh()

	EndIf

	RestArea(aArea)

Return()
