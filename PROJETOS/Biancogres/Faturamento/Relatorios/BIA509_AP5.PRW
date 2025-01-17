#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/01/01
#IFDEF WINDOWS
	#DEFINE SAY PSAY
#ENDIF

User Function Bia509()        // incluido pelo assistente de conversao do AP5 IDE em 29/01/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CDESC1,CDESC2,CDESC3,TITULO,WNREL,TAMANHO")
SetPrvt("CSTRING,ARETURN,ALINHA,NLASTKEY,CPERG,ADRIVER")
SetPrvt("LABORTPRINT,NOMEPROG,WTOTFRET,WTOTICM,CBTXT,CBCONT")
SetPrvt("LI,M_PAG,CABEC1,CABEC2,NTIPO,_ACAMPOS")
SetPrvt("_TMP,WFILIAL,WSERIE,WDOC,WEMISSAO,WFRETAUT")
SetPrvt("WICMAUTO,_SALIAS,AREGS,I,J,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao	   � BIA509	  � Autor � Magnago 		     	    � Data � 24/10/00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escricao � Relatorio de Icms Retido s/ Frete Autonomo			            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso		   � Biancogres												                          낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

#IFDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 29/01/01 ==> 	#DEFINE SAY PSAY
#ENDIF

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis 											 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cDesc1		:= "Este programa emitir� um relatorio de icms retido sobre"
cDesc2		:= "frete de autonomos conforme parametros informados pelo usuario."
cDesc3		:= ""
titulo		:= "Icms s/Frete de Autonomos"
wnrel 		:="BIA509"
Tamanho		:= "P"
cString		:= "SF2"
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
aLinha		:= { }
nLastKey 	:= 0
cPerg 		:="BIA509"
aDriver		:= ReadDriver()
lAbortPrint := .F.
nomeprog 	:= "BIA509"
wTotFret 	:= 0
wTotIcm		:= 0
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape	 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cbtxt := SPACE(10)
cbcont:= 0
li 	:= 80
m_pag := 0

// 						1			 2 		  3			4			 5 		  6			7			 8 		  9			0			 1 		  2			132
// 			123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
// 			 xxxxxxxxx xxx	  xx/xx/xx	 999,999,999.99	99.99 	  999,999.99
cabec1  := " Docto     Serie  Emissao   Base de Calculo    Aliq     Icms Retido"
Cabec2  := ""

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
nTipo  := IIF(aReturn[4]==1,15,18)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para parametros				   	     �
//� mv_par01				  // Da Serie 					     �
//� mv_par02				  // Ate a Serie 				     �
//� mv_par03				  // Da Emissao					     �
//� mv_par04				  // Ate a Emissao				     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

//ValidPerg() 	 // Cria pergunta caso nao exista

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Definicao do arquivo de trabalho									   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
_aCampos := {	 {"FILIAL" , "C", 02, 0},;
{"SERIE"  , "C", 03, 0},;
{"DOC"    , "C", 09, 0},;
{"EMISSAO", "D", 08, 0},;
{"FRETAUT", "N", 14, 2},;
{"ICMAUTO", "N", 10, 2}}

If chkfile("_TMP")
	dbSelectArea("_TMP")
	dbCloseArea()
EndIf

_cTrab := CriaTrab(_aCampos, .T.)
DbUseArea(.T.,,_cTrab,"_TMP")
DbCreateInd(_cTrab,"FILIAL+SERIE+DOC",{||FILIAL+SERIE+DOC})

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT 						 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.f.,Tamanho)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas 							 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
pergunte("BIA509",.F.)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

titulo  := "Relatorio de ICMS Retido sobre frete de autonomos"

RptStatus({|| R509IMP() })// Substituido pelo assistente de conversao do AP5 IDE em 29/01/01 ==> RptStatus({|| Execute(R509IMP) })

Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o	 � R509IMP	� Autor � Joao Carlos de Andrade� Data � 19.09.00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Chamada do Relatorio 									  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso		 � BIA509													  낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 29/01/01 ==> Function R509IMP
Static Function R509IMP()

DbSelectArea("SF2")
DbSetOrder(17)  //V12 - foram adicionados 6 indices no SF2
DbSeek(xFilial("SF2")+dtos(mv_par03),.T.)

While !Eof()
	
	//Seleciona NF dentro da Emissao dos Parametros
	If (F2_EMISSAO < mv_par03) .Or. (F2_EMISSAO > mv_par04)
		//If (F2_EMISSAO >= mv_par03) .AND. (F2_EMISSAO <= mv_par04)
		DbSkip()
		Loop
	EndIf
	
	//Seleciona NF dentro do Prefixo dos Parametros
	If (F2_SERIE < mv_par01) .Or. (F2_SERIE > mv_par02)
		//If (F2_SERIE >= mv_par01) .AND. (F2_SERIE <= mv_par02)
		DbSkip()
		Loop
	EndIf
	
	//Seleciona Somente NF's que tem ICMS Autonomo
	If (F2_ICMAUTO == 0)
		DbSkip()
		Loop
	EndIf
	
	wFilial  := F2_FILIAL
	wSerie   := F2_SERIE
	wDoc	 := F2_DOC
	wEmissao := F2_EMISSAO
	wFretaut := F2_FRETAUT
	wIcmauto := F2_ICMAUTO
	
	GravaReg()

	DbSelectArea("SF2")
	DbSetOrder(17)
	DbSkip()
	
EndDo

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Impressao do Relatorio										 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
setprc(0,0)
DbSelectArea("_TMP")
DbGotop()
SetRegua(RecCount())
While ! Eof()
	
	IncRegua()
	
	If Interrupcao(@lAbortPrint)
		Exit
	Endif
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Cabecalho 													 �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Impressao do Relatorio										 �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	@ li, 001 PSay _TMP->Doc
	@ li, 011 PSay _TMP->Serie
	@ li, 018 PSay _TMP->Emissao Picture "@D"
	@ li, 029 PSay Transform(_TMP->Fretaut,"@E 99,999,999.99")
	@ li, 046 PSay Transform(12,"@E 99.99")
	@ li, 057 PSay Transform(_TMP->Icmauto,"@E 999,999.99")
	li := li + 1
	wTotFret	:= wTotFret	+ _TMP->Fretaut //wFretaut
	wTotIcm 	:= wTotIcm	+ _TMP->Icmauto
	DbSkip()

EndDo

li := li + 1
@ li,001 PSay Replicate("-",80)
li := li + 1
@ li, 001 PSay "T O T A I S"
@ li, 029 PSay Transform(wTotFret,"@E 99,999,999.99")
@ li, 057 PSay Transform(wTotIcm,"@E 999,999.99")
li := li + 1
@ li,001 Psay Replicate("-",80)
li := li + 1

roda(cbcont,cbtxt,Tamanho)

Set device to Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

dbSelectArea("_TMP")
Use
If File(_cTrab+".DBF")
	Ferase(_cTrab+".DBF")
	Ferase(_cTrab+".*")
EndIf

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o	 쿣ALIDPERG � Autor � Joao Carlos de Andrade� Data � 12/09/00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Verifica as perguntas incluindo-as caso nao existam		  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so		 � Especifico - Incesa										  낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 29/01/01 ==> Function ValidPerg
/*Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
aRegs:={}
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

AADD(aRegs,{cPerg,"01","Da Filial          ?","mv_ch1","C",2 ,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate a Filial       ?","mv_ch2","C",2 ,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da Emissao         ?","mv_ch3","D",8 ,0,0,"G","","mv_par03","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate a Emissao      ?","mv_ch4","D",8 ,0,0,"G","","mv_par04","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
If !dbSeek(cPerg+aRegs[i,2])
RecLock("SX1",.T.)
For j:=1 to FCount()
FieldPut(j,aRegs[i,j])
Next
MsUnlock()
dbCommit()
Endif
Next

dbSelectArea(_sAlias)

Return*/

/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o	 � GravaReg   � Autor � Cesar Magnago		  � Data � 04/05/99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o � Rotina para gravar o arquivo de trabalho	                    낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso		 � Interpretador xBase											낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 29/01/01 ==> Function GravaReg
Static Function GravaReg()

DbSelectArea("_TMP")

RecLock("_TMP",.T.)
_TMP->FILIAL   := wFilial
_TMP->SERIE	   := wSerie
_TMP->DOC	   := wDoc
_TMP->EMISSAO  := wEmissao
_TMP->FRETAUT  := wFretaut
_TMP->ICMAUTO  := wIcmauto

Return
