#include "rwMake.ch"
#include "Topconn.ch"
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  � PLAN_CON_REF   �Autor  � BRUNO MADALENO     � Data �  09/04/09   ���
�������������������������������������������������������������������������������͹��
���Desc.     � GRAVA O PLANO DE CONTA REFERENCIAL                               ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Uso       � MP8 - R4                                                         ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/

USER FUNCTION PLAN_CON_REF()

PRIVATE ENTER	:= CHR(13)+CHR(10)
PRIVATE CSQL := ""

CSQL := "SELECT * FROM CT1010 " + ENTER
CSQL += "WHERE	SUBSTRING(CT1_CONTA,1,8) = '21102001' AND " + ENTER
CSQL += "		LEN(CT1_CONTA) >= 6 AND D_E_L_E_T_ = '' ORDER BY CT1_CONTA" + ENTER
		
IF CHKFILE("_TRAB")
	DBSELECTAREA("_TRAB")
	DBCLOSEAREA()
ENDIF
TCQUERY CSQL ALIAS "_TRAB" NEW


DO WHILE ! _TRAB->(EOF())

	RECLOCK("CVD",.T.)	
	CVD->CVD_FILIAL	:= XFILIAL("CVD")
	CVD->CVD_ENTREF	:= "10"
	CVD->CVD_CODPLA	:= "001"
	CVD->CVD_CONTA	:= _TRAB->CT1_CONTA
	CVD->CVD_CTAREF	:= "2.01.01.01.00"
	
	MSUNLOCK()
	
	_TRAB->(DBSKIP())		
END DO

RETURN