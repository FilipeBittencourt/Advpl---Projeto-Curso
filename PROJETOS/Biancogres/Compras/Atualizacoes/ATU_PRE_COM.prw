#include "rwmake.ch"
#include "topconn.ch"
/*
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o   �ATU_PRE_COM�Autor  � MADALENO              � Data � 06/11/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o� GATILHO PARA A VALIDACAO E O PREENCHIMENTO DA AMARRACAO     ���
���         � DO PRODUTO PELO FORNECEDOR                                  ���
��������������������������������������������������������������������� ���Ĵ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/

USER FUNCTION ATU_PRE_COM()
LOCAL CSQL := ""
LOCAL sPOS := ""
LOCAL sPRODUTO := ""
LOCAL nPRECO

sPOS := aScan(aHeader,{|x| x[2]=="C7_PRODUTO"})
sPRODUTO := ACOLS[N,sPOS]

sPOS := aScan(aHeader,{|x| x[2]=="C7_PRECO  "})
nPRECO := ACOLS[N,sPOS]

CSQL := "SELECT A5_YPRECO, A5_MOE_US FROM SA5010 "
CSQL += "WHERE 	A5_FORNECE = '"+CA120FORN+"'  AND "
CSQL += "		A5_PRODUTO = '"+sPRODUTO+"' AND "
CSQL += "		D_E_L_E_T_ = '' "
If chkfile("c_PRO_FORN")
	dbSelectArea("c_PRO_FORN")
	dbCloseArea()
EndIf
TCQUERY CSQL ALIAS "c_PRO_FORN" NEW

IF ! c_PRO_FORN->(EOF())
	IF c_PRO_FORN->A5_YPRECO <> 0
		MSGBOX("PRECO COM AMARRA��O","ALERTA", "INFO")
		IF c_PRO_FORN->A5_MOE_US = "US$"
			nPRECO := xMoeda(c_PRO_FORN->A5_YPRECO,2,1,ddatabase)
		ELSE
			nPRECO := c_PRO_FORN->A5_YPRECO
		ENDIF
	ENDIF	
ENDIF

RETURN(nPRECO)