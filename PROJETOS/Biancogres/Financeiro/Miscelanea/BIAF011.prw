#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
|------------------------------------------------------------|
| Fun��o:	| BIAF011																					 |
| Autor:	|	Tiago Rossini Coradini - Facile Sistemas				 |
| Data:		| 03/11/14																				 |
|------------------------------------------------------------|
| Desc.:	|	Verifica se o t�tulo est� em cart�rio  				   |
|------------------------------------------------------------|
| OS:			|	1814-13 - Usu�rio: Clebes Jose Andre  		 			 |
|------------------------------------------------------------|
*/

User Function BIAF011(cPrefix, cNumTit, cParc, cTipo)
Local aArea := GetArea()
Local lRet := .T.
Local cSQL := ""
Local Qry := ""
Local cFilOri := ""

	If cEmpAnt == "01"
		cFilOri := "BI"
	ElseIf cEmpAnt == "05"
		cFilOri := "IN"
	ElseIf cEmpAnt == "07"
		cFilOri := "LM"
	EndIf

	Qry := GetNextAlias()
	
	cSQL := " SELECT ACG_TITULO "
	cSQL += " FROM ACG010 "
	cSQL += " WHERE ACG_FILIAL = '01' "
	cSQL += " AND ACG_PREFIX = "+ ValToSQL(cPrefix)
	cSQL += " AND ACG_TITULO = "+ ValToSQL(cNumTit)
	cSQL += " AND ACG_PARCEL = "+ ValToSQL(cParc)
	cSQL += " AND ACG_TIPO = "+ ValToSQL(cTipo)
	cSQL += " AND ACG_FILORI = "+ ValToSQL(cFilOri)
	cSQL += " AND ACG_YSTAT = '3' "
	cSQL += " AND D_E_L_E_T_ = '' "

			
	TcQuery cSQL New Alias (Qry)
	  		
	If !Empty((Qry)->ACG_TITULO)
		lRet := .F.
	EndIF

	(Qry)->(DbCloseArea())
	
	RestArea(aArea)
	
Return(lRet)