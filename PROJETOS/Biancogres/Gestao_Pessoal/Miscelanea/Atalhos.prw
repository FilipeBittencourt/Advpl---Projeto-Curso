#include "rwmake.ch"
#Include "TopConn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ATALHOS          �Autor  � MADALENO   � Data �  28/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � EXECUTA AS FUNCOES PARA CHAMAR OS ATALHOS                  ���
�������������������������������������������������������������������������͹��
���Uso       � MP7                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION ATALHOS()

IF UPPER(ALLTRIM(FUNNAME())) == "MATA121" .OR. UPPER(ALLTRIM(FUNNAME())) == "MATA122"
	U_CAL_SALDO_PEDIDO()
ELSEIF UPPER(ALLTRIM(FUNNAME())) == "FINA050" .OR. UPPER(ALLTRIM(FUNNAME())) == "FINA750"
	U_INF_CODIGO()
ELSE
	U_POS_CLI()	
END IF

RETURN()