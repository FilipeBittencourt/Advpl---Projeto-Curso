#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ���
����Programa  � FOR_SPEED�Autor  � MADALENO           � Data �  14/05/09   ����
��������������������������������������������������������������������������͹���
����Desc.     � ROTINA PARA ENVIAR ENVIAR DADOS DO FORNEC. QUE NAO FORAM   ����
����          � ATUALIZADOS PARA O SPEED E QUE TEM PEDIDOS EM ABERTO       ����
��������������������������������������������������������������������������͹���
����Uso       � AP8 - R4                                                   ����
��������������������������������������������������������������������������ͼ���
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
USER FUNCTION FOR_SPEED(AA_EMPRESA)
PRIVATE ENTER		:= CHR(13)+CHR(10)
Private C_HTML  	:= ""
Private lOK        := .F.
PRIVATE N_FOLOWUP
PRIVATE D_DATAA

IF TYPE("DDATABASE") <> "D"
	PREPARE ENVIRONMENT EMPRESA AA_EMPRESA FILIAL "01" MODULO "FAT" TABLES "SC5,SC6"
END IF

Processa({|| GER_ARQUIV()})

RETURN



/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ���
���� GER_ARQUIV          �Autor  � MADALENO           � Data �  26/06/07   ����
��������������������������������������������������������������������������͹���
����Desc.       FUNCAO PARA CRIAR O ARQUIVO HTML E DEPOIS GERAR O EMAIL    ����
����                                                                       ����
��������������������������������������������������������������������������ͼ���
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
STATIC FUNCTION GER_ARQUIV()

CSQL := "SELECT A2_COD, A2_NOME, A2_CGC, A2_EST " + ENTER
CSQL += "FROM "+RETSQLNAME("SC7")+" SC7, SA2010 SA2 " + ENTER
CSQL += "WHERE	SC7.C7_QUANT-SC7.C7_QUJE > 0 AND  " + ENTER
CSQL += "		SC7.C7_RESIDUO = '' AND " + ENTER
CSQL += "		C7_FORNECE = A2_COD AND " + ENTER
CSQL += "		C7_LOJA = A2_LOJA AND  " + ENTER
CSQL += "		A2_YATUFOR  = 'N' AND " + ENTER
CSQL += "		SC7.D_E_L_E_T_ = '' AND " + ENTER
CSQL += "		SA2.D_E_L_E_T_ = ''  " + ENTER
CSQL += "GROUP BY A2_COD, A2_NOME, A2_CGC, A2_EST " + ENTER
CSQL += "ORDER BY A2_COD " + ENTER
IF CHKFILE("FOR_PEED")
	DBSELECTAREA("FOR_PEED")
	DBCLOSEAREA()
ENDIF
TCQUERY CSQL ALIAS "FOR_PEED" NEW


C_HTML  := ""
IF ! FOR_PEED->(EOF())
        
	C_HTML := ''
	C_HTML += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
	C_HTML += '<html xmlns="http://www.w3.org/1999/xhtml"> '
	C_HTML += '<head> '
	C_HTML += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
	C_HTML += '<title>Untitled Document</title> '
	C_HTML += '<style type="text/css"> '
	C_HTML += '<!-- '
	C_HTML += '.style12 {font-size: 9px; } '
	C_HTML += '.style18 {font-size: 10} '
	C_HTML += '.style21 {color: #FFFFFF; font-size: 9px; } '
	C_HTML += '.style22 { '
	C_HTML += '	font-size: 10pt; '
	C_HTML += '	font-weight: bold; '
	C_HTML += '} '
	C_HTML += '.style35 {font-size: 10pt; } '
	C_HTML += '.style36 {font-size: 9pt; } '
	C_HTML += '.style39 {font-size: 12pt; } '
	C_HTML += '.style41 { '
	C_HTML += '	font-size: 12px; '
	C_HTML += '	font-weight: bold; '
	C_HTML += '} '
	C_HTML += ' '
	C_HTML += '--> '
	C_HTML += '</style> '
	C_HTML += '</head> '
	C_HTML += ' '
	C_HTML += '<body> '
	C_HTML += '<table width="753" border="1"> '
	C_HTML += '  <tr> '
	C_HTML += '    <th width="568" rowspan="3" scope="col"> RELA&Ccedil;&Atilde;O FORNECEDORES QUE N&Atilde;O FORAM ATUALIZADOS PARA SPED COM PEDIDOS N�O ATENDIDOS </th> '
	C_HTML += '    <td width="169" class="style12"><div align="right"> DATA EMISS�O: '+ dtoC(DDATABASE) +' </div></td> '
	C_HTML += '  </tr> '
	C_HTML += '  <tr> '
	C_HTML += '    <td class="style12"><div align="right">HORA DA EMISS&Atilde;O: '+SUBS(TIME(),1,8)+' </div></td> '
	C_HTML += '  </tr> '
	C_HTML += '  <tr> '
	IF CEMPANT = "05" 
		C_HTML += '    <td><div align="center" class="style41"> INCESA CERAMICA LTDA </div></td> '
	ELSE 
		C_HTML += '    <td><div align="center" class="style41"> BIANCOGRES CER�MICA SA </div></td> '
	END IF
	C_HTML += '  </tr> '
	C_HTML += '</table> '
	C_HTML += '<table width="754" border="1"> '
	C_HTML += '  <tr bgcolor="#0066CC"> '
	C_HTML += '    <th width="77"	scope="col"><span class="style21"> C&Oacute;DIGO</span></th> '
	C_HTML += '    <th width="418" 	scope="col"><span class="style21"> NOME </span></th> '
	C_HTML += '    <th width="164" 	scope="col"><span class="style21"> CNPJ </span></th> '
	C_HTML += '    <th width="67" 	scope="col"><span class="style21"> ESTADO </span></th> '
	C_HTML += '  </tr> '
	  
	DO WHILE ! FOR_PEED->(EOF())
		C_HTML += '  <tr bgcolor="#FFFFFF"> '
		C_HTML += '    <th scope="col"><div align="left" class="style41"> '+ ALLTRIM(FOR_PEED->A2_COD) +' </div></th> '
		C_HTML += '    <th scope="col"><div align="left" class="style41"> '+ ALLTRIM(FOR_PEED->A2_NOME) +' </div></th> '
		C_HTML += '    <th scope="col"><div align="left" class="style41"> '+ ALLTRIM(FOR_PEED->A2_CGC) +' </div></th> '
		C_HTML += '    <th scope="col"><div align="left" class="style41"> '+ ALLTRIM(FOR_PEED->A2_EST) +' </div></th> '
		C_HTML += '  </tr>
	
		FOR_PEED->(DBSKIP())		
	END DO 
	
	C_HTML += '</table> '
	C_HTML += '</body> '
	C_HTML += '</html> '

END IF

CLI_EMAIL()

RETURN


/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ���
���� COMIS_EMAIL         �Autor  � MADALENO           � Data �  26/06/07   ����
��������������������������������������������������������������������������͹���
����Desc.       ROTINA PARA GERAR O EMAIL E ENVIAR O MESMO                 ����
����                                                                       ����
��������������������������������������������������������������������������ͼ���
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������                                        
*/
STATIC FUNCTION CLI_EMAIL()

IF CEMPANT = "05" 
	cEnvia 	    := "workflow@incesa.ind.br"
	cRecebe     := "geovani.gomes@biancogres.com.br" 
ELSE
	cEnvia 	    := "workflow@biancogres.com.br"
	cRecebe     := "geovani.gomes@biancogres.com.br"
END IF	
cRecebeCC	:= "" 	
cRecebeCO	:= ""	
cAssunto	:= "FORNECEDORES N�O ATUALIZADOS"							// Assunto do Email
  
U_BIAEnvMail(,cRecebe,cAssunto,C_HTML)

RETURN
