#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���PROGRAMA  � ATU_CON_CONT   �AUTOR  � BRUNO MADALENO     � DATA �  29/10/08   ���
�������������������������������������������������������������������������������͹��
���DESC.     � GATILHO PARA O PREENCHIMENTO DA CONTA CONTABIL NO CADASTRO DE    ���
���          �	FORNECEDOR                                                      ���
�������������������������������������������������������������������������������͹��
���USO       � AP 8                                                             ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
USER FUNCTION ATU_CON_CONT()
CONTA_CONTABIL := ""

IF CEMPANT == "02"                           
	CSQL := "SELECT SUBSTRING(MAX(CT1_CONTA),6,4) AS MAXIMO FROM CT1020 "
	CSQL += "WHERE SUBSTRING(CT1_CONTA,1,5) = '21101' "

	IF CHKFILE("CTRAB")
		DBSELECTAREA("CTRAB")
		DBCLOSEAREA()
	ENDIF
	TCQUERY CSQL ALIAS "CTRAB" NEW 	

	CONTA_CONTABIL  := "21101"+ SOMA1(CTRAB->MAXIMO)
ELSE
	CONTA_CONTABIL := "21102001"+M->A2_COD
END IF


RETURN(CONTA_CONTABIL)