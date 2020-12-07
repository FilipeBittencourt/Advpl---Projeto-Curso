#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120ISC  �Autor  �FELIPE ZAGO         � Data �  07/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PONTO DE ENTRADA NA IMPORTA��O DAS SCS PARA A GRID DAS     ���
���          � ORDENS DE COMPRA                                           ���
�������������������������������������������������������������������������͹��
���Uso       � PROTHEUS 10                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/       
user function MT120ISC
	local nIdx   := 0
	local aMsg   := {}
	local cMsg   := ""

	if !empty(SC1->C1_YMSG)
		aadd(aMsg, "Mensagem")
	endif	
	if !empty(SC1->C1_YANX)
		aadd(aMsg, "Anexo")
	endif
	for nIdx:= 1 to len(aMsg)
		cMsg += aMsg[nIdx]
		if nIdx < len(aMsg)
			cMsg += "/"
		endif
	next nIdx

	
	GDFieldPut('C7_YMSG', cMsg, n)	

	GDFieldPut('C7_RATEIO','2', n)	
	
	GDFieldPut('C7_LOCAL',SC1->C1_LOCAL, n)
	
	GDFieldPut('C7_YCONTR', SC1->C1_YCONTR, n)
	GDFieldPut('C7_YSUBITE', SC1->C1_YSUBITE, n)
	
return