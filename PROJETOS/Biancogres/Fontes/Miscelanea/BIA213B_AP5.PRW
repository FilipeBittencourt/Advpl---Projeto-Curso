#include "rwmake.ch"
#include "TOPCONN.ch"
/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    � BIA213B    � Autor � Marcelo Ventura Felix � Data �13/04/2000潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Autoriza嚻o de Entrega - valid do codigo do produto          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Interpretador xBase                                          潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

User Function BIA213B()

SetPrvt("LRET,NSLDE,ACOLS,ACOLSS,")

dbSelectArea( "SC3" )
DbSetOrder(6)

If !dbseek(xFilial("SC3")+PADR(M->PRODUTO,TamSX3("B1_COD")[1],"")+aCols[n,1])
	msgstop("Produto sem contrato de parceria!")
	lRet := .F.
Else
	
	dbSelectArea( "SB1" )
	dbseek(xFilial("SB1")+M->PRODUTO)
	dbSelectArea( "SC3" )
	
	If SB1->(eof())
		msgstop("Produto sem descricao generica!")
	Else
		nSldE := 0.00
		Do While SC3->C3_PRODUTO == SB1->B1_COD .and. nSldE == 0.00 .and. SC3->C3_LOCAL == aCols[n,1]   //Ranisses
			If SC3->C3_QUANT - SC3->C3_QUJE > 0.00 .AND. SC3->C3_RESIDUO <> "S" .AND. SC3->C3_PRECO > 0 .And. dDataBase <= SC3->C3_DATPRF
				aCols[n,7] := SB1->B1_DESC
				If n > len(aColsS)
					* Completa tabela de saldos
					Do While len(aCols) > len(aColsS)
						aadd(aColsS,{space(2),space(6),space(2),space(6),space(TamSX3("B1_COD")[1]),0,ctod("  "),0,00})
					EndDo
				EndIf
				aColsS[n,1] := SC3->C3_FILIAL
				aColsS[n,2] := SC3->C3_NUM
				aColsS[n,3] := SC3->C3_ITEM
				aColsS[n,4] := SC3->C3_FORNECE
				aColsS[n,5] := PADR(SC3->C3_PRODUTO,TamSX3("B1_COD")[1],"")
				aColsS[n,6] := aCols[n,3]
				aColsS[n,7] := aCols[n,5]
				
				CSQL := "SELECT ISNULL(SUM(C3_QUANT - C3_QUJE),0) AS SALDO "
				CSQL += "FROM "+RETSQLNAME("SC3")+" "
				CSQL += "WHERE	C3_PRODUTO = '"+ALLTRIM(SC3->C3_PRODUTO)+"'AND "
				CSQL += "		C3_RESIDUO <> 'S' AND "
				CSQL += "		D_E_L_E_T_ = '' "
				IF chkfile("_CTRAB")
					dbSelectArea("_CTRAB")
					dbCloseArea()
				ENDIF
				TCQuery CSQL Alias "_CTRAB" New
				
				aColsS[n,8] := _CTRAB->SALDO // SC3->C3_QUANT - SC3->C3_QUJE ALTERADO POR MADALENO 24 /10 /08
				aColsS[n,9] := SC3->C3_LOCAL
				nSldE := SC3->C3_QUANT - SC3->C3_QUJE
				lRet := .T.
			Else
				IF SC3->C3_PRECO <= 0
					msgstop("Produto: "+ALLTRIM(SC3->C3_PRODUTO)+" do Contrato: "+ALLTRIM(SC3->C3_NUM)+" sem pre鏾 cadastrado!")
				ENDIF
				DbSkip()
			EndIf
		EndDo
		
		If nSldE == 0.00
			msgstop("Produto sem saldo para entrega ou eliminado por Residuo!")
			lRet := .F.
		EndIf
	EndIf
EndIf
SC3->(DbSetOrder(1))

Return(lRet)
