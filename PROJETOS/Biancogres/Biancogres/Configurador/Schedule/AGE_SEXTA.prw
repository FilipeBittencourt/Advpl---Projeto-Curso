#include "rwmake.Ch"
#include "topconn.ch"
#include "tbiconn.ch" 
/* 
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ���
����Programa  �AGE_DIARIO� Autor � MADALENO           � Data �  14/04/09   ����
��������������������������������������������������������������������������͹���
����Desc.     � ROTINA A SER EXECUTADO NO SCHEDULE PARA A GERACAO DOS      ����
����          � WORKFLOW                                                   ����
��������������������������������������������������������������������������͹���
����Uso       � AP8                                                        ����
��������������������������������������������������������������������������ͼ���
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
USER FUNCTION AGE_SEXTA()

// *****************************************************************************
// ************************** WORKFLOW DOS VENDEDORES **************************
// *****************************************************************************
ConOut("HORA: "+TIME()+" - GERANDO PRODUTOS COM MENOS DE 100 M2 NO ESTOQUE NA BIANCOGRES")
Startjob("U_WORK_ESTO","SCHEDULE",.T.,"01")
ConOut("HORA: "+TIME()+" - FIM PRODUTOS COM MENOS DE 100 M2 NO ESTOQUE NA BIANCOGRES")  

ConOut("HORA: "+TIME()+" - GERANDO PRODUTOS COM MENOS DE 100 M2 NO ESTOQUE NA INCESA")
Startjob("U_WORK_ESTO","SCHEDULE",.T.,"05")
ConOut("HORA: "+TIME()+" - FIM PRODUTOS COM MENOS DE 100 M2 NO ESTOQUE NA INCESA")

RETURN .T.