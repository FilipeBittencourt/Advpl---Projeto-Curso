#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 16/05/02
#Include "topconn.ch"
User Function BIA019()        // incluido pelo assistente de conversao do AP5 IDE em 16/05/02

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
	//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
	//� identificando as variaveis publicas do sistema utilizadas no codigo �
	//� Incluido pelo assistente de conversao do AP5 IDE                    �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

	Local i
	SetPrvt("WOPCAO,LVISUALIZAR,LINCLUIR,LALTERAR,LEXCLUIR,NOPCE")
	SetPrvt("NOPCG,COPCAO,NUSADO,AHEADER,ACOLS,I")
	SetPrvt("CTITULO,CALIASENCHOICE,CALIASGETD,CLINOK,CTUDOK,CFIELDOK")
	SetPrvt("ACPOENCHOICE,LRET,WP_EST,WP_CLASSE,WP_VALOR,wP_DTINI,_ACAMPOS")
	SetPrvt("_CTRAB,LSZ1,LSE1,")       

	/*/
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
	굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
	굇쿑un눯o    � BIA019   � Autor � MICROSIGA Vitoria     � Data � 28.05.99 낢�
	굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
	굇쿏escri눯o � Cadastro de Precos - atualizacao                           낢�
	굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
	굇� Uso      � RDMAKE                                                     낢�
	굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
	/*/
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Determina funcao selecionada                                             �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	wOpcao      := paramixb
	lVisualizar := .F.
	lIncluir    := .F.
	lAlterar    := .F.
	lExcluir    := .F.
	Do Case
		Case wOpcao == "V" ; lVisualizar := .T. ; nOpcE := 2 ; nOpcG := 2 ; cOpcao := "VISUALIZAR"
		Case wOpcao == "I" ; lIncluir    := .T. ; nOpcE := 3 ; nOpcG := 3 ; cOpcao := "INCLUIR" 
		Case wOpcao == "A" ; lAlterar    := .T. ; nOpcE := 3 ; nOpcG := 3 ; cOpcao := "ALTERAR" 
		Case wOpcao == "E" ; lExcluir    := .T. ; nOpcE := 2 ; nOpcG := 2 ; cOpcao := "EXCLUIR" 
	EndCase
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Cria variaveis                                                           �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	RegToMemory("SZ2",(cOpcao=="INCLUIR"))
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Monta aHeader                                                            �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("SX3")
	dbSetOrder(2)
	nUsado  := 0
	aHeader := {}
	dbSeek("Z1_EST    ") ; nUsado:=nUsado+1 ; aadd(aHeader,{trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"AllwaysTrue()",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT,SX3->X3_NIVEL})
	dbSeek("Z1_CLASSE ") ; nUsado:=nUsado+1 ; aadd(aHeader,{trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"AllwaysTrue()",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT,SX3->X3_NIVEL})
	dbSeek("Z1_VALOR  ") ; nUsado:=nUsado+1 ; aadd(aHeader,{trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"AllwaysTrue()",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT,SX3->X3_NIVEL})
	dbSeek("Z1_DTINIPR") ; nUsado:=nUsado+1 ; aadd(aHeader,{trim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"AllwaysTrue()",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT,SX3->X3_NIVEL})
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Monta aCols                                                              �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If  lIncluir
		aCols             := {array(nUsado+1)}
		aCols[1,nUsado+1] := .F.
		For i := 1 to nUsado
			aCols[1,i] := CriaVar(aHeader[i,2])
		Next
	Else
		aCols:={}
		dbSelectArea("SZ1")
		dbSetOrder(2)
		dbSeek(xFilial("SZ1")+M->Z2_REFER+dtos(M->Z2_DTINIPR))
		While !eof() .and. SZ1->Z1_FILIAL  == xFilial("SZ1") ;
		.and. SZ1->Z1_REFER   == M->Z2_REFER ;
		.and. SZ1->Z1_DTINIPR   == M->Z2_DTINIPR 
			aadd(aCols,array(nUsado+1))
			For i := 1 to nUsado
				aCols[len(aCols),i]    := FieldGet(FieldPos(aHeader[i,2]))
			Next 
			aCols[len(aCols),nUsado+1] := .F.
			dbSkip()
		End
	End
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Inicializa variaveis                                                     �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	cTitulo        := "Cadastro de Precos"
	cAliasEnchoice := "SZ2"
	cAliasGetD     := "SZ1"
	//cLinOk         := "AllwaysTrue()"
	//cLinOk         := "Empty(aCols[n,1]).And.!Empty(aCols[n,2]).And.!Empty(aCols[n,3])"
	cLinOk         := 'EXECBLOCK("BIA311",.F.,.F.)'
	cTudOk         := 'EXECBLOCK("CVALIDAT",.F.,.F.)'
	cFieldOk       := "AllwaysTrue()"
	aCpoEnchoice   := {"Z2_REFER","Z1_DTINIPR","Z2_DTFIMPR"}
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Seleciona ordem                                                          �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("SZ1")
	dbSetOrder(1)
	dbSelectArea("SZ2")
	dbSetOrder(1)
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Executa funcao modelo 3                                                  �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,300)
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Executa processamento                                                    �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If  lRet
		fProcessa()
	End

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽�
굇쿑un눯o    � fProcessa                                                  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿏escri눯o � Processa confirmacao da tela                               낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 16/05/02 ==> Function fProcessa
Static Function fProcessa()
	local cSQL
	Local i
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Determina posicao dos campos no aCols                                    �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	wP_EST     := aScan(aHeader,{|x| x[2]=="Z1_EST    "})
	wP_CLASSE  := aScan(aHeader,{|x| x[2]=="Z1_CLASSE "})
	wP_VALOR   := aScan(aHeader,{|x| x[2]=="Z1_VALOR  "})
	wP_DTINI   := aScan(aHeader,{|x| x[2]=="Z1_DTINIPR"})


	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Definicao do arquivo de trabalho                                         �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	_aCampos := { {"EST    ","C", 2,0},;
	{"CLASSE ","C", 1,0},;
	{"VALOR  ","N",14,2},;
	{"DataInicio ","D", 8,0}}
	_cTrab := CriaTrab(_aCampos)
	dbUseArea(.T.,,_cTrab,"_cTrab")
	dbCreateInd(_cTrab,"_cTrab",{||EST+CLASSE})
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Monta arquivo de trabalho                                                �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("_cTrab")
	//cSQL := "Select * From " + RETSQLNAME("SZ1") + " "
	//cSQL += "where	Z1_REFER = '"+ M->Z2_REFER + "' AND "
	//cSQL += "	Z1_DTINIPR = '"+ dtos(M->Z2_DTINIPR) + "' " 
	//If chkfile("_cTrab")
	//	dbSelectArea("_cTrab")
	//	dbCloseArea()
	//End If
	//TCQUERY cSQL ALIAS "_cTrab" NEW
	For i := 1 to len(aCols)
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Verifica se o item foi deletado                                      �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If  ! aCols[i,nUsado+1]
			RecLock("_cTrab",.T.)
			_cTrab->EST     := aCols[i,wP_EST    ]
			_cTrab->CLASSE  := aCols[i,wP_CLASSE ]
			_cTrab->VALOR   := aCols[i,wP_VALOR  ]
			_cTrab->DataInicio :=aCols[i,wP_DTINI  ]
			msUnLock()
		End
	Next
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Verifica funcao utilizada                                                �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	Do Case
		Case lIncluir
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Processa arquivo de trabalho                                     �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		dbSelectArea("_cTrab")
		dbGoTop()
		lSZ1     := .F.
		While !eof()
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			//� Grava SZ1 -                                                   �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			dbSelectArea("SZ1")
			RecLock("SZ1",.T.)
			SZ1->Z1_FILIAL  := xFilial("SZ1")
			SZ1->Z1_REFER   := M->Z2_REFER
			SZ1->Z1_CLASSE  := _cTrab->CLASSE
			SZ1->Z1_EST     := _cTrab->EST
			SZ1->Z1_VALOR   := _cTrab->VALOR
			SZ1->Z1_DTINIPR := M->Z2_DTINIPR
			msUnLock()
			lSE1 := .T.
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			//� Acessa proximo registro                                       �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			dbSelectArea("_cTrab")
			dbSkip()
		End
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Grava SZ2                                                        �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If  lSE1
			dbSelectArea("SZ2")
			RecLock("SZ2",.T.)
			SZ2->Z2_FILIAL  := xFilial("SZ2")
			SZ2->Z2_REFER   := M->Z2_REFER
			SZ2->Z2_DTINI   := M->Z2_DTINI
			SZ2->Z2_DTFIM   := M->Z2_DTFIM
			SZ2->Z2_COMISS  := M->Z2_COMISS
			SZ2->Z2_DTINIPR := M->Z2_DTINIPR
			SZ2->Z2_DTFIMPR := M->Z2_DTFIMPR
			msUnLock()
		End
		Case lAlterar
		dbSelectArea("SZ1")       //Z1_DTINIPR   dtos(ACols[n, aScan(aHeader,{|x| x[2]=="Z1_DTINIPR"})])
		dbSetOrder(2)
		dbSeek(xFilial("SZ1")+M->Z2_REFER+ dtos(M->Z2_DTINIPR) ) //dtos(ACols[n, aScan(aHeader,{|x| x[2]=="Z1_DTINIPR"})]) )//dtos(M->Z2_DTINIPR))
		While !eof() .and. SZ1->Z1_FILIAL == xFilial("SZ1") ;
		.and. SZ1->Z1_REFER  == M->Z2_REFER ;
		.and. SZ1->Z1_DTINIPR  == M->Z2_DTINIPR //ACols[n, aScan(aHeader,{|x| x[2]=="Z1_DTINIPR"})]  //M->Z2_DTINIPR 
			While ! RecLock("SZ1",.F.) ; End
			delete
			msUnLock()
			dbSkip()
		End

		dbSelectArea("_cTrab")
		dbGoTop()
		lSZ1     := .F.
		While ! Eof()
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			//� Grava SZ1 -                                                   �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			RecLock("SZ1",.T.)
			SZ1->Z1_FILIAL  := xFilial("SZ2")
			SZ1->Z1_REFER   := M->Z2_REFER
			SZ1->Z1_CLASSE  := _cTrab->CLASSE
			SZ1->Z1_EST     := _cTrab->EST  
			SZ1->Z1_VALOR   := _cTrab->VALOR
			SZ1->Z1_DTINIPR := M->Z2_DTINIPR
			msUnLock()
			lSE1 := .T.
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			//� Acessa proximo registro                                       �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			dbSelectArea("_cTrab")
			dbSkip()
		End
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Grava SZ2                                                        �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If  lSE1
			dbSelectArea("SZ2")
			RecLock("SZ2",.F.)
			SZ2->Z2_REFER   := M->Z2_REFER
			SZ2->Z2_DTINI   := M->Z2_DTINI
			SZ2->Z2_DTFIM   := M->Z2_DTFIM
			SZ2->Z2_COMISS  := M->Z2_COMISS
			SZ2->Z2_DTINIPR	:= M->Z2_DTINIPR
			SZ2->Z2_DTFIMPR	:= M->Z2_DTFIMPR
			msUnLock()
		End
		Case lExcluir
		dbSelectArea("_cTrab")
		dbGoTop()
		lSZ1 := .F.
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		//� Deleta SZ1                                                    �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		dbSelectArea("SZ1")
		dbSetOrder(2)
		dbSeek(xFilial("SZ1")+M->Z2_REFER+dtos(M->Z2_DTINIPR))
		While !eof() .and. SZ1->Z1_FILIAL  == xFilial("SZ1") ;
		.and. SZ1->Z1_REFER   == M->Z2_REFER;
		.and. SZ1->Z1_DTINIPR  == M->Z2_DTINIPR    
			While ! RecLock("SZ1",.F.) ; End
			delete
			lSE1 := .T.
			msUnLock()
			dbSkip()
		End
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� DELETA SZ2                                                       �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If  lSE1
			dbSelectArea("SZ2")
			While ! RecLock("SZ2",.F.) ; End
			delete
			msUnLock()
		End
	EndCase
	dbCommitAll()
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Apaga arquivo de trabalho                                                �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("_cTrab")
	USE
	If  File(_cTrab+".DBF")
		Ferase(_cTrab+".DBF")
		Ferase(_cTrab+".NTX")
		Ferase(_cTrab+".CDX")
	End

Return

