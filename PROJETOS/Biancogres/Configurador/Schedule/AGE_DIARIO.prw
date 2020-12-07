#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH" 
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
USER FUNCTION AGE_DIARIO()

//DESATIVADO POIS EST� SENDO EXCUTADO DIRETO NO SCHEDULE
// *****************************************************************************
// ************************** WORKFLOW DOS VENDEDORES **************************
// *****************************************************************************
//ConOut("HORA: "+TIME()+" - GERANDO WORKFLOW DOS VENDEDORES NA BIANCOGRES")
//Startjob("U_WORK_VEND","SCHEDULE",.T.,"01")
//ConOut("HORA: "+TIME()+" - FIM DO WORKFLOW DOS VENDEDORES NA BIANCOGRES")
//ConOut("HORA: "+TIME()+" - GERANDO WORKFLOW DOS VENDEDORES NA INCESA")
//Startjob("U_WORK_VEND","SCHEDULE",.T.,"05")
//ConOut("HORA: "+TIME()+" - FIM DO WORKFLOW DOS VENDEDORES NA INCESA")

// *****************************************************************************
// *********************** WORKFLOW DOS CLIENTES NO DIA  ***********************
// *****************************************************************************
//Retirado a pedido do Claudeir no dia 11/06/12
//ConOut("HORA: "+TIME()+" - GERANDO WORKFLOW DOS CLIENTES NA BIANCOGRES")
//Startjob("U_WORK_CLI_ROMA","SCHEDULE",.T.,"01")
//ConOut("HORA: "+TIME()+" - FIM DO WORKFLOW DOS CLIENTES NA BIANCOGRES")  

//ConOut("HORA: "+TIME()+" - GERANDO WORKFLOW DOS CLIENTES NA INCESA")
//Startjob("U_WORK_CLI_ROMA","SCHEDULE",.T.,"05")
//ConOut("HORA: "+TIME()+" - FIM DO WORKFLOW DOS CLIENTES NA INCESA")

// *****************************************************************************
// ************************** WORKFLOW DOS CLIENTES SPEED **********************
// *****************************************************************************
ConOut("HORA: "+TIME()+" - GERANDO WORKFLOW DOS CLIENTES SPEED NA BIANCOGRES")
Startjob("U_CLI_SPEED","SCHEDULE",.T.,"01")
ConOut("HORA: "+TIME()+" - FIM DO WORKFLOW DOS CLIENTES SPEED NA BIANCOGRES")  

ConOut("HORA: "+TIME()+" - GERANDO WORKFLOW DOS CLIENTES SPEED NA INCESA")
Startjob("U_CLI_SPEED","SCHEDULE",.T.,"05")
ConOut("HORA: "+TIME()+" - FIM DO WORKFLOW DOS CLIENTES SPEED NA INCESA")

// *****************************************************************************
// *********************** WORKFLOW DOS FORNECEDORES SPEED *********************
// *****************************************************************************
ConOut("HORA: "+TIME()+" - GERANDO WORKFLOW DOS FORNECEDORES SPEED NA BIANCOGRES")
Startjob("U_FOR_SPEED","SCHEDULE",.T.,"01")
ConOut("HORA: "+TIME()+" - FIM DO WORKFLOW DOS FORNECEDORES SPEED NA BIANCOGRES")  

ConOut("HORA: "+TIME()+" - GERANDO WORKFLOW DOS FORNECEDORES SPEED NA INCESA")
Startjob("U_FOR_SPEED","SCHEDULE",.T.,"05")
ConOut("HORA: "+TIME()+" - FIM DO WORKFLOW DOS FORNECEDORES SPEED NA INCESA")


// *****************************************************************************
// *********************** WORKFLOW ALTERACAO DAS ESTRUTURAS *******************
// *****************************************************************************
ConOut("HORA: "+TIME()+" - GERANDO WORKFLOW DAS ALTERA��ES DAS ESTRUTURAS DE PRODUTO")
Startjob("U_ALT_SG1","SCHEDULE",.T.,"01")
ConOut("HORA: "+TIME()+" - FIM DO WORKFLOW DAS ALTERA��ES DAS ESTRUTURAS DE PRODUTO")  


// *****************************************************************************
// *********************** WORKFLOW DAS PRODUCOES DE PRODUTO ********************
// *****************************************************************************
ConOut("HORA: "+TIME()+" - GERANDO WORKFLOW DAS PRODUCOES REALIZADAS NA BIANCOGRES")
Startjob("U_W_MOV_INT","SCHEDULE",.T.,"01")
ConOut("HORA: "+TIME()+" - FIM DO WORKFLOW DAS PRODUCOES REALIZADAS NA BIANCOGRES")  

ConOut("HORA: "+TIME()+" - GERANDO WORKFLOW DAS PRODUCOES REALIZADAS NA INCESA")
Startjob("U_W_MOV_INT","SCHEDULE",.T.,"05")
ConOut("HORA: "+TIME()+" - FIM DO WORKFLOW DAS PRODUCOES REALIZADAS NA INCESA")   



// *****************************************************************************
// ************************** WORKFLOW DOS CALL CENTER *************************
// *****************************************************************************
//ConOut("HORA: "+TIME()+" - GERANDO WORKFLOW DO CALL CENTER              ")
//Startjob("U_CALL_SE1","SCHEDULE",.T.,"01")
//ConOut("HORA: "+TIME()+" - FIM DO WORKFLOW DO CALL CENTER              ")


RETURN .T.