#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "Protheus.ch"


User Function OSPARAM()

Local 		aArea := GetArea()
Local		cTitulo		:= "Parametros de Inspecao"
Local		aCab			:= {}						// Array com descricao dos campos do Cabecalho do Modelo 2
Local		aRoda			:= {}						// Array com descricao dos campos do Rodape do Modelo 2
Local		aGrid			:= {044,005,300,700}		// Array com coordenadas da GetDados no modelo2 - Padrao: {044,005,118,315}
Local		cLinhaOk		:= "AllwaysTrue()"			// Validacoes na linha da GetDados da Modelo 2
Local		cTudoOk			:= "AllwaysTrue()"			// Validacao geral da GetDados da Modelo 2
Local		lRetMod2		:= .F.
Local		nColuna			:= 0

Private		aColsBKP		:= AClone(aCols)
Private		aHeaderBKP 		:= AClone(aHeader) 
Private		__NBKP 			:= N

Private cOSNUM				:= M->AB9_NUMOS
Private cOSSEQ				:= M->AB9_SEQ

aCols			:= {}
aHeader	   		:= {}

// Monta do array de cabecalho
aAdd(aCab,{"cOSNUM"	,	{017,010}, "Numero da OS/Item:","@!",,,.F.})
aAdd(aCab,{"cOSSEQ",	{017,160}, "Sequencia Atend.: ","@!",,,.F.})

//Cria aHeader e aCols                                         �

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SZ3")
While !Eof() .and. x3_arquivo=="SZ3"
	If X3USO(x3_usado) .and. cNivel >= x3_nivel .and. !(Alltrim(x3_campo) $ "Z3_NUMOS###Z3_SEQOS")
		Aadd(aHeader,{ TRIM(X3Titulo())	,;
		x3_campo				,;
		x3_picture			,;
		x3_tamanho			,;
		x3_decimal			,;
		x3_valid				,;
		x3_usado				,;
		x3_tipo				,;
		x3_arquivo			,;
		x3_context			,;
		x3_relacao			,;
		x3_reserv			})
	Endif
	SX3->(DbSkip())
Enddo

DbSelectArea("SZ3")
SZ3->(DbSetOrder(1))
If SZ3->(DbSeek(xFilial("SZ3")+cOSNUM+cOSSEQ))
	While !SZ3->(Eof()) .and. SZ3->(Z3_FILIAL+Z3_NUMOS+Z3_SEQOS) == (xFilial("SZ3")+cOSNUM+cOSSEQ)
		
		AADD(aCols,Array(Len(aHeader)+1))
		
		For _ni := 1 to Len(aHeader)
			if AllTrim(aHeader[_ni,2]) <> "Z3_DESC"
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			else
				aCols[Len(aCols),_ni] := Posicione("SZ2",1,xFilial("SZ2") + SZ3->Z3_PARAM ,"Z2_DESC")
			endif
		Next
		
		aCols[Len(aCols),Len(aHeader)+1] := .F.
		SZ3->(DbSkip())
	EndDo
Else
	AADD(aCols,Array(Len(aHeader)+1))
	For _ni := 1 to Len(aHeader)
		aCols[Len(aCols),_ni] := CriaVar(aHeader[_ni,2])
	Next
	aCols[Len(aCols),Len(aHeader)+1] := .F.
EndIf

// Monta a Tela Modelo2
lRetMod2 := Modelo2(cTitulo,aCab,aRoda,aGrid,3,cLinhaOk,cTudoOk,,,,,,,.T.)

If lRetMod2
	
	SZ3->(DbSetOrder(1))
	If SZ3->(DbSeek(xFilial("SZ3")+cOSNUM+cOSSEQ))
		While !SZ3->(Eof()) .and. SZ3->(Z3_FILIAL+Z3_NUMOS+Z3_SEQOS) == (xFilial("SZ3")+cOSNUM+cOSSEQ)
			RecLock("SZ3",.F.)
			SZ3->(DbDelete())
			SZ3->(MsUnlock())
			
			SZ3->(DbSkip())
		EndDo
	EndIf
	
	FOR I := 1 TO LEN(aCols)
		
		If !(aCols[I][Len(aHeader)+1])
			
			RecLock("SZ3",.T.)
			SZ3->Z3_FILIAL := XFILIAL("SZ3")
			SZ3->Z3_NUMOS := cOSNUM
			SZ3->Z3_SEQOS := cOSSEQ
			
			For _ni := 1 to Len(aHeader)-1
				
				If AllTrim(aHeader[_ni,2]) <> "Z3_DESC"
					&("SZ3->"+AllTrim(aHeader[_ni,2])) := aCols[I][_ni]
				EndIf
				
			Next
			
			SZ3->(MsUnlock())
			
		EndIf
		
	NEXT I
	
EndIf


aCols			:= AClone(aColsBKP)
aHeader	   		:= AClone(aHeaderBKP)   
N				:= __NBKP
RestArea(aArea)

Return
