#include "rwmake.ch"
#include "topconn.ch"

User Function BIA441()

	/*/
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
	北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
	北矲un噮o    � BIA441     � Autor � MICROSIGA VITORIA     � Data � 24/07/08 潮�
	北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
	北矰escri噭o � Obtem proxima faixa para regra de desconto                   潮�
	北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
	北� Uso      � Interpretador x Base                                         潮�
	北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
	哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
	/*/

	Local i

	Private nFaixa, nPosGrp, cGrupo, nPosPrd, cProduto  

	nPosGrp	 := AScan(aHeader, { |x| Alltrim(x[2]) == 'ACP_GRUPO'})
	cGrupo 	 := aCols[n,nPosgrp]

	nPosPrd	 := AScan(aHeader, { |x| Alltrim(x[2]) == 'ACP_CODPRO'})
	cProduto := aCols[n,nPosPrd]

	nFaixa := 0 

	For i := 1 to n
		IF aCols[i,nPosPrd] == cProduto
			nFaixa := nFaixa + 1
		ENDIF
	Next

	IF nFaixa == 0
		nFaixa := 1
	ENDIF

	DbSelectArea("ACP")    
	DbSetOrder(1)

Return(nFaixa)
