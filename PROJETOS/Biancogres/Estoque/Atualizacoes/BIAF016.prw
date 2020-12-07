#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
|------------------------------------------------------------|
| Fun��o:	| BIAF016																					 |
| Autor:	|	Tiago Rossini Coradini - Facile Sistemas				 |
| Data:		| 27/04/15																				 |
|------------------------------------------------------------|
| Desc.:	|	Rotina para calculo do consumo mensal de produtos|
| 				|	comuns						 															 |
|------------------------------------------------------------|
| OS:			|	N/A - Usu�rio: Wanisay William 									 |
|------------------------------------------------------------|
*/

User Function BIAF016()
Local oParam := TParBIAF016():New()
Local oConPrdCom := TConsumoProdutoComum():New()

 	If cEmpAnt $ "05/14"
		
		If oParam:Box()
			
			U_BIAMsgRun("Calculando consumo m�nsal...", "Aguarde!", {|| oConPrdCom:Get(oParam) })
			
			U_BIAMsgRun("Atualizando consumo m�nsal...", "Aguarde!", {|| oConPrdCom:Set() })
						
			MsgInfo("C�lculo do consumo m�nsal executado com sucesso!")
			
		EndIf
	
	Else	
		MsgInfo("Rotina n�o habilitada para esta empresa!")
	EndIf

Return()