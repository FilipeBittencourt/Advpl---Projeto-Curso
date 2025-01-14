#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 08/03/04

User Function fi52105d()        // incluido pelo assistente de conversao do AP6 IDE em 08/03/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CALIAS,NVALOR,CPREF,CNUM,CPARC,NVLRTIT")
SetPrvt("XVALOR,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � 52105D   � Autor � Cesar Magnago         � Data � 23/08/01 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Execblock para permitir a contabilizacao do valor exato    낢�
굇�          � dos Desc. dos Cheques que substituem os Titulos a Receber. 낢�
굇�          � Lancamento Padronizado 52105 ( Conta a Debito )            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Especifico: INCESA                                         낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/                              
Private aArea := GetArea()

cAlias  := Alias()
nValor  := 0
cPref   := SE1->E1_YPREFOR
cNum    := SE1->E1_YNUMOR
cParc   := SE1->E1_YPARCOR
nVlrTit := SE1->E1_VALOR
xValor  := SE1->E1_DESCONT

DbSelectArea("SE1")
aAreaSE1 := GetArea()
DbSetOrder(1)

If DbSeek(xFilial("SE1")+cPref+cNum+cParc,.F.)
   nValor := If(nVlrTit < SE1->E1_VALOR,SE1->E1_VALOR - nVlrTit,xValor)
Else
   nValor := xValor
Endif
RestArea(aAreaSE1)
DbSelectArea(cAlias)      

RestArea(aArea)
// Substituido pelo assistente de conversao do AP6 IDE em 08/03/04 ==> __Return(nValor)        
Return(nValor)                // incluido pelo assistente de conversao do AP6 IDE em 08/03/04
