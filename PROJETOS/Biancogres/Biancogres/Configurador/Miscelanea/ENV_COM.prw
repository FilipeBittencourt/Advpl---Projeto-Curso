#include "rwMake.ch"
#include "Topconn.ch"
#include "ap5mail.ch"

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
��� Funcao   � 	ENV_COM     � Autor �BRUNO MADALENO        � Data � 18/08/05   ���
������������������������������������������������������������������������������Ĵ��
���Descri��o � ENVIA COMUNICADO PARA CLIENTES REPRESENTANTES E FORNECEDORES    ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
User Function Env_Com()
PRIVATE EMAIL      := ""
PRIVATE NOME       := ""
PRIVATE TIPO       := ""
PRIVATE SSEMPRESA  := ""
PRIVATE Quem_envia := ""
PRIVATE CSQL       := ""                   
PRIVATE Enter      := CHR(13)+CHR(10)

PRIVATE CSTATUS    := ""
PRIVATE cEOL       := "CHR(13)+CHR(10)"
PRIVATE nARQUIVO   := ""
PRIVATE nLINHA_LOG := "" 
Private cNewPath   := "C:\Temp\"

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

//************************************ CRIANDO O ARQUIVO DE LOG DO ENVIO ************************************
If !lIsDir( cNewPath )
	MakeDir( cNewPath )
EndIf                       

cArqTxt := "C:\Temp\LOG_COMUNICADO.TXT"
nARQUIVO    := fCreate(cArqTxt)

nLINHA_LOG := REPLICATE("*",110)
fWrite(nARQUIVO,nLINHA_LOG+cEOL)
nLINHA_LOG := "**************************************** LOG DE ENVIO DOS CLIENTES *******************************************"
fWrite(nARQUIVO,nLINHA_LOG+cEOL)
nLINHA_LOG := REPLICATE("*",110)
fWrite(nARQUIVO,nLINHA_LOG+cEOL)
fWrite(nARQUIVO,cEOL)

nLINHA_LOG := nLINHA_LOG := PADR("CODIGO",8) + PADR("NOME",40) + PADR("EMAIL",35) + "STATUS"
fWrite(nARQUIVO,nLINHA_LOG+cEOL)
fWrite(nARQUIVO," " +cEOL)
nLINHA_LOG := REPLICATE("-",110)
fWrite(nARQUIVO,nLINHA_LOG+cEOL)
fWrite(nARQUIVO," " +cEOL)
nLINHA_LOG := REPLICATE("*",110)
fWrite(nARQUIVO,nLINHA_LOG+cEOL)
nLINHA_LOG := "************************************ LOG DE ENVIO DOS FORNECEDORES *******************************************"
fWrite(nARQUIVO,nLINHA_LOG+cEOL)
nLINHA_LOG := REPLICATE("*",110)
fWrite(nARQUIVO,nLINHA_LOG+cEOL)
fWrite(nARQUIVO,cEOL)
fWrite(nARQUIVO,cEOL)
nLINHA_LOG := nLINHA_LOG := PADR("CODIGO",8) + PADR("NOME",40) + PADR("EMAIL",35) + "STATUS"
fWrite(nARQUIVO,nLINHA_LOG+cEOL)

CSQL := "SELECT A2_COD, A2_EMAIL, A2_NOME FROM "+retsqlname("SA2")+" " + Enter
CSQL += "		WHERE 	A2_EMAIL <> '' AND  " + Enter
CSQL += "			D_E_L_E_T_ = '' " + Enter
If chkfile("_FORNCEDOR")
	dbSelectArea("_FORNCEDOR")
	dbCloseArea()
EndIf
TCQUERY CSQL ALIAS "_FORNCEDOR" NEW

DO WHILE !_FORNCEDOR->(EOF())
	EMAIL 	:= alltrim(_FORNCEDOR->A2_EMAIL)            
	NOME 	:= alltrim(_FORNCEDOR->A2_NOME)
	TIPO 	:= "PREZADO FORNECEDOR - "
	
	CRIA_EMAIL()
	
	nLINHA_LOG := PADR(ALLTRIM(_FORNCEDOR->A2_COD),8)
	nLINHA_LOG += PADR(ALLTRIM(_FORNCEDOR->A2_NOME),40) + "  "
	nLINHA_LOG += PADR(EMAIL,35)
	nLINHA_LOG += IIF(CSTATUS="OK","EMAIL ENVIADO COM SUCESSO","ERRO AO ENVIAR O EMAIL")
	fWrite(nARQUIVO,nLINHA_LOG+cEOL) 
	
    _FORNCEDOR->(DBSKIP())
END DO

fWrite(nARQUIVO," "+cEOL)
nLINHA_LOG := REPLICATE("-",110)
fWrite(nARQUIVO,nLINHA_LOG+cEOL)
fWrite(nARQUIVO," " +cEOL)
fWrite(nARQUIVO," " +cEOL)
nLINHA_LOG := REPLICATE("*",110)
fWrite(nARQUIVO,nLINHA_LOG+cEOL)
fWrite(nARQUIVO," " +cEOL)
nLINHA_LOG := "**************************************** LOG DE ENVIO DOS VENDEDOR *******************************************"
fWrite(nARQUIVO,nLINHA_LOG+cEOL)
nLINHA_LOG := REPLICATE("*",110)
fWrite(nARQUIVO,nLINHA_LOG+cEOL)
fWrite(nARQUIVO,cEOL)

nLINHA_LOG := nLINHA_LOG := PADR("CODIGO",8) + PADR("NOME",40) + PADR("EMAIL",35) + "STATUS"
fWrite(nARQUIVO,nLINHA_LOG+cEOL)


fClose(nARQUIVO)
WinExec("NOTEPAD " + cArqTxt)

RETURN


/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  � CRIA_EMAIL     �Autor  �BRUNO MADALENO      � Data �  04/12/06   ���
�������������������������������������������������������������������������������͹��
���Desc.     �ROTINA PARA CRIAR O EMAIL                                         ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
Static Function CRIA_EMAIL() 
Local cTit
Local cHtml := ""
Local cAnexo := ""
 	
	cTit   := "Biancogres - Procedimento e Orienta��es para acesso de terceiros nas depend�ncias do grupo Biancogres"
	
	cHtml := ' <!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">  
	cHtml += ' <html xmlns="http://www.w3.org/1999/xhtml">
	cHtml += ' <head>
	cHtml += ' <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	cHtml += ' <title>Workflow</title>
	cHtml += ' <style type="text/css">body{font-family:tahoma;font-size:15px;}</style>
	cHtml += ' </head>
	cHtml += ' <body>
	cHtml += ' <p><span>Prezado Fornecedor,</span></p>
	cHtml += ' 		<p style="text-align:center;"><span style="font-weight:bold; text-decoration:underline;">Orienta��es para Visitantes e Terceiros:</span></p>
	cHtml += '    <p><span>Segue em anexo, formul�rio </span><span style="font-weight:bold; text-decoration:underline;">atualizado</span><span> de �</span><span style="font-weight:bold; text-decoration:underline;">Autoriza��o para entrada de Prestadores de Servi�os</span><span>� e �</span><span style="font-weight:bold; text-decoration:underline;">Guia com Orienta��es aos Visitantes e terceiros</span><span>� no grupo Biancogres.</span></p>
	cHtml += '    <p><span style="font-weight:bold;">Favor atentarem-se �s instru��es para evitarem transtornos quando necessitarem ter acesso ao Grupo Biancogres.</span></p>                     
	cHtml += '    <p><span>Atenciosamente,</span></p>
	cHtml += '    <p><span style="font-weight:bold;">GRUPO BIANCOGRES</span></p>
	cHtml += ' </body>
	cHtml += ' </html>

	cAnexo := "\P10\Comunicado\GUIA_VISITANTES.PDF"
	cAnexo += ",\P10\Comunicado\AUTORIZACAO_PARA_ENTRADA_DE_PRESTADORES_DE_SERVICOS.xlsx"
	
	ENV_EMAIL(cTit, cHtml, cAnexo)

RETURN
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  � ENV_EMAIL      �Autor  �BRUNO MADALENO      � Data �  04/12/06   ���
�������������������������������������������������������������������������������͹��
���Desc.     �ROTINA PARA ENVIAR O EMAIL                                        ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
STATIC Function ENV_EMAIL(cTit, cHtml, cAnexo)
Local lOk 
                               	
	lOk := U_BIAEnvMail(, EMAIL, cTit, cHtml,, cAnexo)

   If lOk   
      CSTATUS := "OK"
      ConOut("[" + cValToChar(dDataBase) + Space(1) + Time() + "] - ENV_COM:BIAEnvMail('"+ EMAIL +"')")
   Else  
      CSTATUS := "N"
   Endif    
   
Return lOk