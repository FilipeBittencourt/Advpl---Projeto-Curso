#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} BIAF074
@author Tiago Rossini Coradini
@since 02/05/2017
@version 1.0
@description Workflow de vencimento de contrato de menores aprendizes
@obs OS: 0062-17 - Jessica Alvarenga
@type function
/*/


User Function BIAF074()
	Local lRet := .F.
	Local cSQL := ""
	Local cSRA := ""
	Local cSRJ := ""
	Local cMail := ""
	Local cMailAux := ""
	Local aEmp := {}
	Local cEmp := ""
	Local cEmpName := ""
	Local nCount
	Private cQry := GetNextAlias()

	aAdd(aEmp, {"01", "Biancogres"})
	aAdd(aEmp, {"05", "Incesa"})
	aAdd(aEmp, {"13", "Mundi"})
	aAdd(aEmp, {"14", "Vitcer"})

	For nCount := 1 To Len(aEmp)

		cEmp := aEmp[nCount, 1]
		cEmpName := aEmp[nCount, 2]

		RpcSetType(3)
		RpcSetEnv(cEmp, "01")

		cSRA := RetSQLName("SRA")
		cSRJ := RetSQLName("SRJ")

		cSQL := " SELECT RA_MAT, RA_CLVL, RA_NOME, RA_ADMISSA, RA_DTFIMCT, RJ_DESC, RA_YSEMAIL "
		cSQL += " FROM " + cSRA + " SRA "
		cSQL += " INNER JOIN " + cSRJ + " SRJ "
		cSQL += " ON RA_CODFUNC = RJ_FUNCAO "
		cSQL += " WHERE RA_FILIAL = " + ValToSQL(xFilial("SRA"))
		cSQL += " AND RA_SITFOLH <> 'D' "
		cSQL += " AND RJ_YMNRAPZ = 'M' "
		cSQL += " AND (DATEDIFF(DAY, CONVERT(VARCHAR(8), GETDATE(), 112), RA_DTFIMCT) = 15 OR DATEDIFF(DAY, CONVERT(VARCHAR(8), GETDATE(), 112), RA_DTFIMCT) = 30) "		
		cSQL += " AND SRA.D_E_L_E_T_ = '' "
		cSQL += " AND RJ_FILIAL = " + ValToSQL(xFilial("SRJ"))
		cSQL += " AND SRJ.D_E_L_E_T_ = '' "
		cSQL += " ORDER BY RA_YSEMAIL, RA_DTFIMCT, RA_NOME "

		TcQuery cSQL New Alias (cQry)

		While !(cQry)->(Eof())

			If Empty(cMail) .Or. cMail <> cMailAux

				cHTML := fGetCab(cEmpName)

			EndIf

			cHTML	+= fGetItem()			

			cMail := (cQry)->RA_YSEMAIL

			(cQry)->(DbSkip())

			cMailAux := (cQry)->RA_YSEMAIL

			If cMail <> cMailAux

				cHTML	+= fGetRod()

				fSendMail(cEmp, (cQry)->RA_CLVL, AllTrim(cMail), cHTML)

			EndIf

		EndDo()

		(cQry)->(DbCloseArea())

		RpcClearEnv()

	Next

Return()


Static Function fGetCab(cEmpName)
	Local cRet := ""

	cRet := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
	cRet += '<html xmlns="http://www.w3.org/1999/xhtml">
	cRet += '<head>
	cRet += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	cRet += '<title>cabtitpag</title>
	cRet += '<style type="text/css">
	cRet += '<!--
	cRet += '.headClass {background-color: #D3D3D3;	color: #747474;	font: 12px Arial, Helvetica, sans-serif}
	cRet += '.headProd {background: #0c2c65;	color: #FFF; font: 12px Arial, Helvetica, sans-serif}
	cRet += '.style12  {background: #f6f6f6;	color: #747474;	font: 11px Arial, Helvetica, sans-serif}
	cRet += '.style123 {font face="Arial"; font-size: 12px; background: #f6f6f6;}
	cRet += '.cabtab {background: #eff4ff;	color: #1f3d71; font: 12px Arial, Helvetica, sans-serif}
	cRet += '.cabtab1 {background: #eff4ff;	border-top: 2px solid #FFF; border-right: 1px solid #ced9ec;	color: #1f3d71; font: 12px Arial, Helvetica, sans-serif }
	cRet += '.tottab {border:1px solid #0c2c65; background-color: #D3D3D3;	color: #0c2c65;	font: 12px Arial, Helvetica, sans-serif } 			
	cRet += '--> 
	cRet += '</style>
	cRet += '</head>
	cRet += '<body>

	cRet += '<table class="headProd" align="center" width="1200">
	cRet += '<tbody>
	cRet += '<tr>
	cRet += '<div align="left">
	cRet += '<th width="1200" scope="col">'+ cEmpName +' - Menores aprendizes com contrato a vencer nos pr�ximos dias </th>
	cRet += '</div>
	cRet += '</tr>
	cRet += '</tbody>
	cRet += '</table>

	cRet += '<table align="center" border="1" cellpadding="1" cellspacing="0" width="1200">
	cRet += '<tbody>	
	cRet += '<tr align=center>
	cRet += '<th class = "cabtab" width="60" scope="col"> Matr�cula </th>
	cRet += '<th class = "cabtab" width="60" scope="col"> Clase Valor </th>
	cRet += '<th class = "cabtab" width="200" scope="col"> Colaborador </th>
	cRet += '<th class = "cabtab" width="60" scope="col"> Dt. Admiss�o </th>
	cRet += '<th class = "cabtab" width="60" scope="col"> Dt. Enc. Cont. </th>	
	cRet += '<th class = "cabtab" width="200" scope="col"> Fun��o </th>	
	cRet += '</tr>
	cRet += '</tbody>
	cRet += '</table>	

	Return(cRet)


	Static Function fGetItem()
	Local cRet := ""

	cRet += '<table align="center" border="1" cellpadding="1" cellspacing="0" width="1200">
	cRet += '<tbody>
	cRet += '<tr align=center>
	cRet += '<td class="style12" width="60"scope="col">'+ (cQry)->RA_MAT +'</td>
	cRet += '<td class="style12" width="60"scope="col">'+ AllTrim((cQry)->RA_CLVL) +'</td>
	cRet += '<td class="style12" width="200"scope="col">'+ AllTrim((cQry)->RA_NOME) +'</td>
	cRet += '<td class="style12" width="60"scope="col">'+ dToC(sToD((cQry)->RA_ADMISSA)) +'</td>
	cRet += '<td class="style12" width="60"scope="col">'+ dToC(sToD((cQry)->RA_DTFIMCT)) +'</td>
	cRet += '<td class="style12" width="200"scope="col">'+ AllTrim((cQry)->RJ_DESC) +'</td>
	cRet += '</tr>
	cRet += '</tbody>
	cRet += '</table>	

	Return(cRet)


	Static Function fGetRod()
	Local cRet := ""

	cRet := '<table align="center" border="1" cellpadding="1" cellspacing="0" width="1200">
	cRet += '<tbody>
	cRet += '<tr>
	cRet += '<th class="tottab" scope="col" width="300"> E-mail enviado automaticamente pelo sistema Protheus (by BIAF074).</th>
	cRet += '</tr>
	cRet += '</tbody>
	cRet += '</table>
	cRet += "</body>
	cRet += "</html>

	Return(cRet)


	Static Function fSendMail(cEmp, cClvl, cMail, cHTML)
	Local cCopia := AllTrim(U_EmailWF('BIAF074', cEmp, cClvl))

	cMail += ";" + cCopia

	U_BIAEnvMail(,cMail, "Menores aprendizes com contrato a vencer", cHTML)

	Return()