#include "rwmake.ch"
#include "topconn.ch"
#include "Ap5Mail.ch"
#include "tbiconn.ch"

/*
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
��������������������������������������������������������������������������������Ŀ��
���Fun��o    � BIA494A    � Autor � Wanisay William       � Data � 03.05.12      ���
��������������������������������������������������������������������������������Ĵ��
���Descri��o � Prepara envio de e-mail para NF da LM sem saida na empresa origem ���
��������������������������������������������������������������������������������Ĵ��
��� Uso      � Interpretador xBase                                               ���
���������������������������������������������������������������������������������ı�
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
*/
User Function BIA494A

ConOut("HORA: "+TIME()+" - INICIANDO PROCESSO BIA494 - BIANCOGRES")
Startjob("U_BIA494","SCHEDULE",.T.,"01")
ConOut("HORA: "+TIME()+" - FINALIZANDO PROCESSO BIA494 - BIANCOGRES")

ConOut("HORA: "+TIME()+" - INICIANDO PROCESSO BIA494 - INCESA")
Startjob("U_BIA494","SCHEDULE",.T.,"05")
ConOut("HORA: "+TIME()+" - FINALIZANDO PROCESSO BIA494 - INCESA")

ConOut("HORA: "+TIME()+" - INICIANDO PROCESSO BIA494 - MUNDI")
Startjob("U_BIA494","SCHEDULE",.T.,"13")
ConOut("HORA: "+TIME()+" - FINALIZANDO PROCESSO BIA494 - MUNDI")

RETURN .T.