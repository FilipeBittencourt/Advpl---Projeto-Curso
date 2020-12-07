#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} BIA389
@author Marcos Alberto Soprani
@since 12/09/17
@version 1.0
@description Tela para cadastro de Controle de permiss�es � classes de valor para Or�amento
.            Inicialmente pensado para a Tipo Or�amento RH.
.            Para o or�amento 2020, foi implementado controle para o Tipo Or�ament�rio OBZ 
@type function
/*/

User Function BIA389()

	Local _aSize 		:= {} 
	Local _aObjects		:= {}
	Local _aInfo		:= {}
	Local _aPosObj		:= {}

	Local _aHeader		:= {}          
	Local _aCols		:= {}

	Local cSeek	        := xFilial("ZB9") + SPACE(TAMSX3("ZB9_VERSAO")[1]) + SPACE(TAMSX3("ZB9_REVISA")[1]) + SPACE(TAMSX3("ZB9_ANOREF")[1]) + SPACE(TAMSX3("ZB9_USER")[1])
	Local bWhile	    := {|| ZB9_FILIAL + ZB9_VERSAO + ZB9_REVISA + ZB9_ANOREF + ZB9_USER }                    
	Local aNoFields     := {"ZB9_VERSAO", "ZB9_REVISA", "ZB9_ANOREF", "ZB9_USER","ZB9_TPORCT"}

	Local oFont         := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	Local _nOpcA	    := 0
	Local _aButtons	    := {}

	Private _oDlg
	Private _oGetDados	:= Nil    
	Private _aColsBkp	:= {}
	Private _cVersao	:= SPACE(TAMSX3("ZB9_VERSAO")[1])
	Private _oGVersao
	Private _cRevisa	:= SPACE(TAMSX3("ZB9_REVISA")[1])
	Private _oGRevisa
	Private _cAnoRef	:= SPACE(TAMSX3("ZB9_ANOREF")[1])
	Private _oGAnoRef
	Private _cCodUser	:= SPACE(TAMSX3("ZB9_USER")[1])
	Private _oGCodUser
	Private _mNomeUsr   := SPACE(50) 
	Private _oComboBox1
	Private _cComboBox1 := ""
	Private _ItCombBox  := {"", "RH", "OBZ", "CAPEX", "RECEITA", "C.VARIAVEL", "CONTABIL"}

	Private _msCtrlAlt  := .T.  

	Private msrhEnter := CHR(13) + CHR(10)

	aAdd(_aButtons,{"HISTORIC",{|| U_BIA393("Q")}, "Exporta p/Excel","Exporta p/Excel"})
	aAdd(_aButtons,{"PEDIDO"  ,{|| U_B389CLVL()} , "Replica CLVL"   , "Replica CLVL"})
	aAdd(_aButtons,{"PEDIDO"  ,{|| U_B389TPOR()} , "Replica Tp. Orcto."   , "Replica Tp. Orcto."})

	_aSize := MsAdvSize(.T.)                      

	AAdd(_aObjects, {100, 10, .T. , .T. })
	AAdd(_aObjects, {100, 90, .T. , .T. })

	_aInfo   := {_aSize[1], _aSize[2], _aSize[3], _aSize[4], 5, 5}	

	_aPosObj := MsObjSize(_aInfo, _aObjects, .T. )

	FillGetDados(4,"ZB9",1,cSeek,bWhile,,aNoFields,,,,,,@_aHeader,@_aCols)
	_aColsBkp	:=	aClone(_aCols)

	Define MsDialog _oDlg Title "Controle de Permiss�es � Classes Valor" From _aSize[7],0 To _aSize[6],_aSize[5] Of oMainWnd Pixel

	@ 050,010 SAY "Vers�o:" SIZE 55, 11 OF _oDlg PIXEL FONT oFont
	@ 048,050 MSGET _oGVersao VAR _cVersao Picture "@!" F3 "ZB5" SIZE 50, 11 OF _oDlg PIXEL VALID fBIA389A()

	@ 050,110 SAY "Revis�o:" SIZE 55, 11 OF _oDlg PIXEL FONT oFont
	@ 048,150 MSGET _oGRevisa VAR _cRevisa  SIZE 50, 11 OF _oDlg PIXEL VALID fBIA389B()

	@ 050,210 SAY "AnoRef:" SIZE 55, 11 OF _oDlg PIXEL FONT oFont
	@ 048,250 MSGET _oGAnoRef VAR _cAnoRef  SIZE 50, 11 OF _oDlg PIXEL VALID fBIA389C()

	@ 050,310 SAY "Or�amento:" SIZE 55, 11 OF _oDlg PIXEL FONT oFont
	@ 048,355 MSCOMBOBOX _oComboBox1 VAR _cComboBox1 ITEMS _ItCombBox SIZE 072, 012 OF _oDlg COLORS 0, 16777215 PIXEL VALID fBIA389E()

	@ 050,435 SAY "Usu�rio:" SIZE 55, 11 OF _oDlg PIXEL FONT oFont
	@ 048,475 MSGET _oGCodUser VAR _cCodUser F3("USR") SIZE 50, 11 OF _oDlg PIXEL VALID fBIA389D()
	@ 050,535 SAY _mNomeUsr SIZE 250, 11 OF _oDlg PIXEL FONT oFont

	_oGetDados := MsNewGetDados():New(_aPosObj[2,1], _aPosObj[2,2], _aPosObj[2,3], _aPosObj[2,4], 7, /*[ cLinhaOk]*/, /*[ cTudoOk]*/, /*"+++ZZ2_COD"/*[ cIniCpos]*/, /*Acpos*/, /*[ nFreeze]*/, /*[ nMax]*/, "U_B389FOK()" /*cFieldOK*/, /*[ cSuperDel]*/,"U_B389DOK()" /*[ cDelOk]*/, _oDlg, _aHeader, _aCols)

	ACTIVATE DIALOG _oDlg CENTERED on Init EnchoiceBar(_oDlg, {||_nOpcA := 1, If(_oGetDados:TudoOk(),fGrvDados(),_nOpcA := 0)}, {|| _oDlg:End()},,_aButtons) 

Return

Static Function fBIA389A()

	If Empty(_cVersao)
		MsgInfo("O preenchimento do campo Vers�o � Obrigat�rio!!!")
		Return .F.
	EndIf
	_cRevisa := ZB5->ZB5_REVISA
	_cAnoRef := ZB5->ZB5_ANOREF
	If !Empty(_cVersao) .and. !Empty(_cRevisa) .and. !Empty(_cAnoRef) .and. !Empty(_cCodUser) .And. !Empty(_cComboBox1)
		_oGetDados:oBrowse:SetFocus()
		Processa({ || fBIA389D() }, "Aguarde...", "Carregando dados...",.F.)
	EndIf

Return .T.

Static Function fBIA389B()

	If Empty(_cRevisa)
		MsgInfo("O preenchimento do campo Revis�o � Obrigat�rio!!!")
		Return .F.
	EndIf
	If !Empty(_cVersao) .and. !Empty(_cRevisa) .and. !Empty(_cAnoRef) .and. !Empty(_cCodUser) .And. !Empty(_cComboBox1)
		_oGetDados:oBrowse:SetFocus()
		Processa({ || fBIA389D() }, "Aguarde...", "Carregando dados...",.F.)
	EndIf

Return .T.

Static Function fBIA389C()

	If Empty(_cAnoRef)
		MsgInfo("O preenchimento do campo Ano � Obrigat�rio!!!")
		Return .F.
	EndIf
	If !Empty(_cVersao) .and. !Empty(_cRevisa) .and. !Empty(_cAnoRef) .and. !Empty(_cCodUser) .And. !Empty(_cComboBox1)
		_oGetDados:oBrowse:SetFocus()
		Processa({ || fBIA389D() }, "Aguarde...", "Carregando dados...",.F.)
	EndIf

Return .T.

Static Function fBIA389E()

	If Empty(_cComboBox1)
		MsgInfo("O preenchimento do campo Tipo Or�amento � Obrigat�rio!!!")
		Return .F.
	EndIf
	If !Empty(_cVersao) .and. !Empty(_cRevisa) .and. !Empty(_cAnoRef) .and. !Empty(_cCodUser) .And. !Empty(_cComboBox1)
		_oGetDados:oBrowse:SetFocus()
		Processa({ || fBIA389D() }, "Aguarde...", "Carregando dados...",.F.)
	EndIf

Return .T.


Static Function fBIA389F()

	If Empty(_cCodUser)
		MsgInfo("O preenchimento do campo Usu�rio � Obrigat�rio!!!")
		Return .F.
	EndIf
	If !Empty(_cVersao) .and. !Empty(_cRevisa) .and. !Empty(_cAnoRef) .and. !Empty(_cCodUser) .And. !Empty(_cComboBox1)
		_oGetDados:oBrowse:SetFocus()
		Processa({ || fBIA389D() }, "Aguarde...", "Carregando dados...",.F.)
	EndIf

Return .T.

Static Function fBIA389D()

	Local _cAlias   := GetNextAlias()
	Local M001      := GetNextAlias()
	Local _cTpOrc	:=	Alltrim(_cComboBox1)

	If Empty(_cVersao) .or. Empty(_cRevisa) .or. Empty(_cAnoRef) .or. Empty(_cCodUser) .Or. Empty(_cComboBox1)
		MsgInfo("Favor verificar o preenchimento dos campos da capa do cadastro!!!")
		Return .F.
	EndIf

	psworder(1)                          // Pesquisa por Nome
	If  pswseek(_cCodUser,.t.)           // Nome do usuario, Pesquisa usuarios
		_daduser  := pswret(1)           // Numero do registro
		_mNomeUsr := _daduser[1][4]
	EndIf

	xfMensCompl := ""
	xfMensCompl += "Tipo Or�amento igual " + _cTpOrc + msrhEnter
	xfMensCompl += "Status igual Aberto" + msrhEnter
	xfMensCompl += "Data Digita��o igual a branco" + msrhEnter
	xfMensCompl += "Data Concilia��o igual a branco" + msrhEnter
	xfMensCompl += "Data Encerramento igual a branco" + msrhEnter

	BeginSql Alias M001
		SELECT COUNT(*) CONTAD
		FROM %TABLE:ZB5% ZB5
		WHERE ZB5_FILIAL = %xFilial:ZB5%
		AND ZB5.ZB5_VERSAO = %Exp:_cVersao%
		AND ZB5.ZB5_REVISA = %Exp:_cRevisa%
		AND ZB5.ZB5_ANOREF = %Exp:_cAnoRef%
		AND RTRIM(ZB5.ZB5_TPORCT) = %Exp:_cTpOrc%
		AND ZB5.ZB5_STATUS = 'A'
		AND ZB5.ZB5_DTDIGT = ''
		AND ZB5.ZB5_DTCONS = ''
		AND ZB5.ZB5_DTENCR = ''
		AND ZB5.%NotDel%
	EndSql
	(M001)->(dbGoTop())
	If (M001)->CONTAD <> 1
		MsgALERT("A vers�o informada n�o est� ativa para execu��o deste processo." + msrhEnter + msrhEnter + "Favor verificar o preenchimento dos campos no tabela de controle de vers�o conforme abaixo:" + msrhEnter + msrhEnter + xfMensCompl + msrhEnter + msrhEnter + "Favor verificar com o respons�vel pelo processo Or�ament�rio!!!")
		_msCtrlAlt := .F.
		_oGetDados:lInsert := .F.
		_oGetDados:lUpdate := .F.
		_oGetDados:lDelete := .F.
	Else
		_msCtrlAlt := .T.
		_oGetDados:lInsert := .T.
		_oGetDados:lUpdate := .T.
		_oGetDados:lDelete := .T.
	EndIf	
	(M001)->(dbCloseArea())

	_oGetDados:aCols	:=	{}

	BeginSql Alias _cAlias

		SELECT *
		FROM %TABLE:ZB9% ZB9
		WHERE ZB9_FILIAL = %xFilial:ZB9%
		AND ZB9_VERSAO = %Exp:_cVersao%
		AND ZB9_REVISA = %Exp:_cRevisa%
		AND ZB9_ANOREF = %Exp:_cAnoRef%
		AND ZB9_USER = %Exp:_cCodUser%
		AND ZB9_TPORCT = %Exp:_cTpOrc%
		AND ZB9.%NotDel%
		ORDER BY ZB9_CLVL
	EndSql

	If (_cAlias)->(!Eof())

		While (_cAlias)->(!Eof())

			(_cAlias)->(aAdd(_oGetDados:aCols,{ZB9_CLVL,;
			Posicione("CTH", 1, xFilial("CTH") + ZB9_CLVL, "CTH_DESC01"),;
			ZB9_DIGIT,;
			ZB9_VISUAL,;
			"ZB9",	;
			R_E_C_N_O_,;
			.F.	}))

			(_cAlias)->(dbSkip())

		EndDo

		(_cAlias)->(dbCloseArea())

	Else

		_oGetDados:aCols	:=	aClone(_aColsBkp)

	EndIf	

	_oGetDados:Refresh()

Return .T.

Static Function fGrvDados()

	Local _nI

	Local nPosRec := aScan(_oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZB9_REC_WT"})
	Local mCLVL   := aScan(_oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZB9_CLVL"})
	Local mDIGIT  := aScan(_oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZB9_DIGIT"})
	Local mVISUAL := aScan(_oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZB9_VISUAL"})

	Local nPosDel	:=	Len(_oGetDados:aHeader) + 1	

	If _msCtrlAlt

		dbSelectArea('ZB9')
		For _nI	:=	1 to Len(_oGetDados:aCols)

			If _oGetDados:aCols[_nI,nPosRec] > 0

				ZB9->(dbGoTo(_oGetDados:aCols[_nI,nPosRec]))
				Reclock("ZB9",.F.)
				If !_oGetDados:aCols[_nI,nPosDel]

					ZB9->ZB9_CLVL    := _oGetDados:aCols[_nI,mCLVL]
					ZB9->ZB9_DIGIT   := _oGetDados:aCols[_nI,mDIGIT]
					ZB9->ZB9_VISUAL  := _oGetDados:aCols[_nI,mVISUAL]

				Else

					ZB9->(DbDelete())

				EndIf

				ZB9->(MsUnlock())

			Else

				If !_oGetDados:aCols[_nI,nPosDel]

					Reclock("ZB9",.T.)
					ZB9->ZB9_FILIAL  := xFilial("ZB9")
					ZB9->ZB9_VERSAO  := _cVersao
					ZB9->ZB9_REVISA  := _cRevisa
					ZB9->ZB9_ANOREF  := _cAnoRef
					ZB9->ZB9_USER    := _cCodUser
					ZB9->ZB9_CLVL    := _oGetDados:aCols[_nI,mCLVL]
					ZB9->ZB9_DIGIT   := _oGetDados:aCols[_nI,mDIGIT]
					ZB9->ZB9_VISUAL  := _oGetDados:aCols[_nI,mVISUAL]
					ZB9->ZB9_TPORCT  := Alltrim(_cComboBox1)
					ZB9->(MsUnlock())

				EndIf

			EndIf

		Next

	EndIf

	_cVersao        := SPACE(TAMSX3("ZB9_VERSAO")[1])
	_cRevisa        := SPACE(TAMSX3("ZB9_REVISA")[1])
	_cAnoRef        := SPACE(TAMSX3("ZB9_ANOREF")[1])
	_cCodUser       := SPACE(TAMSX3("ZB9_USER")[1])
	_mNomeUsr       := SPACE(50)
	_cComboBox1		:=	""
	_oGetDados:aCols	:=	aClone(_aColsBkp)
	_oGVersao:SetFocus()
	_oGVersao:Refresh()
	_oGetDados:Refresh()
	_oDlg:Refresh()

	MsgInfo("Registro Inclu�do com Sucesso!")

Return

User Function B389FOK()

	Local cMenVar   := ReadVar()
	Local vfArea    := GetArea()
	Local _cAlias
	Local _nAt		:=	_oGetDados:nAt
	Local _nI
	Local _zpCLVL   := ""

	Do Case

		Case Alltrim(cMenVar) == "M->ZB9_CLVL"
		_zpCLVL   := M->ZB9_CLVL
		GdFieldPut("ZB9_DCLVL"   , Posicione("CTH", 1, xFilial("CTH") + _zpCLVL, "CTH_DESC01") , _nAt)

	EndCase

	For _nI	:=	1 to Len(_oGetDados:aCols)

		If _nI <> _nAt .and. !GDdeleted(_nI)

			If !Empty(_zpCLVL) .and. _zpCLVL == GdFieldGet("ZB9_CLVL",_nI)

				MsgInfo("N�o poder� haver a mesma Classe Valor informada mais de uma vez na lista. Na linha: " + Alltrim(Str(_nI)) + " j� existe a classe valor informada!!!")
				Return .F.

			EndIf

		EndIf

	Next

Return .T.

User Function B389DOK()

	Local _lRet	:=	.T.

	// Incluir neste ponto o controle de dele��o para os casos em que j� existir registro de or�amento associado, ser� necess�rio primeiro retirar de l�

Return _lRet

/*___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun�ao    � B389CLVL � Autor � Marcos Alberto S      � Data � 27/09/18 ���
��+----------+------------------------------------------------------------���
���Descri��o � Replicando CLVL para usu�rio                               ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function B389CLVL()

	Local M002        := GetNextAlias()
	Local _axColsBkp  := aClone(_oGetDados:aCols)

	If !_msCtrlAlt

		MsgInfo("N�o � permitido importar dados porque a Vers�o or�ament�ria est� bloquada.")
		Return

	EndIf

	If _cComboBox1 == "RH" 

		BeginSql Alias M002
			SELECT DISTINCT RA_YCLVL CLVL
			FROM %TABLE:SRA% SRA
			WHERE SRA.RA_MAT < '2'
			AND SRA.RA_SITFOLH <> 'D'
			AND SRA.RA_YCLVL <> '         '
			AND SRA.%NotDel%
			ORDER BY SRA.RA_YCLVL
		EndSql

	Else

		BeginSql Alias M002

			SELECT CTH.CTH_CLVL CLVL
			FROM %TABLE:CTH% CTH
			WHERE CTH.D_E_L_E_T_ = ' '
			AND CTH_BLOQ <> '1'
			ORDER BY CTH_CLVL

		EndSql

	EndIf

	If (M002)->(!Eof())

		While (M002)->(!Eof())

			xkPosCampo := aScan(_oGetDados:aCols,{|x| AllTrim(x[1]) == Alltrim((M002)->CLVL) })
			If xkPosCampo == 0
				(M002)->(aAdd(_oGetDados:aCols,{CLVL,;
				Posicione("CTH", 1, xFilial("CTH") + CLVL, "CTH_DESC01"),;
				"2",;
				"1",;
				"ZB9",	;
				0,;
				.F.	}))
			EndIf

			(M002)->(dbSkip())

		EndDo

	Else

		_oGetDados:aCols	:=	aClone(_axColsBkp)

	EndIf	

	(M002)->(dbCloseArea())
	_oGetDados:Refresh()

Return


User Function B389TPOR()

	If !Empty(_cVersao) .And. !Empty(_cRevisa) .And. !Empty(_cAnoRef) .And. !Empty(_cComboBox1) .And. !Empty(_cCodUser)
		If !ValidPerg()
			Return
		EndIf

		fCopyTpOrc()
	Else
		MsgInfo("Todos os campos do cabe�alho devem estar devidamente preenchidos para realizar a c�pia!")
	EndIf


Return

Static Function ValidPerg()

	local cLoad	    := "BIA389" + cEmpAnt
	local cFileName := RetCodUsr() +"_"+ cLoad
	local lRet		:= .F.
	local aOpcs 	:= {}
	Local aPergs	:=	{}
	Local _nI

	For _nI	:=	1 To Len(_ItCombBox)

		If !Empty(_ItCombBox[_nI]) .And. _ItCombBox[_nI] <> _cComboBox1

			aAdd(aOpcs,_ItCombBox[_nI])

		EndIf

	Next

	MV_PAR01 := aOpcs[1]

	aAdd( aPergs ,{2,"Tipo Orc. Destino " 	,MV_PAR01 ,aOpcs,60,'.T.',.F.})



	If ParamBox(aPergs ,"Copiar tipo de or�amento",,,,,,,,cLoad,.T.,.T.)

		lRet := .T.
		MV_PAR01 := ParamLoad(cFileName,,1,MV_PAR01) 

	EndIf

Return lRet

Static Function fCopyTpOrc()

	Local _cAlias	:=	GetNextAlias()
	Local _cTpOrc	:=	Alltrim(_cComboBox1)

	xfMensCompl := ""
	xfMensCompl += "Tipo Or�amento igual " + MV_PAR01 + msrhEnter
	xfMensCompl += "Status igual Aberto" + msrhEnter
	xfMensCompl += "Data Digita��o igual a branco" + msrhEnter
	xfMensCompl += "Data Concilia��o igual a branco" + msrhEnter
	xfMensCompl += "Data Encerramento igual a branco" + msrhEnter


	BeginSql Alias _cAlias

		SELECT COUNT(*) CONTAD
		FROM %TABLE:ZB5% ZB5
		WHERE ZB5_FILIAL = %xFilial:ZB5%
		AND ZB5.ZB5_VERSAO = %Exp:_cVersao%
		AND ZB5.ZB5_REVISA = %Exp:_cRevisa%
		AND ZB5.ZB5_ANOREF = %Exp:_cAnoRef%
		AND RTRIM(ZB5.ZB5_TPORCT) = %Exp:MV_PAR01%
		AND ZB5.ZB5_STATUS = 'A'
		AND ZB5.ZB5_DTDIGT = ''
		AND ZB5.ZB5_DTCONS = ''
		AND ZB5.ZB5_DTENCR = ''
		AND ZB5.%NotDel%

	EndSql

	If (_cAlias)->CONTAD <> 1
		MsgALERT("A vers�o que receber� a c�pia n�o est� ativa para execu��o deste processo." + msrhEnter + msrhEnter + "Favor verificar o preenchimento dos campos na tabela de controle de vers�o conforme abaixo:" + msrhEnter + msrhEnter + xfMensCompl + msrhEnter + msrhEnter + "Favor verificar com o respons�vel pelo processo Or�ament�rio!!!")	
		(_cAlias)->(DbCloseArea())
		Return
	EndIf

	(_cAlias)->(DbCloseArea())

	_cAlias	:=	GetNextAlias()

	BeginSql Alias _cAlias

		SELECT ZB9.*, ISNULL(ZB9P.R_E_C_N_O_,0) REC
		FROM %TABLE:ZB9% ZB9
		LEFT JOIN %TABLE:ZB9% ZB9P ON ZB9.ZB9_FILIAL = ZB9P.ZB9_FILIAL
		AND ZB9.ZB9_VERSAO = ZB9P.ZB9_VERSAO
		AND ZB9.ZB9_REVISA = ZB9P.ZB9_REVISA
		AND ZB9.ZB9_ANOREF = ZB9P.ZB9_ANOREF
		AND ZB9.ZB9_USER = ZB9P.ZB9_USER
		AND ZB9.ZB9_CLVL = ZB9P.ZB9_CLVL
		AND ZB9P.ZB9_TPORCT = %Exp:MV_PAR01%
		AND ZB9P.%NotDel%
		WHERE ZB9.ZB9_FILIAL = %xFilial:ZB9%
		AND ZB9.ZB9_VERSAO = %Exp:_cVersao%
		AND ZB9.ZB9_REVISA = %Exp:_cRevisa%
		AND ZB9.ZB9_ANOREF = %Exp:_cAnoRef%
		AND ZB9.ZB9_USER = %Exp:_cCodUser%
		AND ZB9.ZB9_TPORCT = %Exp:_cTpOrc%
		AND ZB9.%NotDel%

	EndSql

	If (_cAlias)->(!EOF())

		While (_cAlias)->(!EOF())

			If (_cAlias)->REC <> 0
				ZB9->(DbGoTo((_cAlias)->REC))
				Reclock("ZB9",.F.)
			Else
				Reclock("ZB9",.T.)
				ZB9->ZB9_FILIAL	:=	xFilial("ZB9")
			EndIf

			ZB9->ZB9_VERSAO  := _cVersao
			ZB9->ZB9_REVISA  := _cRevisa
			ZB9->ZB9_ANOREF  := _cAnoRef
			ZB9->ZB9_USER    := _cCodUser
			ZB9->ZB9_CLVL    := (_cAlias)->ZB9_CLVL 
			ZB9->ZB9_DIGIT   := (_cAlias)->ZB9_DIGIT
			ZB9->ZB9_VISUAL  := (_cAlias)->ZB9_VISUAL
			ZB9->ZB9_TPORCT  := %Exp:MV_PAR01%

			ZB9->(MsUnlock())
			(_cAlias)->(DbSkip())
		EndDo
		MsgInfo("C�pia Realizada com Sucesso!")
	Else
		MsgInfo("N�o h� registros a serem copiados!")
	EndIf

	(_cAlias)->(DbCloseArea())
Return