#include "rwMake.ch"
#include "Topconn.ch"
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  � E1520_1        �Autor  � BRUNO MADALENO     � Data �  22/11/06   ���
�������������������������������������������������������������������������������͹��
���Desc.     � LANCAMENTO CONTABIL 520 003                                      ���
���          � VARIACAO CAMBIAL ATIVA COMISSAO            						���
�������������������������������������������������������������������������������͹��
���Uso       � AP 7                                                             ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
User Function E1520_1()
LOCAL NVALOR := 0
LOCAL VAL_DOL_B
LOCAL VAL_DOL_E

VAL_DOL_B := ROUND(SE1->E1_VALOR * SE5->E5_TXMOEDA,2) //xMoeda(SE1->E1_VALOR,2,1,SE1->E1_BAIXA)
VAL_DOL_E := xMoeda(SE1->E1_VALOR,2,1,SE1->E1_EMISSAO)

IF VAL_DOL_B < VAL_DOL_E // BAIXA PASSIVA
	NVALOR := VAL_DOL_E - VAL_DOL_B
END IF

RETURN(NVALOR)