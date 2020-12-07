#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} BIA949
@author Marcos Alberto Soprani
@since 30/05/19
@version 1.0
@description Desmonta uma revis�o de vers�o or�ament�ria criada indevidamente  
@type function
/*/

User Function BIA949()

	Local _cAreaAtu   := GetArea()
	Local M001        := GetNextAlias()
	Local _ms

	Private msrhEnter := CHR(13) + CHR(10)

	fPerg := "BIA949"
	fTamX1 := IIF(Alltrim(oApp:cVersion) == "MP8.11", 6, 10)
	fValidPerg()
	If !Pergunte(fPerg,.T.)
		Return
	EndIf

	_cVersao   := MV_PAR01   
	_cRevisa   := MV_PAR02
	_cAnoRef   := MV_PAR03
	_cNewRev   := MV_PAR04

	If Empty(_cVersao) .or. Empty(_cRevisa) .or. Empty(_cAnoRef)
		MsgInfo("Favor verificar o preenchimento dos campos da capa do cadastro!!!")
		Return .F.
	EndIf

	BeginSql Alias M001
		SELECT MAX(ZB5_REVISA) REVATV
		FROM %TABLE:ZB5% ZB5
		WHERE ZB5_FILIAL = %xFilial:ZB5%
		AND ZB5.ZB5_VERSAO = %Exp:_cVersao%
		AND ZB5.ZB5_ANOREF = %Exp:_cAnoRef%
		AND ZB5.%NotDel%
	EndSql

	(M001)->(dbGoTop())
	If (M001)->REVATV <> _cRevisa
		MsgALERT("A Revis�o informada (" + _cRevisa + ") da vers�o or�ament�ria (" + _cVersao + ") n�o poder� ser desmontada, pois n�o � a �ltima. Somente a �ltima revis�o (" + (M001)->REVATV + ") poder� ser desmontada." + msrhEnter + msrhEnter + msrhEnter + msrhEnter + "Favor verificar com o respons�vel pelo processo Or�ament�rio!!!")
		(M001)->(dbCloseArea())
		Return .F.
	EndIf	
	(M001)->(dbCloseArea())

	_cVetTabl  := {'Z42','Z47','Z50','Z98','ZB0','ZB1','ZB2','ZB3','ZB4','ZB5','ZB6','ZB7','ZB8','ZB9','ZBA','ZBB','ZBC','ZBD','ZBE','ZBF','ZBG','ZBH','ZBI','ZBJ','ZBK','ZBL','ZBM','ZBN','ZBO','ZBP','ZBQ','ZBR','ZBS','ZBT','ZBU','ZBV','ZBX','ZBY','ZBW','ZBZ','ZCH'}

	For _ms := 1 to Len(_cVetTabl)

		dbSelectArea("SX2")
		dbSetOrder(1)
		dbSeek(_cVetTabl[_ms])

		_cCampTab := ""
		_cIntoCam := ""
		_cTemVers := .F.

		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSeek(SX2->X2_CHAVE)

		If Substr(RetSqlName(SX2->X2_CHAVE),4,2) == cEmpAnt

			While !Eof() .and. SX3->X3_ARQUIVO == SX2->X2_CHAVE 

				If SX3->X3_CONTEXT <> "V"

					If "VERSAO" $ Alltrim(SX3->X3_CAMPO) 
						_cTemVers := .T.
					EndIf

				EndIf

				dbSelectArea("SX3")
				dbSkip()

			End

			XK001 := ""
			If SX2->X2_CHAVE $ "Z47/Z50"
				_cCampTab += " D_E_L_E_T_ = '*' "
			Else
				_cCampTab += " D_E_L_E_T_ = '*' , R_E_C_D_E_L_ = R_E_C_N_O_ "
			EndIf

			If _cTemVers

				XK001 := " UPDATE XTBL SET " + _cCampTab + " "
				XK001 += "   FROM " + RetSqlName(SX2->X2_CHAVE) + " XTBL "
				XK001 += "  WHERE " + SX2->X2_CHAVE + "_VERSAO = '" + _cVersao + "' "
				XK001 += "    AND " + SX2->X2_CHAVE + "_REVISA = '" + _cRevisa + "' "
				XK001 += "    AND " + SX2->X2_CHAVE + "_ANOREF = '" + _cAnoRef + "' "
				XK001 += "    AND D_E_L_E_T_ = ' ' "
				U_BIAMsgRun("Aguarde... Replicando tabela: " + SX2->X2_CHAVE ,,{|| TcSQLExec(XK001) })

			EndIf

		EndIf

	Next _ms

	MsgINFO("Fim do processamento..." + msrhEnter + msrhEnter + " Necess�rio abrir a vers�o correspondente!!!" )

	RestArea( _cAreaAtu )

Return

/*___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � fValidPerg � Autor � Marcos Alberto S    � Data � 18/09/12 ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function fValidPerg()

	local i,j
	_sAlias := GetArea()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(fPerg,fTamX1)
	aRegs:={}

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3
	aAdd(aRegs,{cPerg,"01","Vers�o Or�ament�ria      ?","","","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","ZB5"})
	aAdd(aRegs,{cPerg,"02","Revis�o a desmontar      ?","","","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Ano de Refer�ncia        ?","","","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Revis�o Reativada        ?","","","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	For i := 1 to Len(aRegs)
		if !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1",.t.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	RestArea(_sAlias)

Return