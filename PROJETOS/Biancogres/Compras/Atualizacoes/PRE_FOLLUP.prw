#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} PRE_FOLLUP
@author MADALENO
@since 29/03/10
@version 1.0
@description PREENCHE A OBSERVACAO DO FOLLUP
@type function
/*/


USER FUNCTION PRE_FOLLUP()

	IF ALTERA .OR. INCLUI .OR. TYPE("CA120NUM") = "U"
		ALERT("SO � PERMITIDO INCLUIR FOLLOW QUANDO ESTIVER VISUALIZANDO O PEDIDO","Alerta","STOP")
		RETURN
	END IF

	IF !U_VALOPER("008",.F.) 
		RETURN
	END IF

	IF Alltrim(FUNNAME()) <> "MATA121"
		RETURN
	END IF

	PRIVATE ASTRUCT 	:= {}
	PRIVATE LREFRESH 	:= .T.
	PRIVATE AHEADER 	:= {}
	PRIVATE ACOLS		:= {}

	If dtos(Date()) >= "20200211"
		MsgALERT("A partir de 11/02/20 esta op��o foi descontinuada. Favor utilizar a Tela de follow-up - programa BIA658.", "PRE_FOLLUP")
		Return
	EndIf


	CSQL := "SELECT * FROM "+RETSQLNAME("SC7")+" WHERE C7_NUM = '"+CA120NUM+"' AND D_E_L_E_T_ = '' AND C7_QUANT - C7_QUJE <> 0 "
	IF CHKFILE("__TRAB")
		DBSELECTAREA("__TRAB")
		DBCLOSEAREA()
	ENDIF
	TCQUERY CSQL ALIAS "__TRAB" NEW
	IF __TRAB->(EOF())
		RETURN
	END IF

	DEFINE DIALOG ODLG TITLE "PREENCHIMENTO FOLLUP" FROM 100,300 TO 500,1100 PIXEL

	AADD(AHEADER,{"R_E_C_N_O_"	,"R_E_C_N_O_"	,""	,6	,0,"","","C","","" })
	AADD(AHEADER,{"ITEM"	    ,"ITEM"			,""	,2	,0,"","","C","","" })
	AADD(AHEADER,{"PRODUTO"		,"PRODUTO"		,""	,10	,0,"","","C","","" })
	AADD(AHEADER,{"DESCRICAO"	,"DESCRICAO"	,""	,30	,0,"","","C","","" })
	AADD(AHEADER,{"FOLLOW"		,"FOLLOW"		,""	,50	,0,"","","C","","" })

	AADD(ASTRUCT,{"R_E_C_N_O_"	,"C",6	,0})
	AADD(ASTRUCT,{"ITEM"		,"C",2	,0})
	AADD(ASTRUCT,{"PRODUTO"		,"C",10	,0})
	AADD(ASTRUCT,{"DESCRICAO"	,"C",30	,0})
	AADD(ASTRUCT,{"FOLLOW"		,"C",50	,0})

	IF CHKFILE("_TRB")
		DBSELECTAREA("_TRB")
		DBCLOSEAREA()
	ENDIF
	CCRIATRAB := CRIATRAB(ASTRUCT)
	DBUSEAREA (.T., __LOCALDRIVER, CCRIATRAB, "_TRB")

	PREENCHE_ARQUIVO()
	OGETDB := MSGETDB():NEW(05,05,150,400,3,,,,.F.,{"R_E_C_N_O_","ITEM","PRODUTO","DESCRICAO","FOLLOW"},1,.F.,,"_TRB",,,.F.,ODLG, .T., ,,)

	oTHButton := THButton():New(180,05,"CONFIRMA ALTERA��O"	,ODLG,{|| __GRAVA() },55,10,,"CONFIRMA A ALTERA��O DOS CAMPO")
	oTHButton := THButton():New(180,350,"CANCELA ALTERA��O"	,ODLG,{|| ODLG:End() },55,10,,"CANCELA ALTERA��O")

	ACTIVATE DIALOG ODLG CENTERED

	n := 1

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���PROGRAMA  �PREENCHE_ARQUIVO  � MADALENO           � DATA �  22/02/10   ���
�������������������������������������������������������������������������͹��
���DESC.     � FUNCAO PARA MONTAR O ARQUIVO COM OS HORARIOS               ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION PREENCHE_ARQUIVO()

	PRIVATE CSQL	:= ""
	PRIVATE ENTER := CHR(13) + CHR(10)

	CSQL := "SELECT * FROM "+RETSQLNAME("SC7")+" WHERE C7_NUM = '"+CA120NUM+"' AND D_E_L_E_T_ = '' AND C7_QUANT - C7_QUJE <> 0 "
	IF CHKFILE("__TRAB")
		DBSELECTAREA("__TRAB")
		DBCLOSEAREA()
	ENDIF
	TCQUERY CSQL ALIAS "__TRAB" NEW

	IF __TRAB->(EOF())
		RETURN
	END IF

	WHILE ! __TRAB->(EOF())
		RECLOCK("_TRB",.T.)
		_TRB->R_E_C_N_O_	:= ALLTRIM(STR(__TRAB->R_E_C_N_O_))
		_TRB->ITEM			:= __TRAB->C7_ITEM
		_TRB->PRODUTO 		:= ALLTRIM(__TRAB->C7_PRODUTO)
		_TRB->DESCRICAO		:= ALLTRIM(__TRAB->C7_DESCRI)
		_TRB->FOLLOW		:= ALLTRIM(__TRAB->C7_YFOLLOW)
		_TRB->(MSUNLOCK())

		__TRAB->(DBSKIP())
	END

RETURN

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �__GRAVA   � Autor � J. Ricardo            � Data �23/02/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � GRAVA AS ALTERA��ES REALIZADAS                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � _AJU_SP8                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

STATIC Function __GRAVA()

	ODLG:End()

	_TRB->(DbGoTop())
	WHILE 	! _TRB->(EOF())
		CSQL := " UPDATE "+RETSQLNAME("SC7")+" SET C7_YFOLLOW = '"+_TRB->FOLLOW+"' "
		CSQL += " WHERE R_E_C_N_O_ = '"+_TRB->R_E_C_N_O_+"' "
		TCSQLEXEC(CSQL)
		_TRB->(DBSKIP())
	END

RETURN
