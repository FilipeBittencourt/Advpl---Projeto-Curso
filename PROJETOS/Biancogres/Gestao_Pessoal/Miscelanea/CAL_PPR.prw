#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

USER FUNCTION CAL_PPR()

	/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
	北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
	北矲UNCAO    � CAL_PPR    � AUTOR � MADALENO              � DATA � 05/01/09 潮�
	北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
	北矰ESCRI噭O � CALCULA A PPR PARA OS FUNCIONARIOS                           潮�
	北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
	北� USO      � PROTHEUS R4                                                  潮�
	北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

	Local I

	Private CVERBA 			:= "202"
	Private CVRBCPL 		:= "X22"
	Private NVAL 			:= 0
	Private MES_CORRENTE	:= Substr(dtos(dDataBase),5,2)
	Private ANOMES_CORRENTE	:= Substr(dtos(dDataBase),1,6)
	Private PRIM_DIA_MES	:= ""
	Private MES_ANO_CORRENT := ""

	Private INSALUBRI		:= 0
	Private PERICULOSI		:= 0
	Private NSALARIO  		:= 0

	/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
	Somente para c醠culo de folha e rescis鉶                                                      北
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
	If Upper(Alltrim(FunName())) <> "GPEM020" .and. Upper(Alltrim(FunName())) <> "GPEM040"
		Return
	EndIf

	/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
	Somente para c醠culo da folha e nos meses de Janeiro e Julho                                  北
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
	If Upper(Alltrim(FunName())) == "GPEM020" .and. MES_CORRENTE <> "01" .and. MES_CORRENTE <> "07"
		Return
	EndIf

	/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
	Verifica se est� na rotina de rescis鉶 e se percente ao um grupo de tipos de rescis鉶         北
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
	If Upper(Alltrim(FunName())) == "GPEM040"
		//	If CTIPRES <> "01" .and. CTIPRES <> "07" .and. CTIPRES <> "13" .and. CTIPRES <> "06" .and. CTIPRES <> "02"  .and. CTIPRES <> "11"
		If !CTIPRES $("01*07*13*06*02") //2013.12.02 - RETIRADO OS TIPOS 07 e 11
			Return
		EndIf
	EndIf

	/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
	Somente funcion醨ios mensalistas tem direito ao benef韈io                                     北
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
	If CTIPRES = "06" .OR. CTIPRES = "02"
		If MES_CORRENTE <> "01" .and. MES_CORRENTE <> "07"
			Return
		EndIf
	EndIf

	/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
	Somente funcion醨ios mensalistas tem direito ao benef韈io                                     北
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
	If !(SRA->RA_CATFUNC == "M" .and. SRA->RA_CATEG <> "07" .and. SRA->RA_SITFOLH <> "D")
		Return
	EndIf

	/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
	// Tratamento para Excluir alguns PCD's                                                       北
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
	If cEmpAnt == "01" .and. SRA->RA_MAT $ ("001342/001343/001490/001532")
		Return
	EndIf

	If cEmpAnt == "05" .and. SRA->RA_MAT $ ("000596/000602/000607/000608")
		Return
	EndIf



	/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
	Busca Valor do Sal醨io M韓imo e calcula Insalubridade                                         北
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
	CSQL	:= " SELECT RX_TXT
	CSQL	+= "   FROM " + RetSqlName("SRX")
	CSQL	+= "  WHERE RX_TIP = '11'
	CSQL	+= "    AND RX_COD = '        '
	CSQL	+= "    AND D_E_L_E_T_ = ' '
	IF ChkFile("_INSAL")
		dbSelectArea("_INSAL")
		dbCloseArea("_INSAL")
	EndIf
	TCQUERY CSQL ALIAS "_INSAL" NEW
	If _INSAL->(Eof())
		INSALUBRI := 0
	Else
		If SRA->RA_INSMED <> 0
			INSALUBRI := ((Val(Alltrim(_INSAL->RX_TXT) ) / 100) * 20)
		ElseIf SRA->RA_INSMAX <> 0
			INSALUBRI := ((Val(Alltrim(_INSAL->RX_TXT) ) / 100) * 40)
		Else
			INSALUBRI := 0
		EndIf
	EndIf

	/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
	Verifica se est� na rotina de folha de pagamento                                              北
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
	If Upper(Alltrim(FunName())) = "GPEM020"
		DE	:= IIF(MES_CORRENTE == "01",  7, 1)
		ATE	:= IIF(MES_CORRENTE == "01", 12, 6)
	Else
		DE	:= IIF(MES_CORRENTE < "08" .and. MES_CORRENTE <> "01", 1, 7)
		ATE	:= Val(Substr(dtos(ddataBase), 5, 2))
		ATE := IIF(ATE == 1, 12, ATE-1)
	EndIf

	For I := DE to ATE

		If MES_CORRENTE = "01"
			PRIM_DIA_MES	:= Substr(dtos(dDataBase-60),1,4) + IIF(Len(Alltrim(Str(I))) == 1, "0"+Alltrim(Str(I)),  Alltrim(Str(I)) ) + "01"
			MES_ANO_CORRENT	:= Substr(dtos(dDataBase-60),1,4) + IIF(Len(Alltrim(Str(I))) == 1, "0"+Alltrim(Str(I)),  Alltrim(Str(I)) )
		Else
			PRIM_DIA_MES	:= Substr(dtos(dDataBase),1,4) + IIF(Len(Alltrim(Str(I))) == 1, "0"+Alltrim(Str(I)),  Alltrim(Str(I)) ) + "01"
			MES_ANO_CORRENT	:= Substr(dtos(dDataBase),1,4) + IIF(Len(Alltrim(Str(I))) == 1, "0"+Alltrim(Str(I)),  Alltrim(Str(I)) )
		EndIf

		/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
		北 VERIFICANDO SE O FUNCIONARIO ENTROU NA EMPRESA ESSE MES PARA NAO CALCULAR                  北
		北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
		If Substr(dtos(SRA->RA_ADMISSA),1,6) >= MES_ANO_CORRENT
			Loop
		EndIf

		/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
		北 VERIFICANDO SE O FUNCIONARIO FOI DEMITIDO (ELE PEDIU DEMISSAO) NO MES PARA NAO CALCULAR    北
		北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
		If Substr(dtos(SRA->RA_DEMISSA),1,6) == MES_ANO_CORRENT .and. SRA->RA_AFASFGT = "J"
			Loop
		EndIf

		/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
		北 VERIFICANDO SE A EMPRESA FEZ A DISPENSA DO COLABORADOR         NO MES PARA NAO CALCULAR    北
		北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
		北北北北北北北北北北北北北北北北北北*/
		If Substr(dtos(SRA->RA_DEMISSA),1,6) == MES_ANO_CORRENT .and. SRA->RA_AFASFGT <> "J"
			NVAL := 0
			Loop
		EndIf

		/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
		北 Verifica se o funcion醨io esta afastado no per韔do                                         北
		北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
		CSQL	:= " SELECT COUNT(*) CONTAD
		CSQL	+= "   FROM "+RetSqlName("SR8")+" SR8
		CSQL	+= "  WHERE R8_MAT = '"+SRA->RA_MAT+"'
		CSQL	+= "    AND R8_TIPO <> 'F'
		CSQL	+= "    AND (DATEDIFF(D, '"+PRIM_DIA_MES+"', R8_DATAFIM) >= 15 OR DATEDIFF(D, '"+PRIM_DIA_MES+"', R8_DATAFIM) < 0)
		CSQL	+= "    AND '"+MES_ANO_CORRENT+"' >= SUBSTRING(R8_DATAINI,1,6)
		CSQL	+= "    AND ('"+MES_ANO_CORRENT+"' <= SUBSTRING(R8_DATAFIM,1,6) OR R8_DATAFIM = '        ')
		CSQL	+= "    AND ((DATEDIFF(D, R8_DATAINI, R8_DATAFIM)+1) >= 15 OR DATEDIFF(D, R8_DATAINI, R8_DATAFIM) < 0 )
		CSQL	+= "    AND (DATEDIFF(D, R8_DATAINI,'"+ dtos(U_ULTDIAM(stod(PRIM_DIA_MES))) + "')+1) >= 15
		CSQL	+= "    AND SR8.D_E_L_E_T_ = ' '
		If ChkFile("_AFAST")
			dbSelectArea("_AFAST")
			dbCloseArea("_AFAST")
		EndIf
		TCQUERY CSQL ALIAS "_AFAST" NEW
		dbSelectarea("_AFAST")
		dbGotop()
		If _AFAST->(EOF()) .or. _AFAST->CONTAD > 0
			Loop
		EndIf

		/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
		北 Sal醨io Base Atual                                                                         北
		北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
		CSQL	:= " SELECT ISNULL(MAX(R3_VALOR),0) R3_VALOR
		CSQL	+= "   FROM " + RetSqlName("SR3")
		CSQL	+= "  WHERE R3_MAT = '"+SRA->RA_MAT+"'
		CSQL	+= "    AND R3_DATA <= '"+Substr(dtos(ddataBase),1,6)+"'
		CSQL	+= "    AND R3_PD = '000'
		CSQL	+= "    AND D_E_L_E_T_ = ' '
		If ChkFile("_SAL")
			dbSelectArea("_SAL")
			dbCloseArea("_SAL")
		EndIf
		TCQUERY CSQL ALIAS "_SAL" NEW
		If _SAL->(EOF()) .or. _SAL->R3_VALOR == 0
			NSALARIO := SRA->RA_SALARIO
		Else
			NSALARIO := _SAL->R3_VALOR
		EndIf

		/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
		北 Calcula Periculosidade                                                                     北
		北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
		If SRA->RA_PERICUL <> 0
			PERICULOSI := (NSALARIO / 100 ) * 30
		EndIf

		/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
		北 Busca Indices do PPR                                                                       北
		北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北*/
		CSQL    := " SELECT DISTINCT RA_MAT,
		CSQL    += "        ISNULL(RD_CLVL, RA_CLVL) RA_CLVL,
		CSQL    += "        CTT_YCAPPR,
		CSQL    += "        ZZF_INDICE
		CSQL    += "   FROM " + RetSqlName("SRA") + " SRA
		CSQL    += "  LEFT OUTER JOIN " + RetSqlName("SRD") + " SRD ON RD_MAT = RA_MAT
		CSQL    += "                       AND RD_DATARQ = '"+MES_ANO_CORRENT+"'
		CSQL    += "                       AND SRD.D_E_L_E_T_ = ' '
		CSQL    += "  INNER JOIN " + RetSqlName("CTH") + " CTH ON CTH_CLVL = ISNULL(RD_CLVL, RA_CLVL)
		CSQL    += "                       AND CTT.D_E_L_E_T_ = ' '
		CSQL    += "  INNER JOIN " + RetSqlName("ZZF") + " ZZF ON ZZF.ZZF_CATPPR = CTT.CTT_YCAPPR
		CSQL    += "                       AND ZZF.ZZF_MESANO = '"+MES_ANO_CORRENT+"'
		CSQL    += "                       AND ZZF.D_E_L_E_T_ = ' '
		CSQL    += "  WHERE RA_MAT = '"+SRA->RA_MAT+"'
		CSQL    += "    AND SRA.D_E_L_E_T_ = ' '

		If ChkFile("_PPR")
			dbSelectArea("_PPR")
			dbCloseArea("_PPR")
		EndIf
		TCQUERY CSQL ALIAS "_PPR" NEW

		If _PPR->(Eof())
			MSGBOX("N鉶 existe indice do PPR para o classe de valor: " + SRA->RA_CLVL + " no m阺: " + MES_ANO_CORRENT)
			Return(.F.)
		Else
			NVAL += ((( NSALARIO  + INSALUBRI + PERICULOSI ) / 100) * _PPR->ZZF_INDICE)
		EndIf

	Next

	If NVAL <> 0

		//Local _cVerba 	:= "X22" 				//Verba do Acumulado
		_dDtIniX := CtoD("01/01/2014") 	//Data Inicial
		_dDtFimX := CtoD("31/12/2014") 	//Data Final
		_cTipo 	 := "V" 					//Tipo Verba
		_nValX22 := 0

		_nValX22 := fBuscaAcm(CVRBCPL,,_dDtIniX,_dDtFimX,"V")

		If NVAL <> 0 .and. AllTrim(SRA->RA_CLVL) $ ("1000/1003/4000/4050/4080/5000")
			fGeraVerba(CVERBA,NVAL,,,,,,,,,)
		Else
			fGeraVerba(CVERBA,(NVAL - _nValX22),,,,,,,,,)
		EndIf

		// Tratamento da Antecipa鏰o de PPR
		nPercAnt := 0
		If AllTrim(SRA->RA_CLVL) $ ("3100/3110/3130/3135/3136/3190/3191/3193/3500")
			nPercAnt := 0.09
		ElseIf AllTrim(SRA->RA_CLVL) $ ("1000/1003/4000/4050/4080")
			nPercAnt := 0.05
		ElseIf AllTrim(SRA->RA_CLVL) $ ("2100/2111/2115/2116/2120")
			nPercAnt := 0.065
		EndIf

		// Gerar Complemento
		If ANOMES_CORRENTE == "201407"
			If cEmpAnt == "01"  .and. !SRA->RA_MAT $ ("001009/001125/001180/001225/001367/001412/001423") // Tratamento para retirar alguns Afastados
				fGeraVerba(CVRBCPL,( NSALARIO  + INSALUBRI + PERICULOSI ) * nPercAnt,(nPercAnt*100),,,,,,,,)
			EndIf
		EndIf

	EndIf

Return
