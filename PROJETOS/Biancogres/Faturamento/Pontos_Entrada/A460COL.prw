#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ATU_CHEQUE�Autor  �    MADALENO        � Data �  15/12/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � ponto de entrada para incluir campo na liquyidacao         ���
���          �                                                         	  ���
�������������������������������������������������������������������������͹��
���Uso       � FINANCEIRO  ( LIQUIDA��O DE TITULOS      )                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                      
User Function A460COL()

Aadd(aHeader,{"STR. CHEQUE", "E1_YCODCHE", "@!"              , 034, 0,"u_fLeStrChq()"                    , "�", "C", "SE1"})

RETURN