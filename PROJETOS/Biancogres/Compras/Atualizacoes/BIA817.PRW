#include "rwMake.ch"
#include "Topconn.ch"
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  � BIA817         �Autor  � Ranisses A. Corona � Data �  25/08/09   ���
�������������������������������������������������������������������������������͹��
���Desc.     � Bloqueia Produto na digitacao da SC e PC                         ���
�������������������������������������������������������������������������������͹��
���Uso       � Compras                                                          ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
User Function BIA817()
Local cCod	:= SB1->B1_COD
                 
//Procura o Indicador de Produto
DbSelectArea("SBZ")
DbSetOrder(1)
DbSeek(xFilial("SBZ")+cCod)

If SBZ->BZ_YBLSCPC == '1'
	cCod	:= ""
	MsgBox("BIA817 - O produto "+Alltrim(SB1->B1_COD)+" est� bloqueado para uso em Solicita��es e Pedidos. Favor verificar com o Almoxarifado.","Aten��o","INFO")
	AutoGrLog("BIA817 - O produto "+Alltrim(SB1->B1_COD)+" est� bloqueado para uso em Solicita��es e Pedidos. Favor verificar com o Almoxarifado.")
EndIf

Return(cCod)
