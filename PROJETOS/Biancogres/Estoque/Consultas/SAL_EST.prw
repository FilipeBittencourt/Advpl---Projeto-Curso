#include "rwMake.ch"
#include "Topconn.ch"
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  � SAL_EST        �Autor  � BRUNO MADALENO     � Data �  22/09/05   ���
�������������������������������������������������������������������������������͹��
���Desc.     �Relatorio em Crystal para gerar OS PRODUTOS E SALDOS              ���
���          �																	���
�������������������������������������������������������������������������������͹��
���Uso       � AP 7                                                             ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
User Function SAL_EST()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cSQL
Private Enter := CHR(13)+CHR(10)
Private sMesVig := SubStr(dtoc(dDataBase),4,2)  
Private sAnoVig := SubStr(dtoc(dDataBase),7,2)

lEnd       := .F.
cString    := ""
cDesc1     := "Este programa tem como objetivo imprimir relatorio "
cDesc2     := "de acordo com os parametros informados pelo usuario."
cDesc3     := " "
cTamanho   := ""
limite     := 80		
aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
cNomeprog  := "SALEST"
cPerg      := "SALEST"
aLinha     := {}
nLastKey   := 0
cTitulo	   := ""
Cabec1     := ""
Cabec2     := ""
nBegin     := 0
cDescri    := ""
cCancel    := "***** CANCELADO PELO OPERADOR *****"
m_pag      := 1                                    
wnrel      := "SALEST"
lprim      := .t.
li         := 80
nTipo      := 0
wFlag      := .t. 

       
//��������������������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT.								     �
//� Verifica Posicao do Formulario na Impressora.				             �
//� Solicita os parametros para a emissao do relatorio			             |
//����������������������������������������������������������������������������
pergunte(cPerg,.F.)
wnrel := SetPrint(cString,cNomeProg,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,    ,.T.,cTamanho,,.F.)
//Cancela a impressao
If nLastKey == 27
	Return
Endif

IF MV_PAR11 == 1
   cMd := 'S'
ELSE
   cMd := 'N'
ENDIF
      
cSQL := ""
cSQL += "ALTER VIEW VW_SAL_EST AS " + Enter
cSQL += "SELECT B1_COD, B1_TIPO, B1_GRUPO, B1_DESC, B1_UM, B2_QATU, B2_VATU1, BZ_UCOM, " + Enter
cSQL += "       DATEDIFF(day,SBZ.BZ_UCOM, GETDATE()) AS DIAS, ZCN_SOLIC BZ_YSOLIC, BZ_YOBS, ISNULL(ZCN_MD,'N') BZ_YMD " + Enter
cSQL += "	   , ZCP.ZCP_Q" + sMesVig + " AS M01 " + Enter
cSQL += "	   , ZCP.ZCP_Q" + StrZero(Iif(Val(Iif(sMesVig=="12","00",sMesVig)) + 1 > 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 1 - 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 1), 2) + " AS M02 " + Enter
cSQL += "	   , ZCP.ZCP_Q" + StrZero(Iif(Val(Iif(sMesVig=="12","00",sMesVig)) + 2 > 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 2 - 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 2), 2) + " AS M03 " + Enter
cSQL += "	   , ZCP.ZCP_Q" + StrZero(Iif(Val(Iif(sMesVig=="12","00",sMesVig)) + 3 > 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 3 - 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 3), 2) + " AS M04 " + Enter
cSQL += "	   , ZCP.ZCP_Q" + StrZero(Iif(Val(Iif(sMesVig=="12","00",sMesVig)) + 4 > 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 4 - 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 4), 2) + " AS M05 " + Enter
cSQL += "	   , ZCP.ZCP_Q" + StrZero(Iif(Val(Iif(sMesVig=="12","00",sMesVig)) + 5 > 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 5 - 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 5), 2) + " AS M06 " + Enter
cSQL += "	   , ZCP.ZCP_Q" + StrZero(Iif(Val(Iif(sMesVig=="12","00",sMesVig)) + 6 > 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 6 - 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 6), 2) + " AS M07 " + Enter
cSQL += "	   , ZCP.ZCP_Q" + StrZero(Iif(Val(Iif(sMesVig=="12","00",sMesVig)) + 7 > 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 7 - 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 7), 2) + " AS M08 " + Enter
cSQL += "	   , ZCP.ZCP_Q" + StrZero(Iif(Val(Iif(sMesVig=="12","00",sMesVig)) + 8 > 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 8 - 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 8), 2) + " AS M09 " + Enter
cSQL += "	   , ZCP.ZCP_Q" + StrZero(Iif(Val(Iif(sMesVig=="12","00",sMesVig)) + 9 > 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 9 - 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 9), 2) + " AS M10 " + Enter
cSQL += "	   , ZCP.ZCP_Q" + StrZero(Iif(Val(Iif(sMesVig=="12","00",sMesVig)) + 10 > 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 10 - 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 10), 2) + " AS M11 " + Enter
cSQL += "	   , ZCP.ZCP_Q" + StrZero(Iif(Val(Iif(sMesVig=="12","00",sMesVig)) + 11 > 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 11 - 12, Val(Iif(sMesVig=="12","00",sMesVig)) + 11), 2) + " AS M12 " + Enter
cSQL += "	   , ZCP.ZCP_Q01 + ZCP.ZCP_Q02 + ZCP.ZCP_Q03 + ZCP.ZCP_Q04 + ZCP.ZCP_Q05 + ZCP.ZCP_Q06 + ZCP.ZCP_Q07 + ZCP.ZCP_Q08 + ZCP.ZCP_Q09 + ZCP.ZCP_Q10 + ZCP.ZCP_Q11 + ZCP.ZCP_Q12 AS MTt " + Enter
cSQL += "	   , '" + sMesVig + "' AS MESVIG " + Enter
cSQL += "	   , '" + sAnoVig + "' AS ANOVIG " + Enter
cSQL += "FROM " + RETSQLNAME("SB1") + " SB1 WITH(NOLOCK) " + Enter
cSQL += "	INNER JOIN " + RETSQLNAME("SB2") + " SB2 WITH(NOLOCK) ON SB1.B1_COD = SB2.B2_COD " + Enter
cSQL += "		AND SB2.B2_FILIAL = '" + xFilial("SB2") + "' " + Enter
cSQL += "		AND SB2.B2_QATU > 0 " + Enter
cSQL += "		AND B2_LOCAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " + Enter
cSQL += "		AND SB2.D_E_L_E_T_ = '' " + Enter
cSQL += "	INNER JOIN " + RETSQLNAME("SBZ") + " SBZ WITH(NOLOCK) ON SB1.B1_COD = SBZ.BZ_COD " + Enter
cSQL += "		AND BZ_UCOM BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' " + Enter
cSQL += "		AND SBZ.D_E_L_E_T_ = '' " + Enter
cSQL += "	INNER JOIN " + RETSQLNAME("ZCN") + " ZCN WITH(NOLOCK) ON SB1.B1_COD = ZCN.ZCN_COD " + Enter
cSQL += "		AND ZCN.ZCN_LOCAL = SB2.B2_LOCAL " + Enter
cSQL += "		AND ZCN.ZCN_POLIT BETWEEN '" + MV_PAR12 + "' AND '" + MV_PAR13 + "' " + Enter
cSQL += "		AND ZCN.D_E_L_E_T_ = '' " + Enter
cSQL += "	LEFT JOIN " + RETSQLNAME("ZCP") + " ZCP WITH(NOLOCK) ON SB1.B1_COD = ZCP.ZCP_COD " + Enter
cSQL += "		AND ZCP.ZCP_FILIAL = '" + xFilial("ZCP") + "' " + Enter
cSQL += "		AND ZCP.ZCP_LOCAL = SB2.B2_LOCAL " + Enter
cSQL += "		AND ZCP.D_E_L_E_T_ = ' ' " + Enter
cSQL += "WHERE SB1.B1_FILIAL = '" + xFilial("SB1") + "' " + Enter
cSQL += "	AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " + Enter
cSQL += "	AND B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + Enter
cSQL += "	AND B1_TIPO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' " + Enter
cSQL += "	AND SB1.D_E_L_E_T_ = '' "


TcSQLExec(cSQL)
                    	
//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������
If aReturn[5]==1
	//Parametros Crystal Em Disco
	Private cOpcao:="1;0;1;Apuracao"
Else
	//Direto Impressora
	Private cOpcao:="3;0;1;Apuracao"
Endif
//AtivaRel()
callcrys("SAL_EST",cEmpant,cOpcao)
Return