#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} BIAJOB330
@author Marcos Alberto Soprani
@since 31/07/18
@version 1.0
@description Rotina autom�tica Rec�lculo Custo M�dio MATA330
@type function
/*/

User Function BIAJOB330()

	Local lCPParte  := .F. //-- Define que n�o ser� processado o custo em partes
	Local lBat      := .T. //-- Define que a rotina ser� executada em Batch
	Local aListaFil := {} //-- Carrega Lista com as Filiais a serem processadas
	Local cCodFil   := '' //-- C�digo da Filial a ser processada 
	Local cNomFil   := '' //-- Nome da Filial a ser processada
	Local cCGC      := '' //-- CGC da filial a ser processada
	Local aParAuto  := {} //-- Carrega a lista com os 21 par�metros
	Local x

	msEmprs := U_BAGtEmpr("01_05")

	For x := 1 to Len(msEmprs)

		PREPARE ENVIRONMENT EMPRESA msEmprs[x,1] FILIAL msEmprs[x,2] MODULO "EST" TABLES "AF9","SB1","SB2","SB3","SB8","SB9","SBD","SBF","SBJ","SBK","SC2","SC5","SC6","SD1","SD2","SD3","SD4","SD5","SD8","SDB","SDC","SF1","SF2","SF4","SF5","SG1","SI1","SI2","SI3","SI5","SI6","SI7","SM2","ZAX","SAH","SM0","STL"

		Conout("BIAJOB330 - In�cio da execu��o...")

		If Day(dDataBase) >= 10  

			aParAuto  := { dDataBase,;
			2,;
			2,;
			1,;
			0,;
			2,;
			"",;
			"ZZZZZZZZZZZZZZZ",;
			1,;
			3,;
			1,;
			3,;
			2,;
			3,;
			1,;
			1,;
			2,;
			1,;
			1,;
			2,;
			2 }

			//-- Adiciona filial a ser processada
			dbSelectArea("SM0")
			dbSeek(cEmpAnt)
			While ! Eof() .and. SM0->M0_CODIGO == cEmpAnt 

				cCodFil := SM0->M0_CODFIL
				cNomFil := SM0->M0_FILIAL
				cCGC    := SM0->M0_CGC

				//-- Somente adiciona a Filial 01 e Filial 02
				If cCodFil == "01"
					//-- Adiciona a filial na lista de filiais a serem processadas
					Aadd(aListaFil,{.T.,cCodFil,cNomFil,cCGC,.F.,})
				EndIf 

				dbSkip()

			End

			//-- Executa a rotina de rec�lculo do custo m�dio
			MATA330(lBat, aListaFil, lCPParte, aParAuto)

		Else

			ConOut("BIAJOB330 - Informa��o: do dia 01 a 09 de cada�s o processamento n�o � realizado. Per�odo de Fechamento do Custo!!!")

		EndIf

		ConOut("BIAJOB330 - T�rmino da execu��o...")

		RESET ENVIRONMENT

	Next x

Return

User Function BJ330bat()

	STARTJOB("U_BIAJOB330",GetEnvServer(),.F.,cEmpAnt,cFilAnt)

Return
