#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fLeStrChq �Autor  �Ranisses A. Corona  � Data �  11/25/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Le a string gerada pela leitora de cheque e alimenta		  ���
���          �  os principais campos do aCols com os dados coletados      ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function fLeStrChq()
aCols[N, ascan(aHeader,{|a| alltrim(a[2])="E1_BCOCHQ"}) ] := substr(M->E1_YCODCHE,2,3)  // TAMANHO DO CAMPO  E 34 CARACTERES.
aCols[N, ascan(aHeader,{|a| alltrim(a[2])="E1_AGECHQ"}) ] := substr(M->E1_YCODCHE,5,4)
aCols[N, ascan(aHeader,{|a| alltrim(a[2])="E1_CTACHQ"}) ] := substr(M->E1_YCODCHE,27,6)
aCols[N, ascan(aHeader,{|a| alltrim(a[2])="E1_NUM"}) ]    := substr(M->E1_YCODCHE,14,6)
Return .T.