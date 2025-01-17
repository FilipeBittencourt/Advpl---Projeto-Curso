#include "rwmake.ch"
#include "topconn.ch"

User Function F02001()

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
	//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
	//� identificando as variaveis publicas do sistema utilizadas no codigo �
	//� Incluido pelo assistente de conversao do AP5 IDE                    �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	Local wNum

	Private cArq	:= ""
	Private cInd	:= 0
	Private cReg	:= 0

	cArq := Alias()
	cInd := IndexOrd()
	cReg := Recno()

	/*/
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
	굇旼컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
	굇쿑un뇚o    � F02001     � Autor �                       � Data �   /  /   낢�
	굇쳐컴컴컴컴컵컴컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
	굇쿏escri뇙o �                                                              낢�
	굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
	굇� Uso      � Interpretador x Base                                         낢�
	굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
	/*/
	wAlias		:= Alias()
	wPerc  		:= M->C5_YPERC
	wCliente	:= M->C5_CLIENTE
	wLoja		:= M->C5_LOJACLI

	//Localiza Cliente
	If Alltrim(M->C5_YLINHA) $ '1_5'
		cSql := "SELECT A1_COD, A1_YDESCLI FROM SA1010 WHERE	A1_COD = '"+M->C5_CLIENTE+"' AND A1_LOJA = '"+M->C5_LOJACLI+"' AND D_E_L_E_T_ = '' "
	Else
		cSql := "SELECT A1_COD, A1_YDESCLI FROM SA1050 WHERE	A1_COD = '"+M->C5_CLIENTE+"' AND A1_LOJA = '"+M->C5_LOJACLI+"' AND D_E_L_E_T_ = '' "
	EndIf
	If chkfile("_CLI")
		dbSelectArea("_CLI")
		dbCloseArea()
	EndIf
	TCQUERY cSql ALIAS "_CLI" NEW

	For wNum := 1 to Len(aCols)
		//Atualiza Politica 
		nPosPerc				:= AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_YPERC'})
		aCols[wNum,nPosPerc]	:= wPerc

		//Atualiza Correcao - busca do cadastro de cliente
		nPosDesc				:= AScan(aHeader, { |x| Alltrim(x[2]) == 'C6_YDESC'})
		aCols[wNum,nPosDesc]	:= _CLI->A1_YDESCLI
	Next

	DbSelectArea(cArq)
	DbSetOrder(cInd)
	DbGoTo(cReg)

	dbSelectArea(wAlias)

Return(wPerc)