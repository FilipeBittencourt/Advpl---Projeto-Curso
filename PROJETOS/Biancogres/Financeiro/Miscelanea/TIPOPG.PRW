#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TIPOPG    � Autor � AP6 IDE            � Data �  04/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa que verifica o modelo utilizado no bordero e faz  ���
���          � correlacao com o layout do banco.                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TIPOPG


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


Private cMod:= "", cModBco:=""

cMod := SEA->EA_MODELO

	DO CASE
	   CASE cMod == "01"
	   		
	   		If SA2->A2_TIPCTA == "2"
	   			cModBco	:= "CP"
	   		Else
	   			cModBco	:= "CC"
	   		EndIf
	   		
	   CASE cMod == "05"
	   		cModBco	:= "CP"
	   CASE cMod == "11"
	   		cModBco	:= "CCS"
	   CASE cMod == "13"
	   		cModBco	:= "CCS"
	   CASE cMod == "30"
	   		cModBco	:= "COB"
	   CASE cMod == "31"
	   		cModBco	:= "COB"
	   CASE cMod == "03"
	   		cModBco	:= "DOC"
	   CASE cMod == "99"
	   		cModBco	:= "DUD"
	   CASE cMod == "41"
	   		cModBco	:= "TED"   		
	   CASE cMod == "42"
	   		cModBco	:= "TED"   		   		
	ENDCASE   		

Return(cModBco)