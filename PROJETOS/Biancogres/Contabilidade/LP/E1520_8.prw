#include "rwMake.ch"
#include "Topconn.ch"
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  � E1520_8        �Autor  � BRUNO MADALENO     � Data �  22/11/06   ���
�������������������������������������������������������������������������������͹��
���Desc.     � LANCAMENTO CONTABIL 520 003                                      ���
���          � VARIACAO CAMBIAL ATIVA COMISSAO           						���
�������������������������������������������������������������������������������͹��
���Uso       � AP 7                                                             ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
User Function E1520_8()
LOCAL NVALOR := 0
LOCAL VAL_DOL_B
LOCAL VAL_DOL_E

VAL_DOL_B := ROUND(SE1->E1_DECRESC * SE5->E5_TXMOEDA,2)  //ROUND(SE1->E1_VALOR * SE5->E5_TXMOEDA,2) //(XMOEDA(SE1->E1_VALOR,2,1,SE1->E1_BAIXA)   / 100 ) * SE1->E1_COMIS1
VAL_DOL_E := XMOEDA(SE1->E1_DECRESC,2,1,SE1->E1_EMISSAO) //XMOEDA(SE1->E1_DECRESC,2,1,SE1->E1_EMISSAO) //(XMOEDA(SE1->E1_VALOR,2,1,SE1->E1_EMISSAO) / 100 ) * SE1->E1_COMIS1

IF VAL_DOL_B < VAL_DOL_E // BAIXA ATIVA
	NVALOR := NOROUND(VAL_DOL_E - VAL_DOL_B,2)
END IF 

RETURN(NVALOR)