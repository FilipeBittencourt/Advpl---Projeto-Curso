#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
���������������������������������������������������������������������������
���������������������������������������������������������������������������
�����������������������������������������������������������������������ͻ��
���Programa  � BIA849 �Autor  � Ranisses A. Corona � Data �  17/02/12   ���
�����������������������������������������������������������������������͹��
���Descr.    � Verifica se o pedido original ja foi utilizado           ���
�����������������������������������������������������������������������͹��
���Uso       � SigaFat - MATA410                                        ���
�����������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������
���������������������������������������������������������������������������
*/
USER FUNCTION BIA849()
Local lRet := .T.
Local cSql := ""


//Executa verificacao somente na Empresa LM
If cEmpAnt == "07" .And. !Empty(Alltrim(M->C5_YPEDORI))

	cSql := "SELECT COUNT(*) COUNT FROM SC5070 WHERE C5_YPEDORI = '"+M->C5_YPEDORI+"' AND C5_YEMPPED = '"+cEmpAnt+"' AND C5_YLINHA = '"+M->C5_YLINHA+"' AND D_E_L_E_T_ = '' "
	If chkfile("_RAN")
		dbSelectArea("_RAN")
		dbCloseArea()
	EndIf
	TCQUERY CSQL ALIAS "_RAN" NEW
	
	If _RAN->COUNT > 1 //Sempre deve retornar 1
		lRet 	:= .F.		
		MsgBox("O Pedido Original "+M->C5_YPEDORI+" j� foi utilizado em outros pedidos. Favor verificar!","BIA849","ALERT")
	EndIf

EndIf

Return(lRet)