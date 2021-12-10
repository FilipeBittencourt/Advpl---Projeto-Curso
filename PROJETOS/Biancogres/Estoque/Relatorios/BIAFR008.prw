#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
|-----------------------------------------------------------|
| Fun��o: | BIAFR008																			  |
| Autor:	| Tiago Rossini Coradini - Facile Sistemas			  |
| Data:		| 18/11/14																			  |
|-----------------------------------------------------------|
| Desc.:	| Rotina para gera��o do relatorio de   					|
| 				| movimenta��es de materia prima (formato excel)	|
|-----------------------------------------------------------|
| OS:			|	XXXX-XX - Usu�rio: Wanisay William   		 			  |
|-----------------------------------------------------------|
*/


User Function BIAFR008()
Private oParam := TParBIAFR008():New()

	If cEmpAnt <> "01/05"
	
		If oParam:Box()
			fExport()		
		EndIf
	
	Else
		MsgInfo("Aten��o, somente � permitido a impress�o deste relat�rio nas empresas: Bianco e Incesa!")
	EndIf

Return()


Static Function fExport()
	
	If MsgYesNo("Deseja realmente exportar os dados?")
		U_BIAMsgRun("Exportando dados para Planilha...", "Aguarde!", {|| fExportExcel() })
	EndIf
	
Return()


Static Function fExportExcel()
Local aArea := GetArea()
Local oFWExcel := Nil
Local oMsExcel := Nil
Local cDir := GetSrvProfString("Startpath", "")
Local cFile := "BIAFR008-" + cEmpAnt+__cUserID +"-"+ dToS(Date()) +"-"+ StrTran(Time(), ":", "") + ".XML"
Local cWorkSE := ""
Local cWorkSS := ""
Local cWorkAE := ""
Local cTableE := ""
Local cTableS := ""
Local cDirTmp := AllTrim(GetTempPath())
//Local lNewTable := .T.
	
  oFWExcel := FWMsExcel():New()
	  
	cWorkSE := "Entradas - Sint�tico"
	oFWExcel:AddWorkSheet(cWorkSE)
	
	cTableE := Capital(FWEmpName(cEmpAnt)) + " - Entradas - "+ AllTrim(oParam:cProd)  + " at� " + AllTrim(oParam:cProdAte)
	oFWExcel:AddTable(cWorkSE, cTableE)
	oFWExcel:AddColumn(cWorkSE, cTableE, "Produto", 1, 1)
	oFWExcel:AddColumn(cWorkSE, cTableE, "Descri��o", 1, 1)
	oFWExcel:AddColumn(cWorkSE, cTableE, "Grupo", 1, 1)		
	oFWExcel:AddColumn(cWorkSE, cTableE, "1� UM", 1, 1)
	oFWExcel:AddColumn(cWorkSE, cTableE, "2� UM", 1, 1)
	oFWExcel:AddColumn(cWorkSE, cTableE, "Data", 1, 1)
	oFWExcel:AddColumn(cWorkSE, cTableE, "QTD 1� UM", 3, 2, .T.)
	oFWExcel:AddColumn(cWorkSE, cTableE, "QTD 2� UM", 3, 2, .T.)
	oFWExcel:AddColumn(cWorkSE, cTableE, "QTD Ticket em T", 3, 2, .T.)

	cWorkSS := "Sa�das - Sint�tico"
	oFWExcel:AddWorkSheet(cWorkSS)
	
	cTableS := Capital(FWEmpName(cEmpAnt)) + " - Sa�das - "+ AllTrim(oParam:cProd) + " at� " + AllTrim(oParam:cProdAte)
	oFWExcel:AddTable(cWorkSS, cTableS)
	oFWExcel:AddColumn(cWorkSS, cTableS, "Produto", 1, 1)
	oFWExcel:AddColumn(cWorkSS, cTableS, "Descri��o", 1, 1)
	oFWExcel:AddColumn(cWorkSS, cTableS, "Grupo", 1, 1)		
	oFWExcel:AddColumn(cWorkSS, cTableS, "1� UM", 1, 1)
	oFWExcel:AddColumn(cWorkSS, cTableS, "2� UM", 1, 1)
	oFWExcel:AddColumn(cWorkSS, cTableS, "Data", 1, 1)
	oFWExcel:AddColumn(cWorkSS, cTableS, "QTD 1� UM", 3, 2, .T.)
	oFWExcel:AddColumn(cWorkSS, cTableS, "QTD 2� UM", 3, 2, .T.)
	oFWExcel:AddColumn(cWorkSS, cTableS, "QTD Ticket em T", 3, 2, .T.)


	cWorkAE := "Entradas - Anal�tico"
	oFWExcel:AddWorkSheet(cWorkAE)
	
	cTableE := Capital(FWEmpName(cEmpAnt)) + " - Entradas - "+ AllTrim(oParam:cProd) + " at� " + AllTrim(oParam:cProdAte)
	oFWExcel:AddTable(cWorkAE, cTableE)
	oFWExcel:AddColumn(cWorkAE, cTableE, "Produto", 1, 1)
	oFWExcel:AddColumn(cWorkAE, cTableE, "Descri��o", 1, 1)
	oFWExcel:AddColumn(cWorkAE, cTableE, "Grupo", 1, 1)		
	oFWExcel:AddColumn(cWorkAE, cTableE, "1� UM", 1, 1)
	oFWExcel:AddColumn(cWorkAE, cTableE, "2� UM", 1, 1)
	oFWExcel:AddColumn(cWorkAE, cTableE, "Data", 1, 1)
	oFWExcel:AddColumn(cWorkAE, cTableE, "QTD 1� UM", 3, 2, .T.)
	oFWExcel:AddColumn(cWorkAE, cTableE, "QTD 2� UM", 3, 2, .T.)
	oFWExcel:AddColumn(cWorkAE, cTableE, "QTD Ticket em T", 3, 2, .T.)
	oFWExcel:AddColumn(cWorkAE, cTableE, "N�mero Ticket", 1, 1)
	oFWExcel:AddColumn(cWorkAE, cTableE, "S�rie NF", 1, 1)
	oFWExcel:AddColumn(cWorkAE, cTableE, "NF", 1, 1)
	oFWExcel:AddColumn(cWorkAE, cTableE, "Fornecedor", 1, 1)
	oFWExcel:AddColumn(cWorkAE, cTableE, "Loja", 1, 1)	
		
	
    
    // Entradas/Saidas - Sintetico
	cQry := GetNextAlias()
	
	cSQL := "EXEC SP_MOVIMENTACAO_MATERIA_PRIMA_SINTETICO_"+cEmpAnt + ValToSQL(oParam:dDatDe) + ", "+ ValToSQL(oParam:dDatAte) + ", "+ ValToSQL(oParam:cProd) + ", " + ValToSQL(oParam:cProdAte)
			
	TcQuery cSQL New Alias (cQry)
	  		
	While (cQry)->(!Eof())
		



        
		If (cQry)->TIPO_MOV == "E"
			oFWExcel:AddRow(cWorkSE, cTableE, {(cQry)->D1_COD, (cQry)->B1_DESC, (cQry)->D1_GRUPO, (cQry)->D1_UM, (cQry)->D1_SEGUM, dToC(sToD((cQry)->Z11_DATAIN)), (cQry)->QTD_1UM, (cQry)->QTD_2UM, (cQry)->QTD_TK_TON})
		Else
			oFWExcel:AddRow(cWorkSS, cTableS, {(cQry)->D1_COD, (cQry)->B1_DESC, (cQry)->D1_GRUPO, (cQry)->D1_UM, (cQry)->D1_SEGUM, dToC(sToD((cQry)->Z11_DATAIN)), (cQry)->QTD_1UM, (cQry)->QTD_2UM, (cQry)->QTD_TK_TON})
		EndIf		
		
		(cQry)->(DbSkip())
		
	EndDo
	
    If Empty(Alltrim(oParam:cProd))
        oParam:cProd:="1010000        " // Primeiro produto da Biancgres na SB1, marreta pra aceitar o campo 'produto de' vazio
    EndIf

	If Empty(AllTrim(oParam:cProdAte))
        oParam:cProdAte:=oParam:cProd 
    EndIf

	// Entradas - Anal�tico
	cQry := GetNextAlias()
	
	cSQL := "EXEC SP_MOVIMENTACAO_MATERIA_PRIMA_ANALITICO_"+cEmpAnt + ValToSQL(oParam:dDatDe) + ", "+ ValToSQL(oParam:dDatAte) + ", "+ ValToSQL(oParam:cProd) + ", " + ValToSQL(oParam:cProdAte)
			
	TcQuery cSQL New Alias (cQry)
	  		
	While (cQry)->(!Eof())
		
		oFWExcel:AddRow(cWorkAE, cTableE, {(cQry)->D1_COD, (cQry)->B1_DESC, (cQry)->D1_GRUPO, (cQry)->D1_UM, (cQry)->D1_SEGUM, dToC(sToD((cQry)->Z11_DATAIN)), (cQry)->QTD_1UM, (cQry)->QTD_2UM, (cQry)->QTD_TK_TON,;
																			 (cQry)->D1_YNUMTK, (cQry)->D1_SERIE, (cQry)->D1_DOC, (cQry)->D1_FORNECE, (cQry)->D1_LOJA})
		
		(cQry)->(DbSkip())
		
	EndDo			
	
	oFWExcel:Activate()			
	oFWExcel:GetXMLFile(cFile)
	oFWExcel:DeActivate()		
		 	
	If CpyS2T(cDir + cFile, cDirTmp, .T.)
		
		fErase(cDir + cFile) 
		
		If ApOleClient('MsExcel')
		
			oMSExcel := MsExcel():New()
			oMSExcel:WorkBooks:Close()
			oMSExcel:WorkBooks:Open(cDirTmp + cFile)
			oMSExcel:SetVisible(.T.)
			oMSExcel:Destroy()
			
		EndIf

	Else
		MsgInfo("Arquivo n�o copiado para a pasta tempor�ria do usu�rio.")
	Endif
	
	RestArea(aArea)
		
Return()
