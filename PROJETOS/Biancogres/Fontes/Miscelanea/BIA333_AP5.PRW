#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 10/09/03

User Function BIA333()        // incluido pelo assistente de conversao do AP5 IDE em 10/09/03

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
	//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
	//� identificando as variaveis publicas do sistema utilizadas no codigo �
	//� Incluido pelo assistente de conversao do AP5 IDE                    �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	local i
	SetPrvt("_AA021AREA,AHEADER,ACOLS,_COPCAO,_LVISUAL,_LINCLUI")
	SetPrvt("_LALTERA,_LEXCLUI,_AREG,_NOPCE,_NOPCG,M->UZ6_DATA")
	SetPrvt("I,_CTITULO,_CALIASE,_CALIASG,_CLINOK,_CTUDOK")
	SetPrvt("_CFIELDOK,_ACPOE,_LCPOVIRT,_NLINHAS,_AALTERE,_LRET")

	/*/
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
	굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
	굇쿛rograma  �  BIA333  � Autor �   Siga Vitoria        � Data � 18/07/00 낢�
	굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
	굇쿏escricao � Cadastro de Qtd Produzida                                  낢�
	굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
	굇쿢so       � Estoque                                                    낢�
	굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
	/*/
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Salvar area de trabalho atual                                            �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	_aA021AREA := {ALIAS(),INDEXORD(),RECNO()}
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Inicializar variaveis Siga                                               �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	AHEADER := {}
	ACOLS   := {}
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Determinar opcao do usuario                                              �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	_cOPCAO  := PARAMIXB
	_lVISUAL := .F.
	_lINCLUI := .F.
	_lALTERA := .F.
	_lEXCLUI := .F.
	_aREG    := {}
	DO CASE
		CASE _cOPCAO == "V" ; _lVISUAL := .T. ; _nOPCE := 2 ; _nOPCG := 2
		CASE _cOPCAO == "I" ; _lINCLUI := .T. ; _nOPCE := 3 ; _nOPCG := 3
		CASE _cOPCAO == "A" ; _lALTERA := .T. ; _nOPCE := 4 ; _nOPCG := 4
		CASE _cOPCAO == "E" ; _lEXCLUI := .T. ; _nOPCE := 5 ; _nOPCG := 5
	ENDCASE
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Criar variaveis do enchoice                                              �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	UZ6->(REGTOMEMORY("UZ6",_lINCLUI))
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Montar AHEADER                                                           �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	SX3->(DBSEEK("UZ6"))
	WHILE ! SX3->(EOF()) .AND. SX3->X3_ARQUIVO == "UZ6"
		IF ALLTRIM(SX3->X3_CAMPO) $ "UZ6_COD,UZ6_QTDPRO,UZ6_DESC"
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			//� Adiciona no vetor AHEADER                                             �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			AADD(AHEADER,{ SX3->X3_TITULO   , SX3->X3_CAMPO   , ;
			SX3->X3_PICTURE  , SX3->X3_TAMANHO , ;
			SX3->X3_DECIMAL  , SX3->X3_VLDUSER , ;
			SX3->X3_USADO    , SX3->X3_TIPO    , ;
			SX3->X3_ARQUIVO  , SX3->X3_CONTEXT } )
		ENDIF
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		//� Pr쥅imo registro                                                      �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		SX3->(DBSKIP())

	ENDDO
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Montar ACOLS                                                             �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	IF _lINCLUI
		M->UZ6_DATA := DdataBase

		ACOLS := ARRAY(1,LEN(AHEADER)+1)
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		//� Montar ACOLS com uma 즢ica linha                                      �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		FOR i:=1 TO LEN(AHEADER)
			ACOLS[1,i]:=CRIAVAR(AHEADER[i,2])
		ENDFOR
		ACOLS[1,LEN(AHEADER)+1]:=.F.

	ELSE

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		//� Preencher ACOLS                                                       �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

		UZ6->(DbSeek(_cFILUZ6+Dtos(M->UZ6_DATA)))
		WHILE ! UZ6->(EOF()) .AND. XFILIAL("UZ6") == UZ6->UZ6_FILIAL .AND. UZ6->UZ6_DATA == M->UZ6_DATA

			AADD(ACOLS, { UZ6->UZ6_COD,UZ6->UZ6_QTDPRO,UZ6->UZ6_DESC,.F.} )
			AADD(_aREG,  { UZ6->(RECNO())} )

			UZ6->(DBSKIP())
		ENDDO

	ENDIF

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Inicializar variaveis para modelo                                        �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	_cTITULO   := CCADASTRO
	_cALIASE   := "UZ6"
	_cALIASG   := "UZ6"
	_cLINOK    := 'ExecBlock("BIA333L",.F.,.F.)'
	_cTUDOK    := 'ALLWAYSTRUE()'
	_cFIELDOK  := 'ExecBlock("BIA333F",.F.,.F.)'
	_aCPOE     := {"UZ6_DATA"}                   
	_lCPOVIRT  := .T.
	_nLINHAS   := NIL
	_aALTERE   := {}  
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Executa funcao modelo 3                                                  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	_lRET := MODELO3(_cTITULO,_cALIASE,_cALIASG,_aCPOE,_cLINOK,_cTUDOK,_nOPCE,_nOPCG,_cFIELDOK,_lCPOVIRT,_nLINHAS,,,,{0,0,MSADVSIZE()[6],MSADVSIZE()[5]})

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Executa processamento atraves da funcao wfProcessa                       �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	IF _lRET
		fPROCESSA()
	ENDIF
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Restaura area de trabalho                                                �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	DBSELECTAREA(_aA021AREA[1])
	DBSETORDER(_aA021AREA[2])
	DBGOTO(_aA021AREA[3])
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Fim da rotina                                                            �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
RETURN
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽굇
굇쿑un눯o    � fPROCESSA                                                  낢굇
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙굇
굇쿏escri눯o � Processa confirmacao da tela                               낢굇
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 10/09/03 ==> FUNCTION fPROCESSA
Static FUNCTION fPROCESSA()

	Local i

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Controle de atualizacao para inclusao / alteracao                        �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	IF _lINCLUI

		FOR i := 1 TO LEN(ACOLS)
			IF ! ACOLS[i,LEN(AHEADER)+1] //nao deletado
				fUZ6GRAVA()
			ENDIF
		ENDFOR

	ELSEIF _lALTERA

		FOR i := 1 TO LEN(ACOLS)
			_lINCLUI := .T.
			IF _aREG[i,1] > 0
				UZ6->( DBGOTO(_aREG[i,1]) )
				_lINCLUI := .F.
			ENDIF

			IF ACOLS[i,LEN(AHEADER)+1] .AND. _aREG[i,1] > 0
				UZ6->( DBGOTO(_aREG[i,1]) )
				UZ6->(RECLOCK("UZ6",.F.))
				UZ6->(DBDELETE())
				UZ6->(MSUNLOCK())

			ELSE

				IF ! ACOLS[i,LEN(AHEADER)+1]
					fUZ6GRAVA()
				ENDIF

			ENDIF
		ENDFOR

	ELSEIF _lEXCLUI

		UZ6->(DbSeek(_cFILUZ6+Dtos(M->UZ6_DATA),.F.))
		WHILE ! UZ6->(EOF()) .AND. UZ6->UZ6_FILIAL == _cFILUZ6 .AND. UZ6->UZ6_DATA == M->UZ6_DATA
			UZ6->(RECLOCK("UZ6",.F.))
			UZ6->(DBDELETE())
			UZ6->(MSUNLOCK())
			UZ6->(DBSKIP())
		ENDDO
	ENDIF

RETURN(.T.)
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽굇
굇쿑un눯o    � fUZ6GRAVA                                                  낢굇
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙굇
굇쿏escri눯o � Gravar dados no UZ6                                        낢굇
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 10/09/03 ==> FUNCTION fUZ6GRAVA
Static FUNCTION fUZ6GRAVA()
	RECLOCK("UZ6",_lINCLUI)
	UZ6->UZ6_FILIAL  := _cFILUZ6
	UZ6->UZ6_DATA    := M->UZ6_DATA    
	UZ6->UZ6_COD     := ACOLS[i,1]
	UZ6->UZ6_QTDPRO  := ACOLS[i,2]
	UZ6->UZ6_DESC    := ACOLS[i,3]
	UZ6->(MSUNLOCK())

	DbSelectArea("UZ6")

RETURN(.T.)
