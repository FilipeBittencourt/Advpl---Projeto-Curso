#include "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �mt100tok  �Autor  �Microsiga           � Data �  10/29/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT100TOK()

	Local lRet		:= Paramixb[1]
	Local np
	Local cLote     := ''
	Local lContinua := .T.
	Local aItemPC		:= {}
	Local cMsgPC		:= ""
	Local cCondPagto	:= ""

	//Projeto contrato de verbas
	local aContrato		:= {}
	local nSaldCtr		:= 0
	local nPosTemp		:= 0
	Local I
	Local yg
	Local wr
	Local nI

	Public	sProcex := SPACE(10)

	//Vari�vel para controlar o RPV
	PUBLIC c_cNumRpv	:=	""

	Private aArea := GetArea()
	Private cArq	:= ""
	Private cInd	:= 0
	Private cReg	:= 0

	Private cArqSB1	:= ""
	Private cIndSB1	:= 0
	Private cRegSB1	:= 0

	Private cArqSBM	:= ""
	Private cIndSBM	:= 0
	Private cRegSBM	:= 0

	Private cArqSF4	:= ""
	Private cIndSF4	:= 0
	Private cRegSF4	:= 0
	Private _TIPO_SB1 := ""
	Private cDuplic	:= "S"
	Private C_COPIA	:= " "
	Private CtnSrvc := .F.  // Por Marcos Alberto Soprani em 20/09/12 comforme OS Effettivo 2114-12

	Private xVldMpXml := .F. // Tratamento implementado por Marcos Alberto Soprani em 26/09/14, para n�o permitir a inclus�o de uma nota fiscal de MP - Especie SPED/CTE sem xml.
	
	Private cCtrBloq := 0

	//Thiago Haagensen - Ticket 28029 - DUPLICIDADE AO LAN�AR CTE NA MUNDI
	If !fValidCHV()
		Return .F.
	Endif
	
	If !FwIsInCallStack('U_GATI001') .Or. (FwIsInCallStack('U_GATI001') .And. !FwIsInCallStack('U_Retorna') .And. !FwIsInCallStack('GeraConhec') .And. !l103Auto)


		//Tratamento para Totvs Colaboracao 2.0
		If GetMv("MV_COMCOL1") <> 2 .And. Upper(Alltrim(FUNNAME())) == "SCHEDCOMCOL"  
			Return(.F.)
		EndIf

		IF UPPER(ALLTRIM(FUNNAME())) == "MATA920"
			Return(lret)
		ENDIF

		IF UPPER(ALLTRIM(FUNNAME())) == "SPEDNFE"
			Return(lret)
		ENDIF

		cArq := Alias()
		cInd := IndexOrd()
		cReg := Recno()

		If lret == .T.
			If SF1->F1_YBLOQ == "S"
				MsgBox("Nota fiscal com Bloqueio de Preco! Nao podera ser gravada.","MT100TOK","STOP")
				lret := .F.
			EndIf
			//Amarra o Tipo de Doc. "Compl. Frete" a Especie "CTR"
			//If CTIPO == "C" .and. CESPECIE <> "CTR"
			//	MsgBox("Confira o campo Especie do Documento, pois esta preenchido de forma incorreta!","MT100TOK","STOP")
			//	lret := .F.
			//EndIf
		EndIf

		/*
		//Retirado a pedido do Sr. T�nia e aprovado pelo Sr Enelcio OS 0175-12
		IF cEmpAnt == '07'
		IF !(ALLTRIM(CA100FOR) $ '000534/ICMS/ICMSTR/PIS/COFINS/IRPJ/CSLL/000399/008070/002912') .AND. CTIPO == 'N'
		MsgBox("Fornecedor digitado n�o � a Biancogres. Favor procurar o Departamento Cont�bil","MT100TOK","STOP")
		lret := .F.

		DbSelectArea(cArq)
		DbSetOrder(cInd)
		DbGoTo(cReg)

		RestArea(aArea)
		Return(lret)
		ENDIF
		ENDIF
		*/

		// Conforme OS 3107-15 - Criado por Marcos Alberto Soprani em 18/03/16
		aCpAp          := {}
		Aadd( aCpAp , {"PRODUTO"  ,"C",015,000} )
		Aadd( aCpAp , {"IDENTB6"  ,"C",006,000} )
		Aadd( aCpAp , {"QUANT"    ,"N",018,008} )
		apIndx := "PRODUTO+IDENTB6"
		TH04 := CriaTrab(aCpAp, .T.)
		dbUseArea( .T.,, TH04, "TH04", .F., .F. )
		dbCreateInd(TH04, apIndx,{ || apIndx })

		SS_VALOR := 0
		FOR I := 1 TO LEN(ACOLS)

			IF GdDeleted(I)
				loop
			ENDIF

			wTes 			:= Gdfieldget('D1_TES',I)
			wCod 			:= Gdfieldget('D1_COD',I)
			CLVL 			:= Gdfieldget('D1_CLVL',I)
			cItemCta  := Gdfieldget('D1_ITEMCTA',I)
			cSubItem	:= Gdfieldget('D1_YSUBITE',I)
			
			IF cEmpAnt <> '02'
				cContrat	:= Gdfieldget('D1_YCONTR',I)
			ELSE
				cContrat   := ''
			ENDIF
			cREGRA	  		:= Gdfieldget('D1_YREGRA',I)
			cLote			:= Gdfieldget('D1_LOTECTL',I)
			SS_VALOR		+= Gdfieldget('D1_TOTAL',I)
			cNfOri			:= Gdfieldget('D1_NFORI',I)
			cSeriOri		:= Gdfieldget('D1_SERIORI',I)
			cItemOri		:= Gdfieldget('D1_ITEMORI',I)
			cCFOP   		:= Gdfieldget('D1_CF',I)
			cQtdIt   		:= Gdfieldget('D1_QUANT',I)
			cIdentB6   		:= Gdfieldget('D1_IDENTB6',I)  // 18/03/16 por Marcos Alberto Soprani
			cAlmVend		:= Gdfieldget('D1_LOCAL',I)

			DbSelectArea("SF4")
			cArqSF4 := Alias()
			cIndSF4 := IndexOrd()
			cRegSF4 := Recno()
			DbSetOrder(1)
			DbSeek(xFilial("SF4")+wTes,.F.)
			cDuplic := SF4->F4_DUPLIC

			DbSelectArea("SB1")
			cArqSB1 := Alias()
			cIndSB1 := IndexOrd()
			cRegSB1 := Recno()
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+wCod,.F.)

			_TIPO_SB1 := SB1->B1_TIPO

			//Valida a Digitaca do Contrato
			If !Alltrim(CLVL) $ "2001_2007" //RANISSES EM 10/10/11
				IF SUBSTR(CLVL,1,1) == '8' .AND. EMPTY(cContrat)
					//MsgBox("O campo Contrato devera ser preenchido quando a Classe de Valor iniciar com 8.")
					MsgBox("O campo Contrato devera ser preenchido quando a Classe de Valor for '" + Alltrim(CLVL) + "'.","MT100TOK","STOP")
					lRet := .F.
				ENDIF
			EndIf

			IF !EMPTY(cContrat)
				DbSelectArea("SC3")
				DbSetOrder(1)
				DbSeek(xFilial("SC3")+cContrat)
				lPassei := .F.

				WHILE !EOF() .AND. SC3->C3_NUM == cContrat
					IF ALLTRIM(CLVL) == ALLTRIM(SC3->C3_YCLVL)
						lPassei := .T.
						IF SC3->C3_MSBLQL == '1' .and. cCtrBloq <> 2
						    cCtrBloq := 1							
						ELSE
						   cCtrBloq := 2
						ENDIF
					ENDIF

					DbSelectArea("SC3")
					DbSkip()
				END
				
				IF cCtrBloq == 1
				   MsgBox("[MT100TOK] Este contrato est� bloqueado.","MT100TOK","STOP")
				   cCtrBloq := 0
				   lRet := .F.
				ENDIF
				
				IF !lPassei
					MsgBox("A Classe de Valor desta NF dever� ser igual a Classe de Valor do Contrato informado.","MT100TOK","STOP")
					lRet := .F.
				ENDIF
			ENDIF

			IF (SUBSTR(cLote,1,4) == "AUTO" .OR. EMPTY(cLote)) .AND. SB1->B1_TIPO = "PA" .AND. SF4->F4_ESTOQUE  = "S" .AND. SB1->B1_RASTRO == 'L'
				MsgBox("Lote nao informado ou informado incorretamente: "+cLote,"MT100TOK","STOP")
				lRet := .F.
			ENDIF

			If !(SB1->B1_TIPO $ "PA#PP") .And. cAlmVend $ "02#04"
				MsgBox("Almoxarifado informado incorreto: " + cAlmVend,"MT100TOK","STOP")
				lRet := .F.			
			EndIf

			// Valida Subitem de projeto
			If !U_BIAF160(CLVL, cItemCta, cSubItem)
	
				MsgBox("A classe de valor e o item de selecionados, exige o preenchimento do Subitem de Projeto!", "MT100TOK", "STOP")
				
				lRet := .F.
							
			EndIf

			dbSelectArea("SBZ")
			dbSetOrder(1)
			dbSeek(xFilial("SBZ")+wCod,.F.)

			DbSelectArea("SBM")
			cArqSBM := Alias()
			cIndSBM := IndexOrd()
			cRegSBM := Recno()
			DbSetOrder(1)
			DbSeek(xFilial("SBM")+SB1->B1_GRUPO,.F.)

			//Fernando/Facile em 14/07/15 - retirar mensagem de TES sem estoque para produto comum
			_lComum := .F.
			SBZ->(DbSetOrder(1))
			If SBZ->(DbSeek(xFilial("SBZ")+wCod)) .And. SBZ->BZ_YCOMUM == "S"
				_lComum := .T.
			EndIf

			IF Subs(CLVL,1,1) = "8" .AND. Alltrim(SF4->F4_ESTOQUE) == "S"
				MsgBox("TES Usada Inv�lida. Este material � do tipo MD e n�o dever� atualizar estoque!","MT100TOK","STOP")
				lret := .F.
				TH04->(dbCloseArea())
				Ferase(TH04+GetDBExtension())
				Ferase(TH04+OrdBagExt())
				RestArea(aArea)
				Return(lret)
			ELSE
				//IF SM0->M0_CODIGO ="01"
				IF cREGRA = "N"
					If Alltrim(SBZ->BZ_YMD) == "S"
						If  SBM->BM_YCON_MD = "N"
							IF Alltrim(SF4->F4_ESTOQUE) == "S"
								MsgBox("TES Usada Invalida - Este material e do tipo MD devera atualizar estoque.","MT100TOK","STOP")
								lret := .F.
								TH04->(dbCloseArea())
								Ferase(TH04+GetDBExtension())
								Ferase(TH04+OrdBagExt())
								RestArea(aArea)
								Return(lret)
							ENDIF
						Else
							If Alltrim(SF4->F4_ESTOQUE) == "N"
								MsgBox("TES Usada Inv�lida. Este material � do tipo MD dever� atualizar estoque!","MT100TOK","STOP")
								lret := .F.
								TH04->(dbCloseArea())
								Ferase(TH04+GetDBExtension())
								Ferase(TH04+OrdBagExt())
								RestArea(aArea)
								Return(lret)
							ENDIF
						EndIf
					ELSEIF Alltrim(SB1->B1_TIPO) == "MP" .OR. Alltrim(SB1->B1_TIPO) == "MC" .OR. Alltrim(SB1->B1_TIPO) == "ME" .OR. Alltrim(SB1->B1_TIPO) == "OI"
						IF Alltrim(SF4->F4_ESTOQUE) <> "S" .And. !_lComum
							MsgBox("TES Usada Inv�lida. Este material � do tipo MP, MC, ME ou OI e dever� atualizar estoque.","MT100TOK","STOP")
							lret := .F.
							TH04->(dbCloseArea())
							Ferase(TH04+GetDBExtension())
							Ferase(TH04+OrdBagExt())
							RestArea(aArea)
							Return(lret)
						EndIf
					EndIf
				EndIf
				//ENDIF
			ENDIF

			// Por Marcos Alberto Soprani em 20/09/12 comforme OS Effettivo 2114-12
			If Substr(wCod,1,3) == "306"
				CtnSrvc := .T.
			EndIf

			// Implementado em 18/04/13 por Marcos Alberto Soprani para atender ao controle mais eficiente de Remessa para conserto. Conforme acordado com Robert em 17/04/13
			If Substr(cCFOP,2,3) == "916"
				If Empty(cNfOri) .or. Empty(cSeriOri) .or. Empty(cItemOri)

					MsgBox("Nota Fiscal de Retorno de Remessa para Conserto." + CHR(13) + CHR(13) + "Necess�rio verificar se os campos NFOri, SerieOri e ItemOri (bem como o c�digo do produto/fornecedor/loja) est�o devidamente preenchidos!!!","MT100TOK","ALERT")
					lret := .F.
					TH04->(dbCloseArea())
					Ferase(TH04+GetDBExtension())
					Ferase(TH04+OrdBagExt())
					RestArea(aArea)
					Return(lret)

				Else

					YT006 := " SELECT ISNULL((SELECT SUM(D2_QUANT)
					YT006 += "                  FROM "+RetSqlName("SD2")+" SD2
					YT006 += "                 WHERE D2_FILIAL = '"+xFilial("SD2")+"'
					YT006 += "                   AND D2_DOC = '"+cNfOri+"'
					YT006 += "                   AND D2_SERIE = '"+cSeriOri+"'
					YT006 += "                   AND D2_ITEM = '"+cItemOri+"'
					YT006 += "                   AND D2_CLIENTE = '"+cA100For+"'
					YT006 += "                   AND D2_LOJA = '"+cLoja+"'
					YT006 += "                   AND D2_COD = '"+wCod+"'
					YT006 += "                   AND SUBSTRING(D2_CF,2,3) = '915'
					YT006 += "                   AND SD2.D_E_L_E_T_ = ' '), 0) - (ISNULL((SELECT SUM(D1_QUANT)
					YT006 += "                                                              FROM "+RetSqlName("SD1")+" SD1
					YT006 += "                                                             WHERE D1_FILIAL = '"+xFilial("SD1")+"'
					YT006 += "                                                               AND D1_NFORI = '"+cNfOri+"'
					YT006 += "                                                               AND D1_SERIORI = '"+cSeriOri+"'
					YT006 += "                                                               AND D1_ITEMORI = '"+cItemOri+"'
					YT006 += "                                                               AND D1_FORNECE = '"+cA100For+"'
					YT006 += "                                                               AND D1_LOJA = '"+cLoja+"'
					YT006 += "                                                               AND D1_COD = '"+wCod+"'
					YT006 += "                                                               AND SUBSTRING(D1_CF,2,3) = '916'
					YT006 += "                                                               AND SD1.D_E_L_E_T_ = ' '), 0) + "+Alltrim(Str(cQtdIt))+") SALDO
					cIndex := CriaTrab(Nil,.f.)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,YT006),'YT06',.T.,.T.)
					dbSelectArea("YT06")
					dbGoTop()
					If YT06->SALDO < 0
						MsgBox("Nota Fiscal de Retorno de Remessa para Conserto." + CHR(13) + CHR(13) + "Necess�rio verificar se os campos NFOri, SerieOri e ItemOri est�o devidamente preenchidos, pois n�o h� saldo suficiente para atender esta devolu��o!!!","MT100TOK","STOP")
						lret := .F.
						YT06->(dbCloseArea())
						Ferase(cIndex+GetDBExtension())     //arquivo de trabalho
						Ferase(cIndex+OrdBagExt())          //indice gerado
						TH04->(dbCloseArea())
						Ferase(TH04+GetDBExtension())
						Ferase(TH04+OrdBagExt())
						RestArea(aArea)
						Return(lret)
					EndIf
					YT06->(dbCloseArea())
					Ferase(cIndex+GetDBExtension())     //arquivo de trabalho
					Ferase(cIndex+OrdBagExt())          //indice gerado

				EndIf

			EndIf

			// Por Marcos Alberto Soprani em 26/09/14, conforme descrito acima na declara��o da vari�vel.
			If cFormul == "N" .and. !cTipo $ "C/I/P"
				If cEmpAnt <> "06" 
					If (cEmpAnt == "01" .And. cFilAnt == "01") .Or. (cEmpAnt <> "01")
						If Substr(wCod,1,3) $ "101/102/103/104/105/106/107"
							xVldMpXml := .T.
						EndIf
					EndIf
				EndIf
			EndIf

			//FERNANDO/FACILE em 11/02/2015 - Validar se existe OP para NFs da VITCER
			If INCLUI .OR. ALTERA
				lret := U_FOPVCR01(I)
				If !lret
					MsgBox("N�o foi encontrada OP com saldo dispon�vel para entrada deste Item/NF, verificar com o Setor de PCP.","MT100TOK","STOP")
					TH04->(dbCloseArea())
					Ferase(TH04+GetDBExtension())
					Ferase(TH04+OrdBagExt())
					RestArea(aArea)
					Return(lret)
				EndIf
			EndIf

			// Por Marcos Alberto Soprani em 18/03/16 para atender OS 3107-15
			If SF4->F4_PODER3 $ "D/R"

				dbSelectArea("TH04")
				dbSetOrder(1)
				If !dbSeek( wCod + cIdentB6 )
					RecLock("TH04",.T.)
					TH04->PRODUTO := wCod
					TH04->IDENTB6 := cIdentB6
				Else
					RecLock("TH04",.F.)
				EndIf
				TH04->QUANT  += cQtdIt
				MsUnLock()

			EndIf

			//|Pontin / Facile - Valida��o de pedidos de compras com forma de pagamento diferentes na mesma NF |
			aAdd(aItemPC,{Gdfieldget('D1_COD',I),;
			Gdfieldget('D1_PEDIDO',I),;
			Gdfieldget('D1_ITEMPC',I);
			})

		NEXT

		// Em 18/03/16 Por Marcos Alberto Soprani
		dbSelectArea("TH04")
		dbGoTop()
		While !Eof()

			RV003 := " SELECT COUNT(*) CONTAD "
			RV003 += "   FROM "+RetSqlName("SB6")+" "
			RV003 += "  WHERE B6_FILIAL = '"+xFilial("SB6")+"' "
			RV003 += "    AND B6_PRODUTO = '"+TH04->PRODUTO+"' "
			RV003 += "    AND B6_IDENT = '"+TH04->IDENTB6+"' "
			RV003 += "    AND B6_SALDO < "+Alltrim(Str(TH04->QUANT))+" "
			RV003 += "    AND B6_SALDO <> 0 "
			RV003 += "    AND D_E_L_E_T_ = ' ' "
			RVcIndex := CriaTrab(Nil,.f.)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,RV003),'RV03',.T.,.T.)
			dbSelectArea("RV03")
			dbGoTop()
			If RV03->CONTAD <> 0

				MsgBox("O IDENT: " + TH04->IDENTB6 + " informado n�o tem quantidade suficiente para atender �s linhas onde ele foi informado. Favor verificar...","MT100TOK","STOP")
				TH04->(dbCloseArea())
				Ferase(TH04+GetDBExtension())
				Ferase(TH04+OrdBagExt())

				RV03->(dbCloseArea())
				Ferase(RVcIndex+GetDBExtension())
				Ferase(RVcIndex+OrdBagExt())
				Return(.F.)

			EndIf
			RV03->(dbCloseArea())
			Ferase(RVcIndex+GetDBExtension())
			Ferase(RVcIndex+OrdBagExt())

			dbSelectArea("TH04")
			dbSkip()

		End

		TH04->(dbCloseArea())
		Ferase(TH04+GetDBExtension())
		Ferase(TH04+OrdBagExt())

		//BLOQUEAR ENTRADA DE NF COM NATUREZA BLOQUEADA
		IF SM0->M0_CODIGO <> '02'
			nSitNat := Alltrim(SED->ED_MSBLQL) //Posicione("SED",1,xFilial("SED")+CNATUREZA,"ED_MSBLQL")
			If nSitNat == "1"
				MsgBox("Natureza Financeira "+Alltrim(SED->ED_CODIGO)+" est� bloqueada para uso!","MT100TOK","STOP")
				Return(.F.)
			EndIf
		Endif

		// ENVIANDO EMAIL PARA AS NOTAS DE DEVOLUCAO DE PRODUTOS PA
		IF ALLTRIM(CTIPO) = "D" .AND. ALLTRIM(_TIPO_SB1) = "PA"

			// ENVIANCO EMAIL PARA OS RESPONSAVEIS PELAS COMISSOES
			C_TITULO 	:= "Nota fiscal de devolu��o"			
			C_DESTI		:= "nadine.araujo@biancogres.com.br"

			//C_MENS 		:= "Foi lan�ada uma nota fiscal de devolu��o na " + IIF(CEMPANT="01","Biancogres",IIF(CEMPANT="05","Incesa","Biancogres"))
			//C_MENS 		+= " "  + CHR(13)+CHR(10)
			//C_MENS 		+= "Nota Fiscal:	" 	+	CNFISCAL + CHR(13)+CHR(10)
			//C_MENS 		+= "Cod Cliente:	" 	+ 	CSERIE + CHR(13)+CHR(10)
			//C_MENS 		+= "Emissa�o:	" 			+ 	DTOC(DDEMISSAO) + CHR(13)+CHR(10)
			//C_MENS 		+= "Cod Fornecedor:   " + 	CA100FOR + CHR(13)+CHR(10)
			//C_MENS 		+= "Loj Fornecedor:   " + 	CLOJA + CHR(13)+CHR(10)

			//ALTERADO LAYOUT DO EMAIL - FERNANDO - 06/08/2010
			SD2->(DbSetOrder(3))
			SD2->(DbSeek(XFilial("SD2")+cNFORI+cSERIORI))

			//SD2->(DbSetOrder(3))
			//SD2->(DbSeek(XFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE))

			C_MENS 		:= U_NDV_MAIL(DTOC(dDataBase),SUBSTR(Time(),1,5),SF2->F2_CLIENTE+" - "+POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NOME"),SF1->F1_DOC,SF1->F1_SERIE,SF2->F2_DOC,SF2->F2_SERIE,SD2->D2_PEDIDO,SF2->F2_VEND1+" - "+POSICIONE("SA3",1,XFILIAL("SA3")+SF2->F2_VEND1,"A3_NOME"))
			U_BIAEnvMail(,C_DESTI,C_TITULO,C_MENS)

		END IF

		// Inclu�do por Marcos Alberto Soprani em 19/07/12 conforme OS Effettivo 0677-12
		if Type("oFisRod") <> "U"
			For np := 1 to Len(oFisRod:AARRAY)
				If Alltrim(oFisRod:AARRAY[np][1]) == "IRR"
					If Empty(cCodRet) .or. cDirf == "2"
						MsgBox("Esta nota possui Imposto de Renda e � obrigat�rio a digita��o do C�digo de Reten��o.","MT100TOK","STOP")
						lRet := .F.
					EndIf
				EndIf
				If Alltrim(oFisRod:AARRAY[np][1]) == "PIS"
					If Empty(cCodRet) .or. cDirf == "2"
						MsgBox("Esta nota possui PIS e � obrigat�rio a digita��o do C�digo de Reten��o.","MT100TOK","STOP")
						lRet := .F.
					EndIf
				EndIf
				If Alltrim(oFisRod:AARRAY[np][1]) == "COF"
					If Empty(cCodRet) .or. cDirf == "2"
						MsgBox("Esta nota possui COFINS e � obrigat�rio a digita��o do C�digo de Reten��o.","MT100TOK","STOP")
						lRet := .F.
					EndIf
				EndIf
				If Alltrim(oFisRod:AARRAY[np][1]) == "CSL"
					If Empty(cCodRet) .or. cDirf == "2"
						MsgBox("Esta nota possui CSLL e � obrigat�rio a digita��o do C�digo de Reten��o.","MT100TOK","STOP")
						lRet := .F.
					EndIf
				EndIf
			Next np
		EndIf

		// Por Marcos Alberto Soprani em 19/07/12 conforme OS Effettivo 1327-12
		// Esta regra deve andar em conjunto com o ponto de entrada MT116TOK
		If cFormul == "N"
			If Alltrim(cEspecie) $ "SPED/CTE/CTEOS" .and. Empty(M->F1_CHVNFE) .and. 1 == 2 // retirado dia 28/01/2016 O.S 0260-16 4444-15
				MsgBox("Se a ESPECIE for SPED/CTE/CTEOS a chave dever� ser informada.","MT100TOK","STOP")
				lRet := .F.
			Else
				If Alltrim(cEspecie) $ "SPED/CTE/CTEOS" .and. INCLUI
					TX001 := " SELECT COUNT(*) CONTAD
					TX001 += "   FROM " + RetSqlName("SF1")
					TX001 += "  WHERE F1_FILIAL  = '"+xFilial("SF1")+"'
					TX001 += "    AND F1_CHVNFE  = '"+M->F1_CHVNFE+"'
					TX001 += "    AND F1_DOC	<> '"+CNFISCAL+"'
					TX001 += "    AND D_E_L_E_T_ = ' '
					TCQUERY TX001 ALIAS "TX01" NEW
					dbSelectArea("TX01")
					If TX01->CONTAD > 0
						MsgBox("Chave eletr�nica duplicada. Ser� necess�rio filtrar, na tabela SF1, quais notas est�o associadas com a chave acima e efetuar o devido acerto.","MT100TOK","STOP")
						lRet := .F.
						lContinua := .F.
					EndIf
					TX01->(dbCloseArea())

					If lContinua

						xfCnpj := IIF(cTipo $ "D/B", SA1->A1_CGC, SA2->A2_CGC)
						If Substr(M->F1_CHVNFE,7,14) <> xfCnpj .And. Substr(M->F1_CHVNFE,7,14) <> "83817858007183" .And. Substr(M->F1_CHVNFE,7,14) <> "08197731001233"
							MsgBox("A chave eletr�nica desta nota n�o pertence ao fornecedor corrente. Favor verificar!","MT100TOK","STOP")
							lRet := .F.
							lContinua := .F.
						EndIf

					EndIf

					If lContinua
						If Substr(M->F1_CHVNFE,26,9) <> CNFISCAL
							MsgBox("A chave eletr�nica Informada n�o pertence ao Numero de Nota Corrente. Favor verificar!","MT100TOK","STOP")
							lRet := .F.
						EndIf
					EndIf
				EndIf
				If lContinua
					// Implementado em 19/07/12 por Marcos Alberto Soprani ni intuito de diminuir um pouco a quantidade de erro de usu�rio
					If !Empty(M->F1_CHVNFE) .and. !Alltrim(cEspecie) $ "SPED/CTE/CTEOS"
						MsgBox("O Campo Chave Eletr�nica foi informado portanto � necess�rio informar o ESPECIE como SPED, CTE ou CTEOS","MT100TOK","STOP")
						lRet := .F.
					EndIf
				EndIf
			EndIf
		EndIf

		// Por Marcos Alberto Soprani em 20/09/12 comforme OS Effettivo 2114-12
		// Foi necess�rio efetuar este tratamento porque quando o retorno j� est� com problema em uma das regras e entra ne regra abaixo, se confirmada passa. Por Marcos Alberto Soprani em 02/10/12
		// 19/06 => Portaria Fiscal / Fernando  / N�o executar se for execauto de classificacao
		If lRet .And. !IsInCallStack("U_TACLNFJB") .And. !IsInCallStack("U_BACP0012") .And. !IsInCallStack("U_PNFM0002") .And. !IsInCallStack("U_PNFM0005") .And. !IsInCallStack("U_JOBFATPARTE")
			If CtnSrvc
				lRet := MsgNOYES("Esta nota cont�m ITENS de SERVI�O. Necess�rio certificar-se de que o valor do ISS esteja informado corretamente."+CHR(13)+CHR(13)+"Confirma a inclus�o da nota, certo de que o valor do ISS est� correto?","Aten��o. (MT100TOK)")
			Else
				If Type("oFisRod") <> "U"
					xFoldImp := oFisRod:AARRAY
					For yg := 1 to Len(xFoldImp)
						If Alltrim(oFisRod:AARRAY[yg][1]) == "ISS"
							lRet := MsgNOYES("Esta nota N�O cont�m ITENS de SERVI�O. Necess�rio certificar-se de que o valor do ISS esteja informado corretamente."+CHR(13)+CHR(13)+"Confirma a inclus�o da nota, certo de que o valor do ISS est� correto?","Aten��o. (MT100TOK)")
						EndIf
					Next yg
				EndIf
			EndIf
		EndIf

		// Por Marcos Alberto Soprani em 12/12/12 conforme OS Effettivo 2603-12 e 2347-12
		If cFormul == "N"
			If Len(Alltrim(cNFiscal)) <> 9 .or. cNFiscal == "000000000"
				MsgBox("Problema com a nunera��o do documento fiscal. Favor verificar!!!","MT100TOK","STOP")
				lRet := .F.
			EndIf
		EndIf

		// Por Marcos Alberto Soprani em 12/12/12 conforme Effettivo 2472-12
		If Alltrim(cEspecie) $ "CTE/CTEOS"
			For wr := 1 to 3
				If !Substr(cSerie,wr,1) $ "1_2_3_4_5_6_7_8_9_0_ "
					MsgBox("Quando se tratar de CTE/CTEOS n�o � permitida a digita��o da SERIE com LETRAS. Favor verificar!!!","MT100TOK","STOP")
					lRet := .F.
					Exit
				EndIf
			Next wr
		EndIf

		// Tratamento inclu�do por Marcos Alberto Soprani em 28/08/14 conforme OS effettivo 1605-14
		If !cTipo $ "D/B" .and. Alltrim(cEspecie) <> "RPS"

			kwCnpj   := SA2->A2_CGC
			kwCodEmp := ""
			If Alltrim(kwCnpj) == "02077546000176"         // Biancogres
				kwCodEmp := "01"
			ElseIf Alltrim(kwCnpj) == "04917232000160"     // Incesa
				kwCodEmp := "05"
			ElseIf Alltrim(kwCnpj) == "10524837000193"     // LM
				kwCodEmp := "07"
			ElseIf Alltrim(kwCnpj) == "14086214000137"     // Mundi
				kwCodEmp := "13"
			ElseIf Alltrim(kwCnpj) == "08930868000100"     // Vitcer
				kwCodEmp := "14"
			EndIf
			If !Empty(kwCodEmp)
				RT005 := " SELECT COUNT(*) CONTAD
				RT005 += "   FROM SF2"+kwCodEmp+"0
				RT005 += "  WHERE F2_DOC = '"+cNFiscal+"'
				RT005 += "    AND F2_SERIE = '"+cSerie+"'
				RT005 += "    AND D_E_L_E_T_ = ' '
				RTIndex := CriaTrab(Nil,.f.)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,RT005),'RT05',.T.,.T.)
				If RT05->CONTAD == 0 .And. Upper(AllTrim(getenvserver())) == "PRODUCAO" //Executa validacao somente para ambiente de PRODUCAO 
					MsgBox("Nota fiscal emitada INTRAGRUPO n�o localizada na empresa ORIGEM! Ser� necess�rio verificar a numera��o desta nota fiscal na empresa ORIGEM antes de efetuar o lan�amento desta nota nesta empresa.","MT100TOK","STOP")
					lRet := .F.
				EndIf
				RT05->(dbCloseArea())
				Ferase(RTIndex+GetDBExtension())
				Ferase(RTIndex+OrdBagExt())
			EndIf

		EndIf

		//  Implementado em 20/02/13 por Marcos Alberto Soprani para auxilio do fechamento de estoque vs movimenta��es retroativas que poderiam
		// acontecer pelo fato de o par�mtro MV_ULMES necessitar permanecer em aberto at� que o fechamento de estoque esteja conclu�do
		If dDataBase <= GetMv("MV_YULMES")
			MsgBox("Imposs�vel prosseguir, pois este movimento interfere no fechamento de custo!!! Favor verificar com a contabilidade!!!","MT100TOK","STOP")
			lRet := .F.
		EndIf

		//|Pontin / Facile - Valida��o de pedidos de compras com forma de pagamento diferentes na mesma NF |
		If lRet .And. Len(aItemPC) > 0

			DbSelectArea("SC7")
			SC7->(DbSetOrder(9))

			/* Estrutura array aItemPC
			x,1 - C�digo do Produto
			x,2 - Numero do Pedido de Compra
			x,3 - Item do Pedido de Compra
			*/

			For nI := 1 To Len(aItemPC)
				cSeek := ""
				cSeek += xFilEnt(xFilial("SC7")) + cA100For + cLoja + aItemPC[nI,2]
				If SC7->(MsSeek(cSeek))

					If Empty(cCondPagto)
						cCondPagto	:= SC7->C7_COND
					Else

						If AllTrim(cCondPagto) <> AllTrim(SC7->C7_COND)

							cMsgPC	+= "Produto: " + aItemPC[nI,1] + " / Numero PC: " + aItemPC[nI,2] + " / Cond. Pagto: " + SC7->C7_COND + Chr(13) + Chr(10)

						EndIf

					EndIf

				EndIf

			Next nI

			If !Empty(cMsgPC) .And. !isInCallStack("U_TACLNFJB") .And. !IsInCallStack("U_PNFM0002") .And. !IsInCallStack("U_PNFM0005") .And. IsInCallStack("U_JOBFATPARTE")

				psOpc	:= Aviso("MT100TOK", "Existem itens com diverg�ncia na condi��o de pagamento vinculada ao Pedido de Compras!!" + Chr(13) + Chr(10) + Chr(13) + Chr(10) +;
				"Segue abaixo detalhes dos itens:" + Chr(13) + Chr(10) + cMsgPC, {"Continuar","Voltar"}, 3)
				If psOpc == 1
					If !MsgNoYes("Tem certeza que n�o seria melhor resolver o problema antes de prosseguir?", "Diverg�ncia na condi��o de pagamento(1)" )
						lRet	:= .F.
					Else
						If !MsgYesNO("Realmente deseja continuar antes de avaliar? Tudo bem ent�o!!! N�o poderei fazer nada para ajud�-lo!!! Ok?", "Diverg�ncia na condi��o de pagamento(2)" )
							lRet	:= .F.
						EndIf
					EndIf
				Else
					lRet	:= .F.
				EndIf

			EndIf

		EndIf

		//Projeto contrato de verbas - valida��o de saldo do contrato para notas de bonifica��o.
		if lRet .and. (INCLUI .Or. ALTERA) .and. cFormul == "N"
			For np := 1 to Len(aCols) 
				if !GdDeleted(np) .and. !Empty(Gdfieldget('D1_YCTRVER',np))
					if (nPosTemp := aScan(aContrato,{|x| x[1] == Gdfieldget('D1_YCTRVER',np) }) ) == 0
						AADD(aContrato,{Gdfieldget('D1_YCTRVER',np),Gdfieldget('D1_TOTAL',np) })
					else
						aContrato[nPosTemp,2] += Gdfieldget('D1_TOTAL',np)
					endif
				endif
			next np

			if len(aContrato) > 0
				For np := 1 to Len(aContrato) 
					nSaldCtr := U_FCTVUT01(aContrato[np,1], 1) - U_FCTVUT01(aContrato[np,1], 2) 
					if aContrato[np,2] > nSaldCtr
						lRet := .F.
						MsgBox("O contrato numero "+aContrato[np,1]+" n�o possui saldo suficiente para esta Bonifica��o! ";
						+CRLF+"Saldo do Contrato: " + Alltrim(Transform(nSaldCtr,"@E 999,999,999,999.99")),"MT100TOK","STOP")
						EXIT
					endif
				next np
			endif
		endif

		//Valida��o do campo D1_YAPLIC
		If lRet
			For np := 1 to Len(aCols) 
				if !GdDeleted(np) .and. Alltrim(GdFieldGet("D1_CONTA",np)) <> "41301001" //.and. !Empty(Gdfieldget('D1_CONTA',np)) .And. Substr(Gdfieldget('D1_CONTA',np),1,1) == '6' .And. !Empty(Gdfieldget('D1_CLVL',np)) 
					CTH->(DbSetOrder(1))
					If CTH->(DbSeek(xFilial("CTH")+Gdfieldget('D1_CLVL',np))) .And. CTH->CTH_YATRIB == 'C' .And. Gdfieldget('D1_YAPLIC',np) $ ' _0'
						MsgBox("A Conta e a Classe de valor exigem que a Aplica��o seja Informada e diferente de zero!","MT100TOK","STOP")
						lRet	:=	.F.
						Exit
					endif
				endif
			next np
		EndIf

		If cArqSB1 <> ""
			dbSelectArea(cArqSB1)
			dbSetOrder(cIndSB1)
			dbGoTo(cRegSB1)
			RetIndex("SB1")
		EndIf

		If cArqSBM <> ""
			dbSelectArea(cArqSBM)
			dbSetOrder(cIndSBM)
			dbGoTo(cRegSBM)
			RetIndex("SBM")
		EndIf

		If cArqSF4 <> ""
			dbSelectArea(cArqSF4)
			dbSetOrder(cIndSF4)
			dbGoTo(cRegSF4)
			RetIndex("SF4")
		EndIf


		DbSelectArea(cArq)
		DbSetOrder(cInd)
		DbGoTo(cReg)

		RestArea(aArea)
	EndIf

	// Ticket: 25655 - Quando essa rotina eh executada via JOB, ocorre um travamento na contabilizacao.
	If !IsInCallStack("U_EJOBDEVINTE")

		If lret
			Conout("PASSA NO PE GTPE005")
			lret := U_GTPE005()
		Else
			Conout("N�O PASSA NO PE GTPE005")
		EndIf

	EndIf

	//Inserido para Solicitar o n�mero do RPV
	If lRet .And. !isInCallStack("U_TACLNFJB") .And. !IsInCallStack("U_PNFM0002") .And. !IsInCallStack("U_PNFM0005") .And. !IsInCallStack("U_JOBFATPARTE") .And. cTipo == "N"

		For np := 1 to Len(aCols) 
			if !GdDeleted(np) .and. Alltrim(GdFieldGet("D1_CONTA",np)) $ "61601022/31401019"            
				U_BIAFG106()
				Exit
			endif
		next np


	EndIf



Return(lret)

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���FUNCAO    � VER_VENC_DIGI � AUTOR � BRUNO MADALENO        � DATA � 29/01/09 ���
������������������������������������������������������������������������������Ĵ��
���DESCRI��O � BLOQUEAI VENCIMENTO MENOR QUE A DATA DA DIGITACAO               ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
STATIC FUNCTION VER_VENC_DIGI(V_VALTOT)

	LOCAL V_RET := .T.

	V_VENC := CONDICAO(V_VALTOT,CCONDICAO,,DDEMISSAO)
	IF V_VENC[1,1] < DDATABASE
		V_RET := .F.
	END IF

RETURN(V_RET)

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
��� Funcao   � ATU_PROCEX   � Autor �BRUNO MADALENO        � Data �  24/10/06  ���
������������������������������������������������������������������������������Ĵ��
���Descri��o � ATUALIZA DESPESAS REALIZADAS E BLOQUEAS AS MESMAS QUANDO NECESSA���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
Static Function ATU_PROCEX()

	LOCAL cQuery := ""
	Local I

	FOR I:= 1 TO LEN(ACOLS())
		nPosProce  := aScan(aHeader,{|x| x[2]=="D1_YPROCES"})
		SS_PROCEX := ALLTRIM(Acols[I,nPosProce])

		nPosNatu  := aScan(aHeader,{|x| x[2]=="D1_YNATURE"})
		SS_NATUR := ALLTRIM(Acols[I,nPosNatu])

		nPosVLCRZ  := aScan(aHeader,{|x| x[2]=="D1_TOTAL  "})
		SS_VALOR := ALLTRIM(Acols[I,nPosVLCRZ])

		//nPosVENCREA  := aScan(aHeader,{|x| x[2]=="D1_       "})
		//SS_VENC := ALLTRIM(Acols[I,nPosVENCREA])

		nPosDOC  := aScan(aHeader,{|x| x[2]=="D1_DOC    "})
		SS_DOC := ALLTRIM(Acols[I,nPosDOC])

		IF ! EMPTY(SS_PROCEX) //M->E2_YPROCEX <> ' '
			dbSelectArea("EET")
			RecLock("EET",.T.)
			EET->EET_FILIAL  	  := xFilial("EET")
			EET->EET_PEDIDO 	  := SS_PROCEX //M->E2_YPROCEX     //Nr Processo
			EET->EET_OCORRE 	  := "P"  				// Pedido ou embarque colocar sempre P
			EET->EET_DESPES	      := POSICIONE("SYB",3,xFilial("SYB")+SS_NATUR,"YB_DESP")
			EET->EET_DESADI	  	  := SS_VENC //M->E2_VENCREA  	//VENCIMENTO = HOJE + NR DIAS
			EET->EET_VALORR		  := SS_VALOR //M->E2_VLCRUZ 		//
			EET->EET_BASEAD		  := "1" 				// 1=Desp 2=Exportador
			EET->EET_DOCTO		  := SS_DOC //M->E2_NUM 			// Documento
			EET->EET_PAGOPO		  := "1"
			EET->EET_RECEBE		  := " "
			EET->EET_REFREC		  := " "
			EET->EET_CODINT		  := SS_NATUR
			EET->EET_YPRVRL		  := "R" 				//REALIZADAS
			EET->EET_YDC		  := "D"
			msUnLock()
		End If
	NEXT
	dbcommitall()
	MsgBox("Este Lancamento foi registrado para o processo de Exporta��o No: "+M->E2_YPROCEX,"MT100TOK","STOP")
	Private NLIB := POSICIONE("EE7",9,xFilial("EE7")+M->E2_YPROCEX,"EE7_YLIBER")

	If NLIB = 'N'
		M->E2_YSTATUS := 'B'
	Else
		//Selecionando a despesa prevista.
		cQuery := "Select * From " + RETSQLNAME("EET") + " where EET_PEDIDO = '" + alltrim(M->E2_YPROCEX) + "' And "
		cQuery += "EET_YPRVRL = 'P' And EET_CODINT = '"+ Alltrim(M->E2_NATUREZ) +"' "
		TCQUERY cQuery ALIAS "cTrab" NEW
		cTRAB->(DbGoTop())

		//VERIFICANDO SE EXISTE DESPESAS PREVISTAS
		If !cTrab->(EOF())
			M->E2_YSTATUS := 'B'
			MsgBox("N�o existe despesa prevista para esta naturea neste processo!"+Chr(13)+CHR(10)+;
			"Esta despesa ficar� bloqueada para baixa.","MT100TOK","STOP")
			DbSelectArea("cTrab")
			DbCloseArea()
			Return
		Else
			cQuery := ""
			cQuery := "Select * From " + RETSQLNAME("SE2") + " where E2_YPROCEX = '" + alltrim(M->E2_YPROCEX) + "' And "
			cQuery += "E2_NATUREZ = '"+ Alltrim(M->E2_NATUREZ) + "'"
			TCQUERY cQuery ALIAS "cTrabRealizadas" NEW

			nValor := m->E2_VALOR
			Do While !cTrabRealizadas->(EOF())
				nValor += Round(cTrabRealizadas->E2_VALOR,2)
				cTrabRealizadas->(DbSkip())
			End

			If Round(cTrab->EET_VALORR,2) >= nValor
				M->E2_YSTATUS := 'L'
			Else
				M->E2_YSTATUS := 'B'
			End if
			DbSelectArea("cTrabRealizadas")
			DbCloseArea()
		End  If
		DbSelectArea("cTrab")
		DbCloseArea()
	End If

RETURN()

//============================================================================================
//                                                                                           =
//============================================================================================
User Function NDV_MAIL(_CEMIS,_CHORA,_CCLI,_CNUMENT,_CSERENT,_CNUMERO,_CSERIE,_CPEDIDO,_CREPRES)

	Local _CMENS := ""
	Local _CEMPRESA := ""

	IF CEMPANT = "05"
		_CEMPRESA += 'INCESA REVESTIMENTO CER�MICO LTDA'
	ELSE
		_CEMPRESA += 'BIANCOGRES CERAMICA SA'
	END IF

	_CMENS+=' <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
	_CMENS+=' <html xmlns="http://www.w3.org/1999/xhtml"> '
	_CMENS+=' <head> '
	_CMENS+=' <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
	_CMENS+=' <title>Untitled Document</title> '
	_CMENS+=' <style type="text/css"> '
	_CMENS+=' <!-- '
	_CMENS+=' .style12 {font-size: 9px; } '
	_CMENS+=' .style35 {font-size: 11pt; font-weight: bold; } '
	_CMENS+=' .style36 {font-size: 9pt; } '
	_CMENS+=' .style41 { '
	_CMENS+=' 	font-size: 12px; '
	_CMENS+=' 	font-weight: bold; '
	_CMENS+=' } '
	_CMENS+=' .style44 {color: #FFFFFF; font-size: 10px; } '
	_CMENS+=' .style45 {font-size: 10px; } '
	_CMENS+=' --> '
	_CMENS+=' </style> '
	_CMENS+=' </head> '
	_CMENS+=' <body> '
	_CMENS+=' <table width="100%" border="1"> '
	_CMENS+='   <tr> '
	_CMENS+='     <th width="751" rowspan="3" scope="col">LAN&Ccedil;AMENTO DE NOTA FISCAL DE DEVOLU&Ccedil;&Atilde;O</th> '
	_CMENS+='     <td width="189" class="style12"><div align="right"> DATA EMISS�O: '+_CEMIS+' </div></td> '
	_CMENS+='   </tr> '
	_CMENS+='   <tr> '
	_CMENS+='     <td class="style12"><div align="right">HORA DA EMISS&Atilde;O: '+_CHORA+' </div></td> '
	_CMENS+='   </tr> '
	_CMENS+='   <tr> '
	_CMENS+='     <td><div align="center" class="style41">'+_CEMPRESA+'</div></td> '
	_CMENS+='   </tr> '
	_CMENS+=' </table> '
	_CMENS+=' <table width="100%" border="1"> '
	_CMENS+='   <tr bgcolor="#FFFFFF"> '
	_CMENS+='     <td><div align="left"><font size="-1" style="font-weight:bold">CLIENTE:</font></div></td> '
	_CMENS+='     <th colspan="5" scope="col"> '
	_CMENS+='     		<div align="left"><font size="-1" style="font-style:normal">'+_CCLI+'</font></div> '
	_CMENS+='     </th> '
	_CMENS+='   </tr> '
	_CMENS+='   <tr bgcolor="#0066CC"> '
	_CMENS+='     <th width="113"	scope="col"><span class="style44">NF ENTRADA</span></th> '
	_CMENS+='     <th width="113"	scope="col"><span class="style44">S&Eacute;RIE ENTRADA</span></th> '
	_CMENS+='     <th width="113"	scope="col"><span class="style44">NF SA&Iacute;DA </span></th> '
	_CMENS+='     <th width="88" scope="col"><span class="style44">S&Eacute;RIE SA&Iacute;DA</span></th> '
	_CMENS+='     <th width="77" scope="col"><span class="style44">PEDIDO</span></th> '
	_CMENS+='     <th width="469" scope="col"><span class="style44">REPRESENTANTE</span></th> '
	_CMENS+='   </tr> '
	_CMENS+=' <tr> '
	_CMENS+='     <td class="style45">'+_CNUMENT+'</td> '
	_CMENS+='     <td class="style45">'+_CSERENT+'</td> '
	_CMENS+='     <td class="style45">'+_CNUMERO+'</td> '
	_CMENS+='     <td class="style45"> '+_CSERIE+'</td> '
	_CMENS+='     <td class="style45">'+_CPEDIDO+'</td> '
	_CMENS+='     <td class="style45">'+_CREPRES+'</td> '
	_CMENS+='   </tr> '
	_CMENS+='   <tr bordercolor="#FFFFFF"> '
	_CMENS+='     <td colspan="6">&nbsp;</td> '
	_CMENS+='   </tr> '
	_CMENS+=' </table> '
	_CMENS+=' <p class="style35">Esta � uma mensagem autom�tica, favor n�o responde-la. (Fonte/Fun��o: MT100TOK.prw/ATU_PROCEX) </p> '
	_CMENS+=' </body> '
	_CMENS+=' </html> '

RETURN(_CMENS)


//Thiago Haagensen - Ticket 28029 - DUPLICIDADE AO LAN�AR CTE NA MUNDI
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fValidCHV   Autor � Thiago Haagensen    � Data �  13/11/20  ���
�������������������������������������������������������������������������͹��
���Descricao � Valida chave da nota fiscal se ja existe no banco de dados ���	 
��� 	  																  ���			  
���			   						  									  ���
�������������������������������������������������������������������������͹��
���Uso       � Compras		                                          	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function fValidCHV()

Local lRet    := .T.
Local cChvNFE := ""
Local cChvNFEAux := ""
Local cQuery  := ""

If !(ALLTRIM(FUNNAME())$ "MATA920/SPEDNFE") //Ticket 28448 - Adicionada as exce��es para MATA920/SPEDNFE
	cChvNFE := aNfeDanfe[13] //Usa a chave
	
	cQuery:= " SELECT * FROM "+RETSQLNAME("SF1")
	cQuery+= " WHERE D_E_L_E_T_ = '' "
	cQuery+= " AND F1_FILIAL = '"+xFilial("SF1")+"'
	cQuery+= " AND F1_CHVNFE = '"+aNfeDanfe[13]+"' 
	cQuery+= " AND F1_STATUS <> '' "
	TCQUERY CQUERY NEW ALIAS "YBX"
	
	cChvNFEAux	:= YBX->F1_CHVNFE
	cDocumento	:= ""
	cDocumento	:= YBX->F1_DOC
	cSerieC	:= ""
	cSerieC	:= YBX->F1_SERIE
		
	YBX->(DBCLOSEAREA())
	
	If !Empty(cChvNFEAux)
		Aviso("Nota Fiscal Eletronica", "Aten��o ! Esta chave que est� sendo inserida j� existe para NF: "+cDocumento + " S�rie : "+cSerieC+".",{"Fechar"},2)
		lRet:=.F.
	Return lRet
	Else
		lRet:=.T.
	Endif
Endif
Return  lRet
