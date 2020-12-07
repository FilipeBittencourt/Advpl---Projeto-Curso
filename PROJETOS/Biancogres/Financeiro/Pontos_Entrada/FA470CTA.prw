/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA470CTA  �Autor  �Ihorran Milholi     � Data �  27/10/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para concilia��o bancaria automatica       ���
���          �Implementado para confrontar o codigo, agencia e conta do   ���
���          �banco lido no extrato com o cadastro no sistema			  ���
�������������������������������������������������������������������������͹��
���Uso       �FINA470                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA470CTA()

//Recupera o parametro contenco o banco/agencia/conta corrente      
aRet := Paramixb

If AllTrim(aRet[2]) == '3511' .and. AllTrim(aRet[3]) == '0000000105996'
	aRet[2]	:= AllTrim(Paramixb[2])
	aRet[3] := '10.599-6'
ELSEIf AllTrim(aRet[2]) == '3431' .and. AllTrim(aRet[3]) == '000000550973'
	aRet[2]	:= AllTrim(Paramixb[2]) + "2"
	aRet[3] := '55.097-3'
ELSEIf AllTrim(aRet[2]) == '3431' .and. AllTrim(aRet[3]) == '00000055099X'
	aRet[2]	:= AllTrim(Paramixb[2]) + "2"
	aRet[3] := '55.099-X'
EndIf

Return(aRet)