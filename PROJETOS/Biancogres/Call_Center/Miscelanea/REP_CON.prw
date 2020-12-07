#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
/* 
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ���
����Programa  � REP_CON  �Autor  � MADALENO           � Data �  12/11/07   ����
��������������������������������������������������������������������������͹���
����Desc.     � REPLICA OS CLIENTES PARA A TABELA DE CONTATO NO CALL CENTER����
����          �                                                            ����
��������������������������������������������������������������������������͹���
����Uso       � AP8                                                        ����
��������������������������������������������������������������������������ͼ���
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

USER FUNCTION REP_CON()

IF CHKFILE("_SA1")
	DBSELECTAREA("_SA1")
	DBCLOSEAREA()
ENDIF

BeginSql Alias "_SA1"

	SELECT A1_COD, A1_NREDUZ, A1_TEL, A1_EMAIL 
	FROM %Table:SA1% SA1
	WHERE 	A1_LOJA = '01' AND 
			SA1.%NotDel%

EndSql

DBSELECTAREA("SU5")
DO WHILE ! _SA1->(EOF())
	
	RecLock("SU5",.T.)
	SU5->U5_FILIAL	:= XFILIAL("SA1")
	SU5->U5_CODCONT := _SA1->A1_COD
	SU5->U5_CONTAT	:= _SA1->A1_NREDUZ
	SU5->U5_FONE    := _SA1->A1_TEL
	SU5->U5_EMAIL	  := _SA1->A1_EMAIL
	MsUnLock()

	_SA1->(DBSKIP())
END DO
RETURN