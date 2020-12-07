#include "rwMake.ch"
#include "Topconn.ch"
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���PROGRAMA  � ATR_FORNECEDOR �AUTOR  � BRUNO MADALENO     � DATA �  19/04/10   ���
�������������������������������������������������������������������������������͹��
���DESC.     �RELATORIO EM CRYSTAL PARA GERAR OS ATRASOS DOS FORNECEDORES       ���
���          �						                                											���
�������������������������������������������������������������������������������͹��
���USO       � MP 10                                                            ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
User Function ATR_FORNECEDOR()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cSQL
Private Enter := CHR(13)+CHR(10) 
lEnd       := .F.
cString    := ""
cDesc1     := "Este programa tem como objetivo imprimir relatorio "
cDesc2     := "de acordo com os parametros informados pelo usuario."
cDesc3     := "Informa�oes dos atrasos dos fornecdores"
cTamanho   := ""
limite     := 80		
aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
cNomeprog  := "ATR_FO"
cPerg      := "ATR_FO"
aLinha     := {}
nLastKey   := 0
cTitulo	   := "Informa�oes dos atrasos dos fornecdores"
Cabec1     := ""
Cabec2     := ""
nBegin     := 0
cDescri    := ""
cCancel    := "***** CANCELADO PELO OPERADOR *****"
m_pag      := 1                                    
wnrel      := "ATR_FO"
lprim      := .t.
li         := 80
nTipo      := 0
wFlag      := .t. 

       
//��������������������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT.								     �
//� Verifica Posicao do Formulario na Impressora.				             �
//� Solicita os parametros para a emissao do relatorio			             |
//����������������������������������������������������������������������������

wnrel := SetPrint(cString,cNomeProg,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,    ,.T.,cTamanho,,.F.)
//Cancela a impressao
If nLastKey == 27
	Return
Endif

cSQL := ""
cSQL += "ALTER VIEW VW_ATRASO_FORNE AS " + Enter
cSQL += "SELECT	D1_FORNECE, A2_LOJA, A2_NOME, B1_GRUPO,  " + Enter
cSQL += "		C7_NUM, C7_PRODUTO, C7_DESCRI, C7_QUANT, C7_PRECO, C7_TOTAL, " + Enter
cSQL += "		C7_YDATCHE AS DATA_PREV, D1_DTDIGIT AS DATA_NF,  " + Enter
cSQL += "		CASE WHEN D1_YDTENT = '' THEN D1_DTDIGIT ELSE D1_YDTENT END AS DATA_ENT,  " + Enter
cSQL += "		D1_DOC, D1_SERIE, " + Enter
cSQL += "		DATEDIFF(DAY,C7_YDATCHE, CASE WHEN D1_YDTENT = '' THEN D1_DTDIGIT ELSE D1_YDTENT END) AS DIAS_ATRASO " + Enter
cSQL += "FROM "+RETSQLNAME("SD1")+" SD1, "+RETSQLNAME("SC7")+" SC7, SA2010 SA2, SB1010 SB1 " + Enter
cSQL += "WHERE	D1_FILIAL = '01' AND " + Enter
cSQL += "		C7_FILIAL = '01' AND " + Enter
cSQL += " " + Enter
cSQL += "		C7_YDATCHE >= '"+DTOS(MV_PAR01)+"' AND C7_YDATCHE <= '"+DTOS(MV_PAR02)+"' AND " + Enter
cSQL += "		D1_DTDIGIT >= '"+DTOS(MV_PAR03)+"' AND D1_DTDIGIT <= '"+DTOS(MV_PAR04)+"' AND " + Enter
cSQL += "		D1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND " + Enter
cSQL += "		B1_GRUPO  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND " + Enter
cSQL += "		D1_FORNECE BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND " + Enter
cSQL += "		C7_YDATCHE <> '' AND " + Enter
IF MV_PAR11 = 2
	cSQL += "		DATEDIFF(DAY,C7_YDATCHE, CASE WHEN D1_YDTENT = '' THEN D1_DTDIGIT ELSE D1_YDTENT END) < 0  AND " + Enter
ELSEIF MV_PAR11 = 3
	cSQL += "		DATEDIFF(DAY,C7_YDATCHE, CASE WHEN D1_YDTENT = '' THEN D1_DTDIGIT ELSE D1_YDTENT END) > 0  AND " + Enter
END IF
cSQL += "	 " + Enter
cSQL += "		D1_PEDIDO = C7_NUM AND " + Enter
cSQL += "		D1_COD = C7_PRODUTO AND " + Enter
cSQL += "		D1_FORNECE = C7_FORNECE AND " + Enter
cSQL += "		D1_LOJA = C7_LOJA AND " + Enter
cSQL += "		D1_ITEMPC = C7_ITEM AND " + Enter
cSQL += "		D1_FORNECE = A2_COD AND " + Enter
cSQL += "		D1_LOJA = A2_LOJA AND " + Enter
cSQL += "		B1_COD = D1_COD AND " + Enter
cSQL += " " + Enter
cSQL += "		(C7_QUJE = C7_QUANT OR C7_RESIDUO = 'S') AND " + Enter
cSQL += "		SD1.D_E_L_E_T_ = '' AND " + Enter
cSQL += "		SC7.D_E_L_E_T_ = '' AND " + Enter
cSQL += "		SA2.D_E_L_E_T_ = '' AND " + Enter
cSQL += "		SB1.D_E_L_E_T_ = ''  " + Enter
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
callcrys("ATR_FORNEC",cEmpant,cOpcao)
Return