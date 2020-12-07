#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���PROGRAMA  �DES_IMPO  �AUTOR  � MADALENO           � DATA �  16/12/09   ���
�������������������������������������������������������������������������͹��
���DESC.     � CADASTRO DAS DESPESAS DE IMPORTA��O DE PISOS               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���USO       � FATURAMENTO                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION DES_IMPO()
	DBSELECTAREA("ZZK")
	DBGOTOP()
	N := 1
	CCADASTRO := "Cadastro dos Processos de Importa��o" 
	AROTINA   := { {"PESQUISAR" ,'AXPESQUI',0,1},;
	{"VISUALIZAR",'EXECBLOCK("DES_MONTATELA",.F.,.F.,"V")' ,0,2},;
	{"INCLUIR"   ,'EXECBLOCK("DES_MONTATELA",.F.,.F.,"I")' ,0,3},;
	{"ALTERAR"   ,'EXECBLOCK("DES_MONTATELA",.F.,.F.,"A")' ,0,2},;
	{"EXCLUIR"   ,'EXECBLOCK("DES_MONTATELA",.F.,.F.,"E")' ,0,2} }  
	MBROWSE(6,1,22,85, "ZZK", , , , , ,)
RETURN

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���FUN�AO    � MONTTELA                                                   ���
�������������������������������������������������������������������������Ĵ��
���DESCRI�AO � FUNCAO PARA MONTAR A TELA                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION DES_MONTATELA()

	Local I

	//���������������������������������������������������������������������Ŀ
	//� DECLARACAO DE VARIAVEIS UTILIZADAS NO PROGRAMA ATRAVES DA FUNCAO    �
	//� SETPRVT, QUE CRIARA SOMENTE AS VARIAVEIS DEFINIDAS PELO USUARIO,    �
	//� IDENTIFICANDO AS VARIAVEIS PUBLICAS DO SISTEMA UTILIZADAS NO CODIGO �
	//�����������������������������������������������������������������������
	SETPRVT("WOPCAO,LVISUALIZAR,LINCLUIR,LALTERAR,LEXCLUIR,NOPCE")
	SETPRVT("NOPCG,COPCAO,NOPCX,NUSADO,AHEADER")
	SETPRVT("ACOLS,I,WCONTRATO,WIDEDIST,WPARCELA,WVALOR")
	SETPRVT("WQTDPAR,WDATVEN,WINDICE,WJUROS,WDATREF,WMULTA")
	SETPRVT("WTAXA,CTITULO,WAC,WAR,ACGD,CLINHAOK")
	SETPRVT("CTUDOOK,LRET,WP_VENCTO,WP_YTIPO,WP_VALOR,WP_YDTREAJ")

	PRIVATE _FORNEC
	PRIVATE _LOJA

	WOPCAO := PARAMIXB
	//��������������������������������������������������������������������������Ŀ
	//� DETERMINA FUNCAO SELECIONADA                                             �
	//� SO PERMITE INCLUSAO (CADASTRAMENTO DE BLOCOS)                            �
	//����������������������������������������������������������������������������
	DO CASE
		CASE WOPCAO == "V" ; NOPCX:=2; LVISUALIZAR := .T. ; NOPCE := 2 ; NOPCG := 2 ; COPCAO := "VISUALIZAR"
		CASE WOPCAO == "I" ; NOPCX:=3; LINCLUIR    := .T. ; NOPCE := 3 ; NOPCG := 3 ; COPCAO := "INCLUIR"
		CASE WOPCAO == "A" ; NOPCX:=4; LALTERAR    := .T. ; NOPCE := 3 ; NOPCG := 3 ; COPCAO := "ALTERAR"
		CASE WOPCAO == "E" ; NOPCX:=5; LEXCLUIR    := .T. ; NOPCE := 2 ; NOPCG := 2 ; COPCAO := "EXCLUIR"
	ENDCASE

	//��������������������������������������������������������������������������Ŀ
	//� MONTA AHEADER                                                            �
	//����������������������������������������������������������������������������
	DBSELECTAREA("SX3")
	DBSETORDER(1)
	DBSEEK("ZZK")
	NUSADO  := 0
	AHEADER := {}                                        
	ACOLS   := {}
	WHILE !EOF() .AND. SX3->X3_ARQUIVO == "ZZK"
		IF  ALLTRIM(SX3->X3_CAMPO) $ "ZZK_FILIAL,ZZK_CODIGO,ZZK_NOTAS,ZZK_NOTAS2,ZZK_NOTAS3,ZZK_DTEMIS,ZZK_DTPAGT,ZZK_DTENT, ZZK_FORNEC,ZZK_LOJA" 
			DBSKIP()
			LOOP
		ENDIF

		IF  X3USO(SX3->X3_USADO) .AND. SX3->X3_NIVEL <= CNIVEL
			NUSADO := NUSADO + 1
			AADD(AHEADER,{ TRIM(SX3->X3_TITULO),SX3->X3_CAMPO   , ;
			SX3->X3_PICTURE     ,SX3->X3_TAMANHO , ;
			SX3->X3_DECIMAL     ,"ALLWAYSTRUE()" , ;
			SX3->X3_USADO       ,SX3->X3_TIPO    , ;
			SX3->X3_ARQUIVO     ,SX3->X3_CONTEXT } )
		ENDIF
		&("M->" + SX3->X3_CAMPO) := CRIAVAR(SX3->X3_CAMPO)
		DBSKIP()
	ENDDO

	//��������������������������������������������������������������������������Ŀ
	//� MONTA ACOLS                                                              �
	//����������������������������������������������������������������������������
	IF  LINCLUIR
		ACOLS             := {ARRAY(NUSADO+1)}
		ACOLS[1,NUSADO+1] := .F.
		FOR I := 1 TO NUSADO
			ACOLS[1,I] := CRIAVAR(AHEADER[I,2])
		NEXT
		_FORNEC := SPACE(6)
		_LOJA 	:= SPACE(2)
		_NOTAS  := SPACE(300) 
		_NOTAS2 := SPACE(300)
		_NOTAS3 := SPACE(300)	
		_DTEMIS := ctod("  /  /  ")
		_DTPAGT := ctod("  /  /  ") 
		_DTENT  := ctod("  /  /  ")	
	ELSE
		ACOLS:={}
		DBSELECTAREA("ZZK")
		DBSETORDER(1) 
		NREC:=RECNO()
		M->ZZK_CODIGO   := ZZK->ZZK_CODIGO
		_FORNEC := ZZK->ZZK_FORNEC
		_LOJA 	:= ZZK->ZZK_LOJA
		_NOTAS 	:= ZZK->ZZK_NOTAS
		_NOTAS2	:= ZZK->ZZK_NOTAS2
		_NOTAS3 := ZZK->ZZK_NOTAS3
		_DTEMIS := ZZK->ZZK_DTEMIS
		_DTPAGT := ZZK->ZZK_DTPAGT 
		_DTENT  := ZZK->ZZK_DTENT

		DBSEEK(XFILIAL("ZZK")+M->ZZK_CODIGO,.T.)
		WHILE !EOF() .AND. ZZK->ZZK_FILIAL  == XFILIAL("ZZK") .AND. ZZK->ZZK_CODIGO   == M->ZZK_CODIGO
			AADD(ACOLS,ARRAY(NUSADO+1))
			FOR I := 1 TO NUSADO
				ACOLS[LEN(ACOLS),I]    := FIELDGET(FIELDPOS(AHEADER[I,2]))
			NEXT
			ACOLS[LEN(ACOLS),NUSADO+1] := .F.
			DBSKIP()
		ENDDO
		DBGOTO(NREC)

	ENDIF

	//��������������������������������������������������������������Ŀ
	//� CRIA VARIAVEIS M->????? DA ENCHOICE                          �
	//����������������������������������������������������������������
	REGTOMEMORY("ZZK",(COPCAO=="INCLUIR"))
	CTITULO   := "Cadastro dos Processos de Importa��o"
	N := 1

	//��������������������������������������������������������������Ŀ
	//� ARRAY COM DESCRICAO DOS CAMPOS DO CABECALHO DO MODELO 2      �
	//����������������������������������������������������������������
	AC:={}
	// AC[N,1] = NOME DA VARIAVEL EX.:"CCLIENTE"
	// AC[N,2] = ARRAY COM COORDENADAS DO GET [X,Y], EM WINDOWS ESTAO EM PIXEL
	// AC[N,3] = TITULO DO CAMPO
	// AC[N,4] = PICTURE
	// AC[N,5] = VALIDACAO
	// AC[N,6] = F3
	// AC[N,7] = SE CAMPO E' EDITAVEL .T. SE NAO .F.

	AADD(AC,{ "ZZK_CODIGO" 	,{018,003} , "C�digo                  "	,,,,.F.})
	AADD(AC,{ "_FORNEC"		,{038,003} , "Fornecedor              " ,,,"SA2",.T.})
	AADD(AC,{ "_LOJA" 		,{038,120} , "Loja   "					,,,,.T.})
	AADD(AC,{ "_NOTAS " 	,{058,003} , "Notas                   " ,,"U_VAL_NOTAS()",,.T.}) 
	AADD(AC,{ "_NOTAS2" 	,{078,003} , "Notas                   " ,,"U_VAL_NOTAS()",,.T.})
	AADD(AC,{ "_NOTAS3" 	,{098,003} , "Notas                   " ,,"U_VAL_NOTAS()",,.T.})
	AADD(AC,{ "_DTEMIS" 	,{118,003} , "Data Emiss�o            "	,,,,.T.})
	AADD(AC,{ "_DTPAGT" 	,{118,120} , "Data Pagamento          "	,,,,.T.}) 
	AADD(AC,{ "_DTENT " 	,{138,003} , "Data Entrega            "	,,,,.T.})

	//��������������������������������������������������������������Ŀ
	//� ARRAY COM DESCRICAO DOS CAMPOS DO RODAPE DO MODELO 2         �
	//����������������������������������������������������������������
	AR:={}

	//��������������������������������������������������������������Ŀ
	//� ARRAY COM COORDENADAS DA GETDADOS NO MODELO2                 �
	//����������������������������������������������������������������
	ACGD:={250,5,138,315}

	//��������������������������������������������������������������Ŀ
	//� VALIDACOES NA GETDADOS DA MODELO 2                           �
	//����������������������������������������������������������������
	//CLINHAOK := "EXECBLOCK('SAN0026L',.F.,.F.)"
	CTUDOOK  := "EXECBLOCK('DES_TOK',.F.,.F.)"

	//��������������������������������������������������������������Ŀ
	//� CHAMADA DA MODELO2                                           �
	//����������������������������������������������������������������
	LRET := MODELO2(CTITULO,AC,AR,ACGD,NOPCX,CLINHAOK,CTUDOOK)
	IF  LRET
		FPROCESSA()
	END

RETURN

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���FUN��O    � DES_TOK                                                    ���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � VALIDA A INCLUSAO DOS REGISTROS                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION DES_TOK()

	Local I

	PRIVATE LLRET := .T.

	// VALIDANDO SE EXISTE OS REGISTROS EM BRANCO
	IF 	ALLTRIM(_FORNEC) = "" .OR. ALLTRIM(_NOTAS) = ""
		MSGBOX("INFORMA��ES INCOMPLETAS")
		RETURN(.F.)
	END IF

	// VALIDANDO O VALOR TOTAL DAS NOTAS.
	PRIVATE NNOTAS := ALLTRIM(_NOTAS)
	IF !EMPTY(_NOTAS2)                                                         
		PRIVATE NNOTAS := ALLTRIM(_NOTAS)+','+ALLTRIM(_NOTAS2)
	ENDIF

	IF !EMPTY(_NOTAS3)                                                         
		PRIVATE NNOTAS := ALLTRIM(NNOTAS)+','+ALLTRIM(_NOTAS3)
	ENDIF

	PRIVATE NAUX   := ALLTRIM(_NOTAS)
	PRIVATE VALOR_TOTAL := 0

	//IF LEN(NNOTAS) = 6  
	IF LEN(NNOTAS) = 9 
		// VERIFICANDO SE A NOTA FISCAL EXISTE
		CSQL := "SELECT SUM(F1_VALBRUT) AS VALOR FROM "+RETSQLNAME("SF1")+" "
		CSQL += "WHERE	F1_DOC = '"+NNOTAS+"' AND "
		CSQL += "		F1_FORNECE = '"+_FORNEC+"' AND "
		CSQL += "		F1_LOJA  = '"+_LOJA+"' AND "
		CSQL += "		F1_EMISSAO  >= '"+DTOS(_DTEMIS)+"' AND " 
		CSQL += "		F1_DTDIGIT  >= '"+DTOS(_DTENT)+"' AND "	
		CSQL += "		D_E_L_E_T_ = '' "
		IF CHKFILE("_TRAB")
			DBSELECTAREA("_TRAB")
			DBCLOSEAREA()
		ENDIF
		TCQUERY CSQL ALIAS "_TRAB" NEW
		IF ! _TRAB->(EOF())
			VALOR_TOTAL += _TRAB->VALOR
		ELSE	
			MSGBOX("NOTA FISCAL INEXISTENTE: " + NAUX)
			RETURN(.F.)
		ENDIF
	ELSE
		I := 1
		DO WHILE I <= LEN(NNOTAS)
			//NAUX := SUBSTR(NNOTAS,I,6) 
			NAUX := SUBSTR(NNOTAS,I,9)			

			// VERIFICANDO SE ANOTA FISCAL EXISTE
			CSQL := "SELECT SUM(F1_VALBRUT) AS VALOR FROM "+RETSQLNAME("SF1")+" "
			CSQL += "WHERE	F1_DOC = '"+NAUX+"' AND "
			CSQL += "		F1_FORNECE = '"+_FORNEC+"' AND "
			CSQL += "		F1_LOJA    = '"+_LOJA+"' AND "
			CSQL += "		F1_EMISSAO >= '"+DTOS(_DTEMIS)+"' AND " 
			CSQL += "		F1_DTDIGIT >= '"+DTOS(_DTENT)+"' AND "			
			CSQL += "		D_E_L_E_T_ = '' "
			IF CHKFILE("_TRAB")
				DBSELECTAREA("_TRAB")
				DBCLOSEAREA()
			ENDIF
			TCQUERY CSQL ALIAS "_TRAB" NEW
			IF ! _TRAB->(EOF())
				VALOR_TOTAL += _TRAB->VALOR
			ELSE	
				MSGBOX("NOTA FISCAL INEXISTENTE: " + NAUX)
				RETURN(.F.)
			END IF
			//I += (6+1) 
			I += (9+1)			
		END DO
	ENDIF

	PRIVATE VAL_AUX := 0
	FOR I := 1 TO LEN(ACOLS)
		IF  !ACOLS[I,NUSADO+1]
			IF SUBSTR( GDFIELDGET("ZZK_DESCDE",I) ,1,3) = "(+)" .OR. SUBSTR( GDFIELDGET("ZZK_DESCDE",I) ,1,3) = "($)" // SO IRA SOMAR AS DESPESAS POSITIVAS
				VAL_AUX	+= GDFIELDGET("ZZK_VALOR",I)
			ENDIF
		ENDIF
	NEXT

	IF VAL_AUX <> VALOR_TOTAL
		MSGBOX("TOTAL DAS NOTAS ( " + ALLTRIM(TRANSFORM(    VALOR_TOTAL      ,"@E 999,999,999.99"))  +  " ) N�O CONFEREM COM O TOTAL DIGITADO ( " + ALLTRIM(TRANSFORM(    VAL_AUX      ,"@E 999,999,999.99"))  +  " ) ")
		RETURN(.F.)
	ELSE
		RETURN(.T.)
	END IF

RETURN(LLRET)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���FUN��O    � CHECA_NOTA                                                 ���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � VERIFICA SE AS NOTAS DIGITADAS EXISTE NO CADASTRO          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION VAL_NOTAS()
	PRIVATE NNOTAS := ALLTRIM(_NOTAS)
	IF !EMPTY(_NOTAS2)                                                         
		PRIVATE NNOTAS := ALLTRIM(_NOTAS)+','+ALLTRIM(_NOTAS2)
	ENDIF

	IF !EMPTY(_NOTAS3)                                                         
		PRIVATE NNOTAS := ALLTRIM(NNOTAS)+','+ALLTRIM(_NOTAS3)
	ENDIF
	PRIVATE NAUX := ALLTRIM(_NOTAS)

	IF ALLTRIM(NNOTAS) = ""
		RETURN(.T.)
	END IF

	//IF LEN(NNOTAS) < 6  
	IF LEN(NNOTAS) < 9 
		MSGBOX("NOTA FISCAL INVALIDA")
		RETURN(.F.)
	END IF

	I := 1
	DO WHILE I <= LEN(NNOTAS)
		//NAUX := SUBSTR(NNOTAS,I,6) 
		NAUX := SUBSTR(NNOTAS,I,9)	

		// VERIFICANDO SE ANOTA FISCAL EXISTE
		CSQL := "SELECT COUNT(F1_DOC) AS CQUANT FROM "+RETSQLNAME("SF1")+" "
		CSQL += "WHERE	F1_DOC = '"+NAUX+"' AND "
		CSQL += "		F1_FORNECE = '"+_FORNEC+"' AND "
		CSQL += "		F1_LOJA  = '"+_LOJA+"' AND "
		CSQL += "		D_E_L_E_T_ = '' "
		IF CHKFILE("_TRAB")
			DBSELECTAREA("_TRAB")
			DBCLOSEAREA()
		ENDIF
		TCQUERY CSQL ALIAS "_TRAB" NEW
		IF _TRAB->CQUANT = 0
			MSGBOX("NOTA FISCAL INEXISTENTE")
			RETURN(.F.)
		END IF

		//I += (6+1) 
		I += (9+1)	
	END DO

	//I-= 6+1 
	I-= 9+1
	//NAUX := SUBSTR(NNOTAS,I,6) 
	NAUX := SUBSTR(NNOTAS,I,9)

	// VERIFICANDO SE ANOTA FISCAL EXISTE
	CSQL := "SELECT COUNT(F1_DOC) AS CQUANT FROM "+RETSQLNAME("SF1")+" "
	CSQL += "WHERE	F1_DOC = '"+NAUX+"' AND "
	CSQL += "		F1_FORNECE = '"+_FORNEC+"' AND "
	CSQL += "		F1_LOJA  = '"+_LOJA+"' AND "
	CSQL += "		D_E_L_E_T_ = '' "
	IF CHKFILE("_TRAB")
		DBSELECTAREA("_TRAB")
		DBCLOSEAREA()
	ENDIF
	TCQUERY CSQL ALIAS "_TRAB" NEW
	IF _TRAB->CQUANT = 0
		MSGBOX("NOTA FISCAL INEXISTENTE")
		RETURN(.F.)
	ENDIF

RETURN()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���FUN��O    � FPROCESSA                                                  ���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � PROCESSA CONFIRMACAO DA TELA                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC FUNCTION FPROCESSA()

	Local I

	// BUSCANDO O MAIOR CODIGO
	CSQL := " SELECT ISNULL(MAX(ZZK_CODIGO),'000000') AS MAIOR FROM "+RETSQLNAME("ZZK")+" WHERE D_E_L_E_T_ = '' "
	IF CHKFILE("_CTRAB")
		DBSELECTAREA("_CTRAB")
		DBCLOSEAREA()
	ENDIF
	TCQUERY CSQL ALIAS "_CTRAB" NEW
	//IF _CTRAB->MAIOR == "0" 
	//	CODIGO_NOT := "000001"
	//ELSE
	CODIGO_NOT := SOMA1(_CTRAB->MAIOR)
	//END IF

	DO CASE
		CASE LINCLUIR
		FOR I := 1 TO LEN(ACOLS)
			//����������������������������������������������������������������������Ŀ
			//� VERIFICA SE O ITEM FOI DELETADO, SE NAO, FAZ SUA INCLUSAO            �
			//������������������������������������������������������������������������
			IF  !ACOLS[I,NUSADO+1]
				IF RECLOCK("ZZK",.T.)
					ZZK->ZZK_FILIAL     := XFILIAL("ZZK")
					//CAMPOS DO ENCHOICE
					ZZK->ZZK_CODIGO	:= CODIGO_NOT

					ZZK->ZZK_NOTAS	:= _NOTAS 
					ZZK->ZZK_NOTAS2 := _NOTAS2					
					ZZK->ZZK_NOTAS3	:= _NOTAS3					
					ZZK->ZZK_DTEMIS	:= _DTEMIS
					ZZK->ZZK_DTPAGT := _DTPAGT 
					ZZK->ZZK_DTENT  := _DTENT 					
					ZZK->ZZK_FORNEC := _FORNEC
					ZZK->ZZK_LOJA 	:= _LOJA

					//CAMPOS DO ACOLS
					//ZZK->ZZK_TIPDES		:= IIF(I=1, 2, 3)
					ZZK->ZZK_TIPDES		:= GDFIELDGET("ZZK_TIPDES",I)
					ZZK->ZZK_DESCDE		:= GDFIELDGET("ZZK_DESCDE",I)
					ZZK->ZZK_VALOR		:= GDFIELDGET("ZZK_VALOR",I)					
					ZZK->(MSUNLOCK())
				ENDIF
			ENDIF
		NEXT
		CASE LALTERAR
		//������������������������������������������������������������������Ŀ
		//� EXCLUI ZZK - CADASTRO DE DEFEITOS DOS BLOCOS                     �
		//��������������������������������������������������������������������

		//IF ZZK->ZW_CODIGO = "0"
		//	MSGBOX("N�O � PERMITIDA A ALTERA��O DO TITULO","INFO","INFO")
		//	RETURN
		//END IF
		DBSELECTAREA("ZZK")
		DBSETORDER(1)
		M->ZZK_CODIGO   := ZZK->ZZK_CODIGO
		DBSEEK(XFILIAL("ZZK")+M->ZZK_CODIGO,.T.)
		CODIGO_NOT := M->ZZK_CODIGO

		WHILE !EOF() .AND. ZZK->ZZK_FILIAL  == XFILIAL("ZZK") .AND. ;
		ZZK->ZZK_CODIGO   == M->ZZK_CODIGO
			WHILE !RECLOCK("ZZK",.F.) ; ENDDO
			DBSELECTAREA("ZZK")
			DELETE
			MSUNLOCK()
			DBSKIP()
		ENDDO
		//������������������������������������������������������������������Ŀ
		//� GRAVA ZZK - CADASTRO DE DESPESAS DE IMPORTACAO                   �
		//��������������������������������������������������������������������
		FOR I := 1 TO LEN(ACOLS)
			//����������������������������������������������������������������������Ŀ
			//� VERIFICA SE O ITEM FOI DELETADO, SE NAO, FAZ SUA INCLUSAO            �
			//������������������������������������������������������������������������
			IF  !ACOLS[I,NUSADO+1]
				IF RECLOCK("ZZK",.T.)

					ZZK->ZZK_FILIAL     := XFILIAL("ZZK")
					//CAMPOS DO ENCHOICE
					ZZK->ZZK_CODIGO	:= CODIGO_NOT
					ZZK->ZZK_NOTAS	:= _NOTAS 
					ZZK->ZZK_NOTAS2	:= _NOTAS2
					ZZK->ZZK_NOTAS3	:= _NOTAS3										
					ZZK->ZZK_DTEMIS	:= _DTEMIS
					ZZK->ZZK_DTPAGT := _DTPAGT 
					ZZK->ZZK_DTENT  := _DTENT		
					ZZK->ZZK_FORNEC := _FORNEC
					ZZK->ZZK_LOJA 	:= _LOJA

					//CAMPOS DO ACOLS
					//ZZK->ZZK_TIPDES		:= IIF(I=1, 2, 3)
					ZZK->ZZK_TIPDES		:= GDFIELDGET("ZZK_TIPDES",I)
					ZZK->ZZK_DESCDE		:= GDFIELDGET("ZZK_DESCDE",I)
					ZZK->ZZK_VALOR		:= GDFIELDGET("ZZK_VALOR",I)					
					ZZK->(MSUNLOCK())					

				ENDIF
			ENDIF
		NEXT
		CASE LEXCLUIR
		//	IF SZW->ZW_CODIGO = "0"
		//	MSGBOX("N�O � PERMITIDA A EXCLUSAO DO TITULO","INFO","INFO")
		//	RETURN
		//END IF
		//������������������������������������������������������������������Ŀ
		//� EXCLUI ZZK - CADASTRO DE DEFEITOS DOS BLOCOS                     �
		//��������������������������������������������������������������������
		DBSELECTAREA("ZZK")
		DBSETORDER(1) // ZW_CODIGO
		M->ZZK_CODIGO   := ZZK->ZZK_CODIGO
		DBSEEK(XFILIAL("ZZK")+M->ZZK_CODIGO,.T.)
		WHILE !EOF() .AND. ZZK->ZZK_FILIAL  == XFILIAL("ZZK") .AND. ;
		ZZK->ZZK_CODIGO   == M->ZZK_CODIGO
			WHILE !RECLOCK("ZZK",.F.) ; ENDDO
			ZZK->(DBSETORDER(1))
			IF ZZK->(DBSEEK(XFILIAL("ZZK")+M->ZZK_CODIGO)) == .T.
				//IF SZW->ZW_SITUACA <> "L"
				//	ALERT("NAO PODE EXCLUIR OS DEFEITOS DESTE BLOCO, POIS O MESMO NAO ESTA LIBERADO...")
				//	RETURN
				//ENDIF
			ENDIF
			DBSELECTAREA("ZZK")
			DELETE
			MSUNLOCK()
			DBSKIP()
		ENDDO
	ENDCASE

	DBCOMMITALL()

RETURN        