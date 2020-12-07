#include "rwmake.ch"
#include "topconn.ch"
#include "Ap5Mail.ch"
#include "tbiconn.ch"

User Function BIA422A()
/*
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � BIA422A    � Autor � Ranisses A. Corona    � Data � 02.12.08 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Analisa o credito de cliente de cada romaneio em aberto      ���
���          � Funcao utilizada para no schedule para chamar o fonte princ. ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Interpretador xBase                                          ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
ConOut("HORA: "+TIME()+" - INICIANDO PROCESSO BIA422 - BIANCOGRES")
//Startjob("U_BIA422","SCHEDULE",.T.,"01")        
Startjob("U_BIA422","WANISAY",.T.,"01")        
ConOut("HORA: "+TIME()+" - FINALIZANDO PROCESSO BIA422 - BIANCOGRES")

ConOut("HORA: "+TIME()+" - INICIANDO PROCESSO BIA422 - INCESA")
//Startjob("U_BIA422","SCHEDULE",.T.,"05")
Startjob("U_BIA422","WANISAY",.T.,"05")
ConOut("HORA: "+TIME()+" - FINALIZANDO PROCESSO BIA422 - INCESA")

//ConOut("HORA: "+TIME()+" - INICIANDO PROCESSO BIA442 - LM")
//Startjob("U_BIA422","SCHEDULE",.T.,"07")
//ConOut("HORA: "+TIME()+" - FINALIZANDO PROCESSO BIA442 - LM")

RETURN .T.