#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH' 
#INCLUDE "RWMAKE.CH" 
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���PROGRAMA  � LIB_CONTRATO   �AUTOR  � BRUNO MADALENO     � DATA �  26/09/08   ���
�������������������������������������������������������������������������������͹��
���DESC.     � ROTINA PARA LIBERACAO DO CONTRATO.                               ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���USO       � MP8 - R4                                                         ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
USER FUNCTION LIB_CONTRA()
Local aArea, nrec   

PERGUNTE("LIB_CONTRA", .T.)

aArea:=GetArea()
DbSelectArea("PROFALIAS") 
nrec := Recno()
DbSetOrder(1)

If DbSeek(Padr(Alltrim(cusername),15)+"LIB_CONTRA"+"MBRWTOPFIL"+"SC3")
   	Reclock("PROFALIAS",.F.)
Else                       
	Reclock("PROFALIAS",.T.)
	PROFALIAS->P_NAME := Alltrim(cusername)
	PROFALIAS->P_PROG := "LIB_CONTRA"
	PROFALIAS->P_TASK := "MBRWTOPFIL"
	PROFALIAS->P_TYPE := "SC3"
EndIf	      

IF ALLTRIM(STR(MV_PAR01)) = "1"
	PROFALIAS->P_DEFS:=	"C3_NUM >= '09' AND C3_MSBLQL = '1' "
ELSE  
	PROFALIAS->P_DEFS:=	"C3_NUM >= '09' "
ENDIF

MsUnlock()     
DbGoto(nrec)
RestArea(aArea)
MATA125()
Set filter to

RETURN