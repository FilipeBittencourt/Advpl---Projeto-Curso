#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} TAFWorkFlowProcess
@author Tiago Rossini Coradini
@since 30/10/2018
@project Automa��o Financeira
@version 1.0
@description Classe para tratamento de processos de workflow
@type class
/*/

Class TAFWorkFlowProcess From TAFWorkFlow
	
	Data aTables	as array
	
	Data bGetSQL 	as block
	Data bSetField	as block
	Data bFieldFil	as block
	Data bSX2Alias	as block

	Data cSX2Alias	as character
	Data cFieldFil	as character
		
	Data lAviso		as logical

	Method New() Constructor
	Method Get()
	Method Set(cTab, cFil, cID)
	Method SetProperty(cID)
	Method SetField(cTab, cFil, cID)
	Method AddField(cField)
	Method AddUserField(cField, cTitulo, cTipo, cPict, nWidth,lUserField)
	Method FormatField(cType, cPict, uValue)
	Method GetSQL(cTab, cFil, cID)
	Method GetDscType(cType)
	Method GetMethod(cID)
	Method Send()
	Method Validate()
	Method setTable(cRealTable,cTab,cID,cFil,cIDProc)

EndClass


Method New() Class TAFWorkFlowProcess

	_Super:New()
	
	::lAviso:=.F.
	::aTables:=array(0)
	
Return()


Method Get() Class TAFWorkFlowProcess
	
	Local cSQL := ""
	Local cQry := GetNextAlias()
	
	Local cID
	Local cFil
	Local cTab

	cSQL := " SELECT ZK2_TABELA, ZK2_FIL, ZK2_METODO "
	cSQL += " FROM "+ RetSQLName("ZK2")
	cSQL += " WHERE ZK2_IDPROC = " + ValToSQL(::cIDProc)
	cSQL += " AND ZK2_ENVWF = 'S' "
	cSQL += " AND D_E_L_E_T_ = '' "
	cSQL += " GROUP BY ZK2_TABELA, ZK2_FIL, ZK2_METODO "

	TCQUERY (cSQL) ALIAS (cQry) NEW

	While (cQry)->(!Eof())

		cID:=AllTrim((cQry)->ZK2_METODO)
		cTab:=AllTrim((cQry)->ZK2_TABELA)
		
		cFil:=(cQry)->ZK2_FIL

		cTab:=::setTable(cTab,cTab,cID,cFil,::cIDProc)

		If ::Set(cTab,cFil,cID)
			
			If ::Validate()
			
				_Super:Send()
				
			EndIf
	
		EndIf

		(cQry)->(DbSkip())

	EndDo()

	(cQry)->(DbCloseArea())

Return()


Method Set(cTab, cFil, cID) Class TAFWorkFlowProcess
	
	Local aFields	as array

	Local cSQL		as character
	Local cQry		as character
	
	local cFPict	as character
	Local cFType	as character
	Local cFName	as character

	Local lRet		as logical

	Local nFPos		as numeric
	Local nField	as numeric
	Local nFields	as numeric

	Local uFGet

	lRet := .F.

	::SetProperty(cID)

	DEFAULT ::bSetField:={|cTab,cFil,cID|::SetField(@cTab,@cFil,@cID)}
	
	If (eval(::bSetField,@cTab,@cFil,@cID))
		
		DEFAULT ::bGetSQL:={|cTab,cFil,cID|::GetSQL(@cTab,@cFil,@cID)}
		
		cSQL := eval(::bGetSQL,@cTab,@cFil,@cID)

		cQry := GetNextAlias()
		TCQUERY (cSQL) ALIAS (cQry) NEW

		lRet := (cQry)->(!Eof())

		if (lRet)

			nFields:=::oLst:GetCount()

			lRet:=(nFields>0)

			if (lRet)
				
				aFields:=Array(nFields,4)
				For nField := 1 To nFields
					cFName:=::oLst:GetItem(nField):cName
					aFields[nField][1]:=cFName
					aFields[nField][2]:=(cQry)->(FieldPos(cFName))
					aFields[nField][3]:=::oLst:GetItem(nField):cPict
					aFields[nField][4]:=::oLst:GetItem(nField):cType
				next nField
				
				While (cQry)->(!Eof())

					For nField := 1 To nFields

						cFName:=aFields[nField][1]
						nFPos:=aFields[nField][2]
						
						if (nFPos>0)
							cFPict:=aFields[nField][3]
							cFType:=aFields[nField][4]
							uFGet:=(cQry)->(FieldGet(nFPos))
							uFGet:=::FormatField(cFType,cFPict,uFGet)
							::oLst:GetItem(nField):oRow:Add(uFGet)
						endif

					Next nField

					(cQry)->(DbSkip())

				EndDo()

			endif

		endif

		(cQry)->(DbCloseArea())

	EndIf
		
Return(lRet)


Method SetProperty(cID) Class TAFWorkFlowProcess
	
	Local cSQL := ""
	Local cQry := GetNextAlias()

	cSQL := " SELECT TOP 1 ZK2_DTINI, ZK2_HRINI, ZK2_OPERAC, ZK2_EMP, ZK2_FIL "
	cSQL += " FROM "+ RetSQLName("ZK2")
	cSQL += " WHERE ZK2_IDPROC = " + ValToSQL(::cIDProc)
	cSQL += " AND ZK2_METODO = " + ValToSQL(cID)
	cSQL += " AND D_E_L_E_T_ = '' "
	cSQL += " ORDER BY ZK2_DTINI, ZK2_HRINI "

	TCQUERY (cSQL) ALIAS (cQry) NEW

	If !Empty((cQry)->ZK2_OPERAC)

		::cTo := U_EmailWF(cID, (cQry)->ZK2_EMP)
		::cDate := dToC(sToD((cQry)->ZK2_DTINI))
		::cTime := (cQry)->ZK2_HRINI
		::cType := AllTrim((cQry)->ZK2_OPERAC)
		::cDscType := AllTrim(::GetDscType(AllTrim((cQry)->ZK2_OPERAC)))
		::cMethod := ::GetMethod(cID)
		::cEmp := Capital(AllTrim(FWEmpName((cQry)->ZK2_EMP)))
		::cFil := Capital(AllTrim(FWFilialName((cQry)->ZK2_EMP, (cQry)->ZK2_FIL)))
		::cSubject := "Automa��o Financeira - " + ::cMethod

	EndIf
	
	Return()


Method SetField(cTab, cFil, cID) Class TAFWorkFlowProcess
	
	Local lRet := .T.

	::oLst:Clear()
	
	If ::lAviso
		
		::AddField("ZK2_RETMEN")
		
	Else
	
		If ::cType == "R" // RECEBER
	
			If cID == "CR_S_BOR" .Or. cID == "CR_RET_ER" .Or. cID == "CR_DESC" .Or. cID == "CR_TIT_INC" .Or. cID == "CR_NVG_RCB" .Or. cID == "CR_NVR_RCB" .Or. cID == "CR_RET_ARQ" .Or. cID == "DEP_BAI_TIT" .Or. cID == "CR_FAT_INTER"
	
				::AddField("E1_VENCREA")
				::AddField("E1_CLIENTE")
				::AddField("E1_LOJA")
				::AddField("E1_NOMCLI")
				::AddField("E1_PREFIXO")
				::AddField("E1_NUM")
				::AddField("E1_PARCELA")
				::AddField("E1_TIPO")
				::AddField("E1_VALOR")
				::AddField("E1_SALDO")
				::AddField("E1_NUMBOR")
				::AddField("E1_NUMBCO")

				::AddUserField("RETMEN", "Mensagem", "C", "@!", 100)
						
			EndIf
		
			If cID == "CR_BAI_TIT"
		
				::AddField("ZK4_DATA")
				::AddField("ZK4_EMP")
				::AddField("ZK4_FIL")
				::AddField("ZK4_BANCO")
				::AddField("ZK4_AGENCI")
				::AddField("ZK4_CONTA")
				::AddField("ZK4_NUMERO")
				::AddField("ZK4_ESPECI")
				::AddField("ZK4_NOSNUM")
				::AddField("ZK4_VLORI")
				::AddField("ZK4_VLREC")
				::AddField("ZK4_CODOCO")
				::AddField("ZK4_CODREJ")
				::AddField("ZK4_FILE")
				::AddField("ZK4_IDPROC")
			
				::AddUserField("RETMEN", "Mensagem", "C", "@!", 100)
		
			EndIf
		
			If cID == "CR_DEP_IDE"
			
				::AddField("ZK8_NUMERO")
				::AddField("ZK8_GRPVEN")
				::AddField("ZK8_CODCLI")
				::AddField("ZK8_VENCDE")
				::AddField("ZK8_VENCAT")
				::AddField("ZK8_DATDPI")
				::AddField("ZK8_BANCO")
				::AddField("ZK8_AGENCI")
				::AddField("ZK8_CONTA")
  			
				::AddUserField("RETMEN", "Mensagem", "C", "@!", 100)
		
			EndIf
			
		EndIf
					
		If ::cType == "P" // PAGAR
		
			If cID == "CP_S_BOR" .Or. cID == "CP_RET_ER" .Or. cID == "CP_DESC" .Or. cID == "CP_TIT_INC" .Or. cID == "CP_NVG_RCB" .Or. cID == "CP_NVR_RCB" .Or. cID == "CP_RET_ARQ" .Or. cID == "S_CON_DDA" .Or. cID == "CP_FAT_INTER"
		
				::AddField("E2_VENCREA")
				::AddField("E2_FORNECE")
				::AddField("E2_LOJA")
				::AddField("E2_NOMFOR")
				::AddField("E2_PREFIXO")
				::AddField("E2_NUM")
				::AddField("E2_PARCELA")
				::AddField("E2_TIPO")
				::AddField("E2_NUMBOR")
				::AddField("E2_VALOR")
				::AddField("E2_SALDO")
		
				::AddUserField("RETMEN", "Mensagem", "C", "@!", 100)
		
			EndIf
		
			If cID == "CP_CNAB"
		
				::AddField("ZK3_FIL")
				::AddField("ZK3_EMP")
				::AddField("ZK3_DATA")
				::AddField("ZK3_BORDE")
				::AddField("ZK3_BORATE")
				::AddField("ZK3_BANCO")
				::AddField("ZK3_AGENCI")
				::AddField("ZK3_CONTA")
				::AddField("ZK3_SUBCTA")
				::AddField("ZK3_LAYOUT")
				::AddField("ZK3_ARQCFG")
				::AddField("ZK3_ARQUSE")
				::AddField("ZK3_MSGCNA")
				
			EndIf

			If cID == "S_RET_TIT_DDA" .Or. cID == "FOR_RET_TIT_DDA" .Or. cID == "N_CON_DDA_FIN"

				::AddField("FIG_VENCTO")
				::AddField("FIG_FORNEC")
				::AddField("FIG_LOJA")
				::AddField("FIG_NOMFOR")
				::AddField("FIG_CNPJ")
				::AddField("FIG_TITULO")
				::AddField("FIG_TIPO")
				::AddField("FIG_VALOR")
				::AddField("FIG_DATA")
				::AddField("FIG_CODBAR")
				
			EndIf
		
			If cID == "CP_BAI_TIT"
		
				::AddField("ZK4_DTLIQ")
				::AddField("ZK4_EMP")
				::AddField("ZK4_FIL")
				::AddField("ZK4_BANCO")
				::AddField("ZK4_AGENCI")
				::AddField("ZK4_CONTA")
				::AddField("ZK4_VLPAG")
				::AddField("ZK4_FNOME")
				::AddField("ZK4_IDCNAB")
				::AddField("ZK4_OCORET")
  			
				::AddUserField("RETMEN", "Mensagem", "C", "@!", 100)
		
			EndIf

			If cID == "CP_BAI_TIT_GNRE"
		
				::AddField("ZK4_DTLIQ")
				::AddField("ZK4_EMP")
				::AddField("ZK4_FIL")
				::AddField("ZK4_BANCO")
				::AddField("ZK4_AGENCI")
				::AddField("ZK4_CONTA")
				::AddField("ZK4_VLORI")
				::AddField("ZK4_CODBAR")
				::AddField("ZK4_IDCNAB")
				::AddField("ZK4_IDGUIA")
				::AddUserField("RETMEN", "Mensagem", "C", "@!", 100)
		
			EndIf
				
		EndIf
	
	EndIf

	lRet := ::oLst:GetCount() > 0

Return(lRet)


Method AddField(cField) Class TAFWorkFlowProcess

	local cTipo
	local cTitulo
	local cPicture

	local nTamanho
	local nDecimal

	local oField

	cTipo:=getSX3Cache(cField,"X3_TIPO")
	
	If (!empty(cTipo))

		cTitulo:=allTrim(getSX3Cache(cField,"X3_TITULO"))
		cPicture:=allTrim(getSX3Cache(cField,"X3_PICTURE"))
		nTamanho:=getSX3Cache(cField,"X3_TAMANHO")
		nDecimal:=getSX3Cache(cField,"X3_DECIMAL")

		oField:=TWorkFlowField():New()
		oField:cName:=cField
		oField:cType:=cTipo
		oField:cPict:=cPicture
		oField:cTitle:=cTitulo
		oField:nWidth:=CalcFieldSize(cTipo,nTamanho,nDecimal,cPicture,cTitulo)
		
		::oLst:Add(oField)

	EndIf

Return()

Method AddUserField(cField, cTitulo, cTipo, cPict, nWidth,lUserField) Class TAFWorkFlowProcess
	
	Local oField := TAFWorkFlowField():New()

	DEFAULT lUserField:=.T.

	oField:cName := cField
	oField:cType := cTipo
	oField:cPict := cPict
	oField:cTitle := cTitulo
	oField:nWidth := nWidth
	oField:lUser := lUserField

	::oLst:Add(oField)

Return()


Method FormatField(cType, cPict, uValue) Class TAFWorkFlowProcess
	Local uRet := Nil

	If cType == "D"

		uRet := dToC(sToD(uValue))

	Else

		uRet := AllTrim(Transform(uValue, cPict))

	EndIf

Return(uRet)


Method GetSQL(cTab, cFil, cID) Class TAFWorkFlowProcess
	
	Local cSQL := ""
	Local cFSelect := ""
	Local cSep := ","
	Local cXFilial
	Local nCount := 0
	
	If ::lAviso
	
		cSQL := " SELECT ZK2_RETMEN "
		cSQL += " FROM " + RetSQLName("ZK2")
		cSQL += " WHERE ZK2_IDPROC = " + ValToSQL(::cIDProc)
		cSQL += " AND ZK2_METODO = " + ValToSQL(cID)
		cSQL += " AND ZK2_ENVWF = 'S' "
		cSQL += " AND D_E_L_E_T_ = '' "
	
	Else

		DEFAULT ::bFieldFil:={|cTab|(PrefixoCpo(SubStr(cTab,1,3))+"_FILIAL")}
		DEFAULT ::bSX2Alias:={|cTab|SubStr(cTab,1,3)}

		::cFieldFil:=eval(::bFieldFil,cTab)
		::cSX2Alias:=eval(::bSX2Alias,cTab)

		cXFilial:=xFilial(::cSX2Alias,cFil)

		For nCount := 1 To ::oLst:GetCount()
	
			If (!::oLst:GetItem(nCount):lUser)
	
				If !Empty(cFSelect)
					cFSelect += cSep
				EndIf
	
				cFSelect += ::oLst:GetItem(nCount):cName
				
			EndIf
	
		Next nCount
	
		cSQL := " SELECT " + cFSelect + ","
		cSQL += " ISNULL( "
		cSQL += " ( "
		cSQL += " 	SELECT TOP 1 ZK2_RETMEN "
		cSQL += " 	FROM " + RetSQLName("ZK2")
		cSQL += " 	WHERE ZK2_IDPROC = " + ValToSQL(::cIDProc)
		cSQL += " 	AND ZK2_IDTAB = " + cTab + ".R_E_C_N_O_ "
		cSQL += " 	AND ZK2_METODO IN ('CR_RET_ER', 'CP_RET_ER', 'CR_RET_OK', 'CP_RET_OK', 'CR_DESC', 'CP_DESC', 'CR_TIT_INC', "
		cSQL += " 	'CP_TIT_INC', 'CR_S_BOR', 'CP_S_BOR', 'CR_NVR_RCB', 'CR_NVG_RCB', 'CP_NVR_RCB', 'CP_NVG_RCB', 'CR_RET_ARQ', "
		cSQL += " 	'CP_RET_ARQ', 'CR_BAI_TIT', 'CP_BAI_TIT', 'CP_BAI_TIT_GNRE' , 'CR_DEP_IDE', 'DEP_BAI_TIT', 'CP_FAT_INTER', 'CR_FAT_INTER') "
		cSQL += " 	AND D_E_L_E_T_ = '' "
		cSQL += " 	ORDER BY R_E_C_N_O_ DESC "
		cSQL += " ), '') AS RETMEN "
	
		cSQL += "  FROM " + cTab
		cSQL += " WHERE "
		if (!empty(::cFieldFil))
			cSQL += ::cFieldFil + " = " + ValToSQL(cXFilial)
			cSQL += " AND "
		endif
		cSQL += " R_E_C_N_O_ IN "
		cSQL += " ( "
		cSQL += " 	SELECT ZK2_IDTAB "
		cSQL += " 	FROM "+ RetSQLName("ZK2")
		cSQL += " 	WHERE ZK2_IDPROC = " + ValToSQL(::cIDProc)
		cSQL += " 	AND ZK2_METODO = " + ValToSQL(cID)
		cSQL += " 	AND ZK2_ENVWF = 'S' "
		cSQL += " 	AND D_E_L_E_T_ = '' "
		cSQL += "		GROUP BY ZK2_IDTAB "
		cSQL += " )"
	
		// Controle para enviar somente uma vez por dia o mesmo RECNO e mensagem de retorno diferente quando for JOB.
		If ((::cType$"P/R/C").and.(!"##"$cTab).and.(IsBlind()))
		
			cSQL += " AND ( "
			cSQL += " 		NOT EXISTS "
			cSQL += " 		( "
			cSQL += " 			SELECT NULL "
			cSQL += " 			FROM " + RetSQLName("ZK2") + " Y (NOLOCK) "
			cSQL += " 			WHERE "
			cSQL += " 				ZK2_FILIAL 		 = " + ValToSQL(xFilial("ZK2"))
			cSQL += " 				AND ZK2_EMP      = " + ValToSQL(cEmpAnt)
			cSQL += " 				AND ZK2_FIL      = " + ValToSQL(cFilAnt)
			cSQL += " 				AND ZK2_METODO   = " + ValToSQL(cID)
			cSQL += " 				AND ZK2_ENVWF    = 'S' "
			cSQL += " 				AND ZK2_IDTAB    = " + cTab + ".R_E_C_N_O_ "
			cSQL += "				AND ZK2_IDPROC 	 = " + ValToSQL(::cIDProc)
			cSQL += " 				AND EXISTS "
			cSQL += " 				( "
			cSQL += " 					SELECT NULL "
			cSQL += " 					FROM " + RetSQLName("ZK2") + " X (NOLOCK) "
			cSQL += " 					WHERE "
			cSQL += " 						X.ZK2_FILIAL 	 = " + ValToSQL(xFilial("ZK2"))
			cSQL += " 						AND X.ZK2_EMP    = Y.ZK2_EMP "
			cSQL += " 						AND X.ZK2_FIL    = Y.ZK2_FIL "
			cSQL += " 						AND X.ZK2_OPERAC = Y.ZK2_OPERAC "
			cSQL += "						AND X.ZK2_IDPROC <> " + ValToSQL(::cIDProc)
			cSQL += " 						AND X.ZK2_METODO = Y.ZK2_METODO "
			cSQL += " 						AND X.ZK2_ENVWF  = Y.ZK2_ENVWF "
			cSQL += " 						AND X.ZK2_TABELA = Y.ZK2_TABELA "
			cSQL += " 						AND X.ZK2_IDTAB  = Y.ZK2_IDTAB "
			cSQL += " 						AND X.ZK2_RETMEN = Y.ZK2_RETMEN "
			cSQL += " 						AND X.ZK2_DTINI  = Y.ZK2_DTINI "
			cSQL += " 						AND X.D_E_L_E_T_ = '' "
			cSQL += " 				) "
			cSQL += " 				AND Y.ZK2_DTINI  = " + ValToSQL(dDataBase)
			cSQL += " 				AND Y.D_E_L_E_T_ = '' "
			cSQL += " 		) "
			cSQL += " 		OR  "
			cSQL += " 		ISNULL( "
			cSQL += " 				( "
			cSQL += " 					SELECT COUNT(*) "
			cSQL += " 					FROM " + RetSQLName("ZK2") + " Y (NOLOCK) "
			cSQL += " 					WHERE "
			cSQL += " 						Y.ZK2_FILIAL 	   = " + ValToSQL(xFilial("ZK2"))
			cSQL += " 						AND Y.ZK2_EMP      = " + ValToSQL(cEmpAnt)
			cSQL += " 						AND Y.ZK2_FIL      = " + ValToSQL(cFilAnt)
			cSQL += " 						AND Y.ZK2_METODO   = " + ValToSQL(cID)
			cSQL += " 						AND Y.ZK2_ENVWF    = 'S' "
			cSQL += " 						AND Y.ZK2_IDTAB    = " + cTab + ".R_E_C_N_O_ "
			cSQL += " 						AND Y.ZK2_DTINI    = " + ValToSQL(dDataBase)
			cSQL += " 						AND Y.D_E_L_E_T_   = '' "
			cSQL += " 				) "
			cSQL += "		   , 0) = 1 "
			cSQL += " 	) "
	
		EndIf
		
		cSQL += " ORDER BY " + cFSelect
	
	EndIf
	
Return(cSQL)


Method GetDscType(cType) Class TAFWorkFlowProcess
	Local cRet := ""

	If cType == "P"

		cRet := "Contas a Pagar"

	ElseIf cType == "R"

		cRet := "Contas a Receber"

	ElseIf cType == "T"

		cRet := "Tesouraria"

	EndIf

Return(cRet)


Method GetMethod(cID) Class TAFWorkFlowProcess
	Local cRet := ""

	If cID == "CR_S_BOR" .Or. cID == "CP_S_BOR"

		cRet := "T�tulos em Border�"

	ElseIf cId == "CR_RET_ER" .Or. cId == "CP_RET_ER"
	
		cRet := "Erro de Integra��o - [API]"
		
	ElseIf cID == "CR_NVG_RCB" .Or. cID == "CP_NVG_RCB"

		cRet := "Grupo de Regra N�o V�lido"

	ElseIf cID == "CR_NVR_RCB" .Or. cID == "CP_NVR_RCB"

		cRet := "Regra N�o V�lida"
	
	ElseIf cId == "S_RET_TIT_DDA"
	
		cRet := "T�tulos em DDA"
		
	ElseIf cId == "FOR_RET_TIT_DDA"
		
		cRet := "T�tulos em DDA - Sem identifica��o de Fornecedor"
	
	ElseIf cID == "N_CON_DDA_FIN"
	
		cRet := "T�tulos a vencer em DDA - N�o Conciliados"
		
	ElseIf cId == "S_CON_DDA"
		
		cRet := "T�tulos Conciliados via DDA"
		
	ElseIf cId == "CR_DESC" .Or. cId == "CP_DESC"
	
		cRet := "Baixa Tarifa Titulos"

	ElseIf cId == "CR_CNAB" .Or. cId == "CP_CNAB"
	
		cRet := "Gera��o de arquivo CNAB"
		
	ElseIf cId == "CR_TIT_INC" .Or. cId == "CP_TIT_INC"
	
		cRet := "Inconsist�ncia T�tulo"
		
	Elseif cId == "CR_RET_ARQ" .Or. cId == "CP_RET_ARQ"
	
		cRet := "Leitura arquivo retorno banco"
		
	Elseif cId == "CR_BAI_TIT" .Or. cId == "CP_BAI_TIT"
	
		cRet := "Processamento arquivo retorno banco"

	Elseif cId == "CP_BAI_TIT_GNRE"
	
		cRet := "Processamento arquivo retorno banco - GNR-e"

	Elseif cId == "CR_DEP_IDE"
	
		cRet := "Deposito Identificado"

	Elseif cId == "DEP_BAI_TIT"
	
		cRet := "Baixa via Deposito Identificado"

	ElseIf cId == "CP_FAT_INTER" .Or. cId == "CR_FAT_INTER" 

		cRet := "Fatura Intercompany"

	EndIf

Return(cRet)


Method Send() Class TAFWorkFlowProcess

	::Get()

Return()


Method Validate() Class TAFWorkFlowProcess
	Local lRet := .T.
	
	lRet := !Empty(::cTo)

Return(lRet)

Method setTable(cRealTable,cTab,cID,cFil,cIDProc) Class TAFWorkFlowProcess

	local nTab

	cTab:=allTrim(cTab)
	cID:=allTrim(cID)

	nTab:=aScan(::aTables,{|t|((t[1]==cTab).and.(t[2]==cID).and.(t[3]==cFil).and.(t[4]==cIDProc))})
	if (nTab==0)
		aAdd(::aTables,{cTab,cID,cFil,cIDProc,cRealTable})
		nTab:=len(::aTables)
	endif
	cRealTable:=::aTables[nTab][5]

	return(cRealTable)
