/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MT120OK  � Autor �                       � Data � 05/04/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valida digitacao no Pedido de Compras.                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �SIGACOM                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION MT120OK
LOCAL nPos := 0
Local _aArea	:=	GetArea()
Local oVldPedCom := TVldPedCom():New()

FOR nPos := 1 to Len(aCols)
	IF !GdDeleted(nPos)
		IF "NOVO" $ GdFieldGet("C7_PRODUTO",nPos)
			MSGINFO('Existem produtos com cadastro incompleto neste Pedido. Por favor solicite ao Almoxarifado, a conclus�o deste cadastro.')
			RestArea(_aArea)
			RETURN .F.
		ENDIF
	ENDIF
NEXT nPos

	// Inicio - Altera��o Facile - Tiago Rossini Coradini - 15/09/14	
	// Altera��o Facile - Tiago Rossini Coradini - 28/07/15 - N�o validar tipo de frete quando a origem � o SIGAEIC
	If FunName() = 'EICPO400' .And. SubStr(cTpFrete, 1, 1) <> "F"
		cTpFrete := "F-FOB"
	Else		
			
		If !SubStr(cTpFrete, 1, 1) $ "C/F/T/S"
			MsgInfo("Aten��o, tipo de frete n�o informado, favor verificar a aba 'Frete/Despesas'!")
			RestArea(_aArea)
			Return(.F.)
		EndIf
		
	EndIf	
	// Final - Altera��o Facile - Tiago Rossini Coradini - 15/09/14

	// Classe para valida��o do pedido de compra
	If !oVldPedCom:Validate()
		RestArea(_aArea)
		Return(.F.)
	EndIf	


	FOR nPos := 1 to Len(aCols)
		IF !GdDeleted(nPos)
			IF !Empty(GdFieldGet("C7_CONTA",nPos)) .And. SUBSTR(GdFieldGet("C7_CONTA",nPos),1,1) == '6' .And. !Empty(GdFieldGet("C7_CLVL",nPos))
				DbSelectArea("CTH")
				CTH->(DbSetOrder(1))
				If CTH->(DbSeek(xFilial("CTH")+GdFieldGet("C7_CLVL",nPos))) .And. CTH->CTH_YATRIB == 'C' .And. GdFieldGet("C7_YAPLIC",nPos) $ " _0"
					MSGINFO('Existem produtos com classe de valor que n�o permite que a aplica��o seja em branco ou zero!')
					RestArea(_aArea)			
					RETURN .F.				
				EndIf
			ENDIF
			If !Empty(GdFieldGet("C7_CONTA",nPos)) .And. !Empty(GdFieldGet("C7_CLVL",nPos))
				If U_BFG81VCL(GdFieldGet("C7_CLVL",nPos)) .And. U_BFG81VCO(GdFieldGet("C7_CONTA",nPos))
					If Empty(GdFieldGet("C7_YDRIVER",nPos))
						MsgStop("A conta e a classe de valor selecionadas exigem que o driver seja informado! Linha: " + Alltrim(Str(nPos)))
						RestArea(_aArea)
						Return .F.
					EndIF
				EndIf			
			EndIf
		ENDIF
	NEXT nPos


RestArea(_aArea)
RETURN .T.