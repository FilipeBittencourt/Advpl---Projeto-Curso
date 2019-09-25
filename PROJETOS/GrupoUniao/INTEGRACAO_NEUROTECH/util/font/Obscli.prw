#INCLUDE "rwmake.ch"
#include "COLORS.CH"
#include "FONT.CH"
#include "Dialog.ch"
#include "FiveWin.Ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"


/*/
�Source Detail�����������������������������������������������������������������

@Title     : OBSCLI.prw
@Owner     : Autovix
@CopyRight : Autovix (c) 2010
@Author    : Fabio Loss
@Version   : P10 - Protheus 10
@Date      : 05.02.2001
@Engine    : AdvPl
@Module    : LOJA-Sigaloja, FAT-Faturamento, TMK-Call Center
@DCT       :
@DCO       :

�������������������������������������������������������������������������������

@Descriptions

MOSTRAR AS OBSERVACOES DO CLIENTE NA TELA BALCAO

Descriptions@

�������������������������������������������������������������������������������

@Table

SA1-CADASTRO DE CLIENTES
SUA-ORCAMENTO TELEVENDAS
SL1-ORCAMENTO
SLQ-ORCAMENTO
SC5-PEDIDO
SLR-ITENS DO ORCAMENTO

Table@

�����������������������������������������������������������������Source Detail�
/*/

User function OBSCLI()
	
	Local cfilaux
	Local lRetorno		:= .T.
	Local CDLCRED  		:= ""
	Local nValor   		:= 10.00	// VALOR A SER AVALIADO
	Local cTipoPed 		:= ""
	Local _lAutoriza	:= .T.
	Local cOrigem		:= .F.
	Local aDados 		:= {}
	Local lRet 			:= .F.
	Local _STR0001		:= ""
	Local _STR0002 		:= "CLIENTE BLOQUEADO. DESEJA LIBERAR A VENDA � VISTA ( DINHEIRO, CART�O, CHEQUE OU DEPOSITO ANTECIPADO ) ?"
	Local lSC5			:= If(GetMv("MV_TMKLOJ")=="S",.F.,.T.)
	Local aFiliais		:= TodasFiliais()
	Local i				:= 0
	Local nInativ		:= SuperGetMv('MV_YINATIV',,120)
	Local oBj7001		:= VIXA194():New(.F.)
	
	//��������������������������������������������������������������������Ŀ
	//N�O SER EXECULTADO POR ROTINAS AUTOMATICAS
	//���������������������������������������������������������������������
	
	If AllTrim(FunName()) == "RPC"
		Return _lAutoriza
	EndIf
	
	//��������������������������������������������������������������������Ŀ
	//LOCALIZANDO A ORIGEM DA CHAMADA DO FONTE
	//���������������������������������������������������������������������
	
	DbSelectArea("SA1")
	DbSetOrder(1)   // A1_FILIAL+A1_COD+A1_LOJA
	
	If !oBj7001:VldClienteBalcao()

		Return(.F.)
	
	EndIf

	If Alltrim(FunName()) $ "#UNI021"  		//CALL CENTER
		
		DbSeek( xFilial("SA1") + M->UA_CLIENTE)
		cTipoPed := "N"
		cOrigem	 := "01"
		
	ElseIf Alltrim(FunName()) $ "TMKA271"   //CALL CENTER
		
		DbSeek(xFilial("SA1")+M->UA_CLIENTE)
		cTipoPed := "N"
		cOrigem	 := "02"
		
	ElseIf Alltrim(FunName()) = "MATA410" .or. Alltrim(FunName()) = "MATA103"	//FATURAMENTO
		
		DbSeek(xFilial("SA1")+M->C5_CLIENTE)
		cTipoPed 	:= M->C5_TIPO
		cOrigem	:= "03"
		
	ElseIf Alltrim(FunName()) $ "TMKA380/VXTMK380/#UNI021"   	//CALL CENTER
		
		If Type('M->UA_CLIENTE') != 'U'
			
			DbSeek(xFilial("SA1")+M->UA_CLIENTE)
			
		Else
			nPosEntidade := aScan(oGetDados:aHeader, {|x| AllTrim(x[2]) == 'U6_CODENT'})
			
			If nPosEntidade > 0
				
				cEntidade := oGetDados:aCols[oGetDados:nAt, nPosEntidade]
				
				DbSeek(xFilial("SA1")+AllTrim(cEntidade))
				
			EndIf
			
		EndIf
		
		cTipoPed 	:= "N"
		
		If Type('M->UA_CLIENTE') != 'U'
			cOrigem	:= "01"
		Else
			cOrigem	:= "05"
		EndIf
		
	ElseIf Alltrim(FunName()) = "VIXA176" //Aniversariantes
		
		DbSeek(xFilial("SA1")+TRBSU5->A1_COD+TRBSU5->A1_LOJA)
		
		cTipoPed 	:= 'N'
		cOrigem	:= "06"
		
	ElseIf Alltrim(FunName()) == "MATA415"  		//ORCAMENTO
		
		DbSeek( xFilial("SA1") + M->CJ_CLIENTE)
		cTipoPed := "N"
		cOrigem	 := "07"
		
	ElseIf Alltrim(FunName()) $ "#APROVAORC/APROVAORC"  	//Efetivacao orc
		
		//Registro j� posicionado pela rotina AprovaOrc
		
		DbSeek( xFilial("SA1") + SCJ->CJ_CLIENTE)
		cTipoPed := "N"
		cOrigem	 := "08"
		
	Else
		DbSeek(xFilial("SA1")+M->LQ_CLIENTE)
		cTipoPed 	:= "N"
		cOrigem	:= "04"
		
	EndIf
	
	
	If AllTrim(Funname()) $ "TMKA380/VXTMK380"
		
		If Type('M->UA_CLIENTE') != 'U'
			_lAutoriza := u_VIXA110(M->UA_CLIENTE,M->UA_LOJA)
		Else
			_lAutoriza := u_VIXA110(SubStr(cEntidade, 1, 6),SubStr(cEntidade, 7, 2))
		EndIf
		
		Return _lAutoriza

	//Comentado pois a valida��o para o fonte #UNI021 ser� feito pela neurotech		
	ElseIf AllTrim(Funname()) == "#UNI021" .or. AllTrim(Funname()) == "TMKA271" 	
		_lAutoriza := u_VIXA110(M->UA_CLIENTE,M->UA_LOJA)
		
		Return _lAutoriza
		
	ElseIf Alltrim(FunName()) = "VIXA176" //Aniversariantes
		_lAutoriza := u_VIXA110(TRBSU5->A1_COD , TRBSU5->A1_LOJA)
		
		Return _lAutoriza
		
	ElseIf AllTrim(Funname()) $ "LOJA701/FATA701" .And. GetNewPar("MV_YV110LO", .F.)
	
		If AllTrim(M->LQ_CLIENTE) <> AllTrim(SuperGetmv("MV_CLIPAD",, "000001"))
			
			_lAutoriza := u_VIXA110(M->LQ_CLIENTE, M->LQ_LOJA, , M->LQ_VALBRUT)
			
			Return _lAutoriza
			
		EndIf
		
	Else
		
		If u_VerifCliEmp(SA1->A1_CGC)
			
			Return _lAutoriza
			
		Endif
		
		aAdd(aDados,{SA1->A1_COD,;
			SA1->A1_LOJA,;
			SA1->A1_RISCO,;
			SA1->A1_SALDUP,;
			SA1->A1_LC,;
			SA1->A1_ULTCOM,;
			SA1->A1_OBSERV})
		
		If cTipoPed <> "N"      //SE O TIPO DO PEDIDO FOR DIFERENTE DE NORMAL NAO EXECUTA A VALIDACAO DO CLIENTE
			Return(.T.)
			
		ElseIf !Empty(SA1->A1_OBSERV) .and. !(cOrigem == '08')
			
			MsgInfo(Alltrim(aDados[1,7]))
		EndIf
		
		If aDados[1,3] == 'E'  //A1_RISCO
			
			_lAutoriza 	:= .F.
			nOpcao		:= 1
			
		ElseIf aDados[1,4] >= aDados[1,5] // SA1->A1_SALDUP >= SA1->A1_LC
			
			_lAutoriza := .F.
			nOpcao		:= 2
			
		ElseIf (DDATABASE - aDados[1,6] ) > nInativ  //SA1->A1_ULTCOM
			
			nOpcao := 3
			_lAutoriza	:= .F.
			
		Else
			
			cfilaux	:= cfilant
			
			For i:= 1 to Len(aFiliais)
				
				If lretorno
					
					cfilant	:= aFiliais[i]
					lRetorno:= MAAVALCRED(SA1->A1_COD,SA1->A1_LOJA,nValor,1,.F.,@CDLCRED)
					
				EndIf
				
			Next
			
			cfilant := cfilaux
			
			If !lRetorno
				nOpcao		:=	4
				_lAutoriza 	:= .F.
			Else
				_lAutoriza	:= .T.
			EndIf
			
		EndIf
		
		If !_lAutoriza
			
			Do Case
			Case nOpcao = 1 ; _STR0001 := "RISCO E - SOLICITAR LIBERACAO! "
			Case nOpcao = 2 ; _STR0001 := "LIMITE DE CREDITO EXCEDIDO ! "
			Case nOpcao = 3 ; _STR0001 := "CLIENTE INATIVO POR MAIS DE 180 DIAS - VERIFICAR CADASTRO "
			Case nOpcao = 4 ; _STR0001 := "FAVOR ENTRAR EM CONTATO COM O DEPTO FINANCEIRO ! "
			EndCase
					
			//Chamado 5166 - Service Desk
			IF SuperGetMV("MY_YVAVISTA",.F.,.F.) 
					Alert(_STR0001)
				Return	.F.
			End If	
			
			If lSC5 //Integra��o Call Center x Loja
				Aviso("Aten��o","****"+AllTrim(_STR0001)+"****",{"Voltar"})
				_lAutoriza	:= .F.
				
			ElseIf cOrigem == "04"  //Venda Assistida
				
				IIf( _lAutoriza := ApMsgNoYes(_STR0001 + _STR0002,"ATEN��O!"),M->LQ_YCGC := "OK",)
				
				
			ElseIf cOrigem == "07"  //Orcamento
				
				IIf( _lAutoriza := ApMsgNoYes(_STR0001 + _STR0002,"ATEN��O!"),M->CJ_YCGC := "OK",)
				
			ElseIf cOrigem == "08"  //Efetiva��o or�amento

				Aviso("Aten��o","Obs Cli: " + Alltrim(aDados[1,7]) + Chr(13) + Chr(10);
					+ Chr(13) + Chr(10) +  ;
					"Bloqueio: " + _STR0001 ,{"Voltar"})
					
				_lAutoriza:= .F.
				
			ElseIf cOrigem == "01" .or.  cOrigem == "02" //Call Center
				
				IIf( _lAutoriza := ApMsgNoYes(_STR0001 + _STR0002,"ATEN��O!"),M->UA_YCONDPG := "AV",)
				
			ElseIf cOrigem == "03"  //faturamento
				
				Aviso("Aten��o","****"+AllTrim(_STR0001)+"****",{"Voltar"})
				
				_lAutoriza	:= .F.
			EndIf
			
		Else
			If cOrigem == "01"
				M->UA_YCONDPG := ''
			ElseIf cOrigem == "04"
				M->LQ_YCGC
			Endif
			
		Endif
		
	EndIf

	
Return _lAutoriza

Static Function TodasFiliais()
	
	Local aFiliais 	:= {}
	Local nRecSM0	:= SM0->(Recno())
	
	SM0->(dbSeek(cEmpAnt))
	While SM0->(!Eof()) .and. SM0->M0_CODIGO == cEmpAnt
		
		aAdd(aFiliais,SM0->M0_CODFIL)
		SM0->(dbSkip())
		
	EndDo
	
	SM0->(dbGoTo(nRecSM0))
	
Return aFiliais
