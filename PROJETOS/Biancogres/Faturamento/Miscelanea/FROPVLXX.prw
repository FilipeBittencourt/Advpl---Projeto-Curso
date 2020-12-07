#include "PROTHEUS.CH"        
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FROPVLXX	�Autor  �Fernando Rocha      � Data � 18/02/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacoes para campos		                              ���
�������������������������������������������������������������������������͹��
���Uso       � BIANCOGRES - reservas									  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
    
//VALIDACAO DO CAMPO C5_YSUBTP
User Function FROPVL01(_cSubTp)
Local lRet := .T.

lRet := EXISTCPO("SX5","DJ"+_cSubTp)

If lRet
	
	If !(AllTrim(FunName()) $ GetNewPar("FA_XPEDRPC","BFATRT01###FCOMRT01###BFVCXPED###FCOMXPED###TESTEF1###RPC"))

		If !Empty(CREPATU)
			lRet := Alltrim(_cSubTp) $ GetNewPar("MV_YSUBTP","")
		Else
			lRet := .T.
		EndIf
	EndIf

EndIf

return(lRet)

