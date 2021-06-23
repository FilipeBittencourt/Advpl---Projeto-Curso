/*---------+-----------+-------+----------------------+------+------------+
|Funcao    |RSPA100INC | Autor | Marcelo Sousa        | Data | 23.05.2018 |
|          |           |       | Facile Sistemas      |      |            |
+----------+-----------+-------+----------------------+------+------------+
|Descricao |PONTO DE ENTRADA UTILIZADO PARA TRATAR SE O USUARIO DO SISTEMA|
|          |TEM A PERMISS�O DE CADASTRAR UMA VAGA. TRATA TAMB�M DO ENVIO  |
|          |DE E-MAIL PARA O SETOR DE RECRUTAMENTO   					  |	
+----------+--------------------------------------------------------------+
|Retorno   |.T. OU .F.                                                    |
+----------+--------------------------------------------------------------+
|Uso       |RECRUTAMENTO E SELE��O                                        |
+----------+-------------------------------------------------------------*/

#Include "protheus.ch"
#Include "topconn.ch"

User Function RSPA100INC()
	
	/*������������������������������������������������������������������������ٱ�
	�� Declara��o de Variaveis Private dos Objetos                             ��
	ٱ�������������������������������������������������������������������������*/ 
    cUsrtst := __cUserID
    aUsrtst2 := UsrRetGrp(cUsrtst)
	lAlt := .F.
	lCria := .F.
	lAprov := .F.
	aUsr   := cUserName
	
	DBSELECTAREA("ZR3")
	ZR3->(dbsetorder(1))
	ZR3->(DBSEEK(xFilial("ZR3")+cUsrtst))
	
	IF ALTERA
		
		/*������������������������������������������������������������������������ٱ�
		�� Verificando permiss�o de altera��o                                      ��
		ٱ�������������������������������������������������������������������������*/
		IF ZR3->ZR3_USUARI == cUsrtst .AND. ZR3->ZR3_RECRUT == "1"
			lAlt := .T.
		ENDIF
		
		IF !lAlt
		
			MSGALERT((cUserName) + ", voc� n�o possui permiss�o de altera��o. Favor solicitar suporte no setor de recrutamento.","Erro de Permissao")
			Return .F.
		
		ENDIF
		
	ENDIF
	
	/*������������������������������������������������������������������������ٱ�
	�� Verificando permiss�o para cadastrar vagas.                             ��
	ٱ�������������������������������������������������������������������������*/
	IF ZR3->ZR3_USUARI == cUsrtst .AND. ZR3->ZR3_CRIA == "1"
		lCria := .T.
	ENDIF

	IF !lCria
	    
		Alert("Usuario " + (cUserName) + " n�o possui permiss�o para cadastrar vagas. Favor solicitar permiss�o no setor de recrutamento")
		Return .F.
	
	ENDIF
    
    /*������������������������������������������������������������������������ٱ�
	�� Enviando vaga para o funcion�rio de recrutamento realizar a aprova��o   ��
	ٱ�������������������������������������������������������������������������*/ 
    IF INCLUI .OR. ALTERA
    
    	
    	cCodVaga := M->QS_VAGA
    	cDcVaga  := M->QS_DESCRIC
    	
    	dbselectarea("SRA")
    	SRA->(dbsetorder(1))
    	SRA->(dbSeek(xFilial("SRA")+M->QS_MATRESP))
    	
    	IF !EMPTY(SRA->RA_EMAIL) .AND. !EMPTY(M->QS_MATRESP)
    		
    		IF M->QS_TIPO <> "4"
    			M->QS_TIPO := ""	
    		ENDIF
    		
    		M->QS_YAPROV := ""    			
    		cNmAp    := ALLTRIM(SRA->RA_NOME)
    		cEmPara  := SRA->RA_EMAIL
    	    U_BIAFM004(cCodVaga,cDcVaga,aUsr,cEmPara,cNmAp,"1")
    		Alert("Aviso de vaga enviado para " + cNmAp + ". Favor entrar em contato com o mesmo para efetuar a aprova��o da vaga")
    		Return .T.
    	
    	ELSE
    	
    		Alert("N�o foi encontrado endere�o de E-mail do Aprovador. Favor entrar em contato com a equipe de Recrutamento.")
    		Return .F.
    	
    	ENDIF
    	

    	
    Endif

Return