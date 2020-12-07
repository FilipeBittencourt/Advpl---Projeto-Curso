#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MA261LIN	� Autor � Ranisses A. Corona    � Data � 16/10/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida o preenchimento do campo de Localizacao Destino     ���
���          � e nao permite transferir produtos diferentes               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Transferencia Modelo II - MATA261                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA261LIN()

	Local cProd1	:= aCols[n,1] //Produto Origem
	Local cProd2	:= aCols[n,6] //Produto Destino
	Local cLote1	:= aCols[n,12]//Lote Origem
	Local cLote2	:= aCols[n,20]//Lote Destino
	Local cAlmox2	:= aCols[n,9] //Almoxarido Destino
	Local cRua2		:= aCols[n,10]//Rua Destino
	Local cConv1
	Local cConv2
	Local lRet := .T.

	If Alltrim(funname())=="MATA261"

		//�����������������������������������������������Ŀ
		//�Executa validacao referente Almoxarifado Comum �
		//�������������������������������������������������
		//Executa funcao de validacao com retorno imediato
		If !GdDeleted(n)
			If !U_fValProdComum(cProd2,cAlmox2,"MA261LIN","T") //Paramentros da Funcao Produto/Almoxarifado/NomeProgroma/TipoMovimento(C=Compra/T=Transferencia)
				lRet := .F.
				Return(lRet)
			EndIf
		EndIf

		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial()+cProd1,.t.)
		cConv1 := SB1->B1_CONV
		xFmto1 := SB1->B1_YFORMAT

		If (Substr(cProd1,1,7) <> Substr(cProd2,1,7) .and. Alltrim(SB1->B1_GRUPO) == "PA")

			//Permitir codigos de produtos diferentes apenas para a transferencia de produtos originados e para estoque de Amostra

			// Retirado em 10/01/13 por Marcos Alberto Soprani, pois mesmo na amostra n�o podem haver transferencias entre FATORes diferentes. Conversei com o Robert que concordou com o apresentado.
			// O Erro foi identificado durante o fechamento de estoque da Incesa do mes de dezembro de 2012. O documento que apresentou problema foi: ZERNAURPY
			//IF (ALLTRIM(aCols[n,5]) <> "P.DEVOL" .AND. SUBSTR(cProd1,9,1) == ' ' .AND. Alltrim(aCols[n,20]) <> 'AMT') .And. (ALLTRIM(aCols[n,5]) <> "AMT" .AND. SUBSTR(cProd1,9,1) == ' ' .AND. Alltrim(aCols[n,12]) <> 'AMT')

			// Esta regra retirada (abaixo) por Marcos Alberto Soprani em 27/12/12 em virtude do Bloqueio dos TM 004/504, foi incluida meste ponto para compementar esta fun��o
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial()+cProd2,.t.)
			cConv2 := SB1->B1_CONV
			xFmto2 := SB1->B1_YFORMAT
			//If cConv1 <> cConv2
			//	Msgbox("Fatores de convers�o dos produtos n�o podem ser diferentes!","MA261LIN","STOP")
			//	lRet := .F.
			//	Return(lRet)
			//Else
			//	Msgbox("Produto de Origem / Destino n�o podem ser diferentes!","MA261LIN","STOP")
			//	lRet := .F.
			//	Return(lRet)
			//EndIf
			If cConv1 <> cConv2 .or. xFmto1 <> xFmto2
				Msgbox("Inconsist�ncia entre o produto de Origem e de Destino: ambos devem possuir o mesmo fator de convers�o e o mesmo formato!","MA261LIN(1)","STOP")
				lRet := .F.
				Return(lRet)
			EndIf

			//ENDIF

			// Retirado por Marcos Alberto Soprani em 27/12/12 em virtude do Bloqueio dos TM 004/504. A rotina acima complementa a fun��o anterior
			//DbSelectArea("SB1")
			//DbSetOrder(1)
			//DbSeek(xFilial()+cProd2,.t.)
			//cConv2 := SB1->B1_CONV
			//IF cConv1 <> cConv2
			//	Msgbox("Fatores de convers�o dos produtos n�o podem ser diferentes!","MA261LIN","STOP")
			//	lRet := .F.
			//	Return(lRet)
			//ENDIF
		Else
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial()+cProd2,.t.)
			cConv2 := SB1->B1_CONV
			xFmto2 := SB1->B1_YFORMAT

		End

		If Empty(cRua2) .and. Alltrim(SB1->B1_GRUPO) == "PA" .and. SB1->B1_LOCALIZ == "S"
			Msgbox("Favor informar uma Rua Destino para o produto","MA261LIN(2)","STOP")
			lRet := .F.
			Return(lRet)
		End

		If Empty(cLote2) .and. Alltrim(SB1->B1_GRUPO) == "PA" .and. SB1->B1_RASTRO == "S"
			Msgbox("Favor informar o Lote de Destino para o produto","MA261LIN(3)","STOP")
			lRet := .F.
			Return(lRet)
		End

		IF DA261DATA <> DDATABASE
			MsgBox("Favor informar data correta","MA261LIN(4)","STOP")
			lRet := .F.
			Return(lRet)
		ENDIF

		IF !Empty(cLote1)
			DbSelectArea("ZZ9")
			DbSetOrder(1)
			IF DbSeek(xFilial("ZZ9")+cLote1+cProd1)
				lRet  := .T.
			ELSE
				MsgBox("Este Lote: "+ALLTRIM(cLote1)+" nao esta amarrado ao Produto: "+ALLTRIM(cProd1),"MA261LIN(5)","STOP")
				lRet  := .F.
				Return(lRet)
			ENDIF
		ENDIF

		IF !Empty(cLote2)
			DbSelectArea("ZZ9")
			DbSetOrder(1)
			IF DbSeek(xFilial("ZZ9")+cLote2+cProd2)
				lRet  := .T.
			ELSE
				MsgBox("Este Lote: "+ALLTRIM(cLote2)+" nao esta amarrado ao Produto: "+ALLTRIM(cProd2),"MA261LIN(6)","STOP")
				lRet  := .F.
				Return(lRet)
			ENDIF
		ENDIF

		// Implementado em 04/12/15 para atender a OS effettivo 1476-15
		If GetMV('MV_RASTRO') == "S"
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+cProd2,.t.))
			If SB1->B1_RASTRO == "L"
				If Empty(cLote2)
					MsgBox("Favor verificar o preenchimento do campo LOTE DESTINO, pois n�o pode ficar em branco","MA261LIN(7)","STOP")
					lRet  := .F.
					Return(lRet)
				EndIf
			EndIf
		EndIf

		// Melhoria implementada em 29/01/16 por Marcos Alberto Soprani em atendimento a OS 0049-16
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+cProd1,.t.))
		ghCtaOri := SB1->B1_CONTA
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+cProd2,.t.))
		ghCtaDes := SB1->B1_CONTA
		If ghCtaOri <> ghCtaDes .And. !U_VALOPER("052") //Ajuste efetuado para libera��o. Ticket 8909
			MsgBox("Favor reportar-se � contabilidade para apresentar a justificativa desta movimenta��o, pois ela n�o � permitida em virtude das contas cont�beis Origem e Destino serem diferentes.", "MA261LIN(8) - OPER 052", "STOP")
			lRet  := .F.
			Return(lRet)
		EndIf

	EndIf

Return(lRet)
