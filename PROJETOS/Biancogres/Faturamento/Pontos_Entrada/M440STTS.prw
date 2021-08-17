#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M440STTS  �Autor  �Ranisses A. Corona  � Data �  11/25/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Acerta/Bloqueia Liberacao de Pedidos de Vendas verificando  ���
���          �a situacao do cliente do cliente na outro empresa (01/05)	  ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento (Liberacao de Pedidos MATA440)                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M440STTS()
Local cSql := ""

//OS 3494-16 - Tania c/ aprova��o do Fabio
If cEmpAnt == "02"
	Return(.T.)
EndIf

//Verifica se existem Itens com Bloqueio de Credito
cAliasTmp := GetNextAlias()
BeginSql Alias cAliasTmp
	SELECT COUNT(C9_BLCRED) BLCRED FROM %Table:SC9% WHERE C9_PEDIDO = %Exp:M->C5_NUM% AND C9_NFISCAL = ' ' AND (C9_BLCRED <> ' ' OR (C9_YDTBLCT <> '' AND C9_YDTLICT = '') ) AND %NOTDEL% 
EndSql
If (cAliasTmp)->BLCRED > 0
	If Type("nTpBlq") <> "U" 
		If nTpBlq == "01"
			Msgbox("Este pedido possui itens com  Bloqueio de Cr�dito, pois ultrapassa o Limite de Cr�dito.","M440STTS","STOP")
		ElseIf nTpBlq == "02"
			Msgbox("Este pedido possui itens com  Bloqueio de Cr�dito, pois n�o possui saldo de RA.","M440STTS","STOP")
		ElseIf nTpBlq == "03"
			Msgbox("Este pedido possui itens com  Bloqueio de Cr�dito, pois o Cliente possui Risco 'E'.","M440STTS","STOP")
		ElseIf nTpBlq == "04"
			Msgbox("Este pedido possui itens com  Bloqueio de Cr�dito, pois o Cliente est� com o Limite de Cr�dito vencido.","M440STTS","STOP")
		ElseIf nTpBlq == "05"		
			Msgbox("Este pedido possui itens com  Bloqueio de Cr�dito, pois o Cliente possui t�tulos em atraso.","M440STTS","STOP")
		ElseIf nTpBlq == "061"		
			Msgbox("Este pedido possui itens com  Bloqueio de Cr�dito, pois teve altera��o na data de entrega aprovada.","M440STTS","STOP")
		ElseIf nTpBlq == "062"		
			Msgbox("Este pedido possui itens com  Bloqueio de Cr�dito, pois teve altera��o nos valores aprovados.","M440STTS","STOP")			
		ElseIf nTpBlq == "063"		
			Msgbox("Este pedido possui itens com  Bloqueio de Cr�dito, pois est� sendo liberado antes da data de entrega.","M440STTS","STOP")
		ElseIf nTpBlq == "064"		
			Msgbox("Este pedido possui itens com  Bloqueio de Cr�dito, pois est� com t�tulos de Contrato em atraso.","M440STTS","STOP")
		EndIf					
	Else
		Msgbox("Este pedido possui itens com  Bloqueio de Cr�dito.","M440STTS","STOP")
	EndIf
EndIf

//Verifica se existem Itens com Bloqueio de Estoque
cAliasTmp2 := GetNextAlias()
BeginSql Alias cAliasTmp2
	SELECT COUNT(C9_BLEST) BLEST FROM %Table:SC9% WHERE C9_PEDIDO = %Exp:M->C5_NUM% AND C9_NFISCAL = ' ' AND C9_BLEST <> ' ' AND %NOTDEL% 
EndSql
If (cAliasTmp2)->BLEST > 0
	Msgbox("Este pedido possui itens com  Bloqueio de Estoque.","M440STTS","STOP")
EndIf

(cAliasTmp)->(dbCloseArea())
(cAliasTmp2)->(dbCloseArea())

//Grava Status do RA na Libera��o dos Pedidos

//Ticket 22041 -> comentado abaixo porque esta sendo usado no PE M440SC9I
//U_BIA859(M->C5_CLIENTE,M->C5_LOJACLI)

//If nRaStat <> "0"
//	cSql := "UPDATE "+RetSqlName("SC9")+" SET C9_YRASTAT = '"+nRaStat+"', C9_MSEXP = '' WHERE C9_PEDIDO = '"+M->C5_NUM+"' AND D_E_L_E_T_ = '' "
//	TcSQLExec(cSQL)
//EndIf

//Projeto reserva de OP - Fernando/Facile em 08/10/2014 - Apagar reservas e gerar novamento com o saldo pendente    
//Fernando em 07/01 - nao faz sentido fazer esse metodo para LM - nao deve ter reservas na LM nem alterar as reserva na origem
If M->C5_TIPO == 'N' .And. !(CEMPANT $ AllTrim(GetNewPar("FA_EMNRES",""))) .And. (AllTrim(CEMPANT) <> "07") .And. M->C5_YLINHA <> "4"

	//SC6->(DbSetOrder(1))
	//If !((AllTrim(CEMPANT) == "14") .And. SC6->(DbSeek(XFilial("SC6")+M->C5_NUM)) .And. !U_CHKRODA(SC6->C6_PRODUTO))
		U_FRRT02C9(M->C5_NUM)
	//EndIf
EndIf


    // Gabriel Pinheiro Leite da Silva(G3) - 28/05/2021 - OS:32367 - Configurar para que ao alterar os campos de data do pedido na empresa origem, eles repliquem para o pedido da LM.
    If (Altera) .And. cEmpAnt != '07' 

        begincontent var cSql

            UPDATE SC67 
            SET  SC67.C6_ENTREG=SC61.C6_ENTREG
                ,SC67.C6_YDTNERE=SC61.C6_YDTNERE
                ,SC67.C6_YDTNECE=SC61.C6_YDTNECE
            FROM SC6070 SC67
            JOIN SC5070 SC57 ON (SC57.C5_FILIAL=SC67.C6_FILIAL AND SC57.C5_NUM=SC67.C6_NUM)
            JOIN SC5010 SC51 ON (SC57.C5_YPEDORI=SC51.C5_NUM)
            JOIN SC6010 SC61 ON (SC51.C5_FILIAL=SC61.C6_FILIAL AND SC51.C5_NUM=SC61.C6_NUM)
           /* JOIN SC9010 SC91 ON (SC61.C6_FILIAL=SC91.C9_FILIAL AND SC91.C9_PEDIDO=SC61.C6_NUM) */
            WHERE   SC57.D_E_L_E_T_=''
                AND SC67.D_E_L_E_T_=''
                AND SC51.D_E_L_E_T_=''
                AND SC61.D_E_L_E_T_=''
               /* AND SC91.D_E_L_E_T_='' */
                AND SC51.C5_NUM='@C5_NUM'
                AND SC57.C5_YEMP='@C5_YEMP'
                AND SC67.C6_PRODUTO=SC61.C6_PRODUTO
                AND SC67.C6_ITEM=SC61.C6_ITEM
                AND SC51.C5_FILIAL='@C5_FILIAL'
             /* AND SC91.C9_PEDIDO=SC61.C6_NUM
                 Barbara solicitou para n�o verificar itens, altera��o em qualquer item da C9, dever� ser replicada para todos os itens.
                
                AND SC91.C9_PRODUTO=SC61.C6_PRODUTO
				AND SC91.C9_ITEM=SC61.C6_ITEM
                */

        endcontent

        cSql:=strTran(cSql,"SC5010",retSQLName("SC5"))
        cSql:=strTran(cSql,"SC6010",retSQLName("SC6"))
        cSql:=strTran(cSql,"SC9010",retSQLName("SC9"))
        cSql:=strTran(cSql,"@C5_NUM",M->C5_NUM)
        cSql:=strTran(cSql,"@C5_YEMP",M->C5_YEMP)
        cSql:=strTran(cSql,"@C5_FILIAL",xFilial("SC5"))

        TCSQLExec(cSql)

    EndIf 


Return
