#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} A261TOK
@author Marcos Alberto Soprani
@since 20/02/13
@version 1.0
@description Valida movimento de transfer�ncia - Transferencia Mod II
@type function
/*/

User Function A261TOK()
	Local zlRet := .T.
	Local nLocal := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"})
	Local nLocDest := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"},nLocal+1)
	Local nPosPrd := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_COD"})
	Local nPosPrdD := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_COD"},nPosPrd+1)
	Local nPosMat := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_YMATRIC"})

	Local _oMd	:=	TBiaControleMD():New()


	Local I
	
	Local _nQuant			:= 0
	Local _cProd			:= ""
	Local _cLocalOri		:= ""
	Local _oObj				:= Nil
	Local _lValida			:= .T.
	Local _nSaldo			:= 0
	Local _nEmpenhoBizagi	:= 0
	
	//2060352
	For I := 1 To Len(aCols)

		If _oMd:CheckMd(aCols[I][nPosPrd],aCols[I][nLocal]) .And. _oMd:CheckMd(aCols[I][nPosPrdD],aCols[I][nLocDest])
			If (IsBlind())
				Conout("Imposs�vel prosseguir, o produto "+ aCols[I][nPosPrd] +" � MD na ORIGEM e no DESTINO  => MT260TOK")
			Else	
				MsgSTOP("Imposs�vel prosseguir, o produto "+ aCols[I][nPosPrd] +" � MD na ORIGEM e no DESTINO  => MT260TOK")
			EndIf
			Return .F.
		EndIf
	
		If !_oMd:CheckMd(aCols[I][nPosPrd],aCols[I][nLocal]) .And. _oMd:CheckMd(aCols[I][nPosPrdD],aCols[I][nLocDest])
			If (IsBlind())
				Conout("Imposs�vel prosseguir, o produto "+ aCols[I][nPosPrdD] +" n�o � MD na ORIGEM e � MD no DESTINO  => MT260TOK")
			Else	
				MsgSTOP("Imposs�vel prosseguir, o produto "+aCols[I][nPosPrdD]+" n�o � MD na ORIGEM e � MD no DESTINO  => MT260TOK")
			EndIf
			Return .F.
		EndIf
	
		If _oMd:CheckMd(aCols[I][nPosPrd],aCols[I][nLocal]) 
			If Empty(aCols[I][nPosMat])
				If (IsBlind())
					Conout("Imposs�vel prosseguir, o produto "+ aCols[I][nPosPrdD] +" � MD na ORIGEM e o campo Matr�cula precisa ser preenchido!  => MT260TOK")
				Else	
					MsgSTOP("Imposs�vel prosseguir, o produto "+aCols[I][nPosPrdD] +" � MD na ORIGEM e o campo Matr�cula precisa ser preenchido!  => MT260TOK")
				EndIf
				Return .F.
			Else
				_cProd		:= Gdfieldget('D3_COD',	I)
				_cLocalOri	:= Gdfieldget('D3_LOCAL',	I)
				_nQuant 	:= Gdfieldget('D3_QUANT', I)
				
				If _oMd:Saldo(_cProd,_cLocalOri,aCols[I][nPosMat],.F.) < _nQuant
					If (IsBlind())
						Conout("Imposs�vel prosseguir, o produto "+ aCols[I][nPosPrdD] +" pois n�o h� saldo suficiente na matr�cula informada!  => MT260TOK")
					Else	
						MsgSTOP("Imposs�vel prosseguir, o produto "+aCols[I][nPosPrdD] +" pois n�o h� saldo suficiente na matr�cula informada!  => MT260TOK")
					EndIf
					Return .F.					
				Else
					
				EndIf				
			EndIf
		EndIf	
	
	
		wCod 		:= Gdfieldget('D3_COD',I)
		cAlmVend	:= aCols[I][nLocDest]

		DbSelectArea("SB1")
		cArqSB1 := Alias()
		cIndSB1 := IndexOrd()
		cRegSB1 := Recno()
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+wCod,.F.)

		If !(SB1->B1_TIPO $ "PA#PP") .And. cAlmVend $ "02#04"
			MsgBox("Almoxarifado destino incorreto: " + cAlmVend,"A261TOK","STOP")
			zlRet := .F.			
		EndIf
		
		If !(SB1->B1_TIPO $ "PA#PP")
		
			/*--Valida empenho bizagi--*/
			_cProd		:= Gdfieldget('D3_COD',	I)
			_cLocalOri	:= Gdfieldget('D3_LOCAL',	I)
			_nQuant 	:= Gdfieldget('D3_QUANT', I)
			
			
			_oObj		:= TValidaSaldo():New(_cProd, _cLocalOri, _nQuant)
			_lValida	:= _oObj:Check()
			
			_nSaldo			:= _oObj:nSaldo
			_nEmpenhoBizagi	:= _oObj:nEmpenhoBizagi
			zlRet			:= _lValida
			
			If (IsBlind())
				If (!_lValida)
					Conout("Imposs�vel prosseguir, "+cvalTochar(_cProd)+", quantidade da transfer�ncia superior a disponivel no estoque."+CRLF+CRLF+" Saldo: "+cvalTochar(_nSaldo)+""+CRLF+" Empenho Bizagi: "+cvalTochar(_nEmpenhoBizagi)+""+CRLF+" Saldo Disp. Transfer�ncia: "+cvalTochar((_nSaldo - _nEmpenhoBizagi))+" => MT260TOK")
				EndIf
			Else	
				If (!_lValida)
					MsgSTOP("Imposs�vel prosseguir, "+cvalTochar(_cProd)+", quantidade da transfer�ncia superior a disponivel no estoque."+CRLF+CRLF+" Saldo: "+cvalTochar(_nSaldo)+""+CRLF+" Empenho Bizagi: "+cvalTochar(_nEmpenhoBizagi)+""+CRLF+" Saldo Disp. Transfer�ncia: "+cvalTochar((_nSaldo - _nEmpenhoBizagi))+"","MT260TOK")
				EndIf		
			EndIf
			/*--Fim valida empenho bizagi--*/
			
		EndIf


		If cArqSB1 <> ""
			dbSelectArea(cArqSB1)
			dbSetOrder(cIndSB1)
			dbGoTo(cRegSB1)
			RetIndex("SB1")
		EndIf
		
		
	Next
	

	//  Implementado em 20/02/13 por Marcos Alberto Soprani para auxilio do fechamento de estoque vs movimenta��es retroativas que poderiam
	// acontecer pelo fato de o par�mtro MV_ULMES necessitar permanecer em aberto at� que o fechamento de estoque esteja conclu�do
	If Da261Data <= GetMv("MV_YULMES")
		MsgSTOP("Imposs�vel prosseguir, pois este movimento interfere no fechamento de custo!!! Favor verificar com a contabilidade!!!","A261TOK")
		zlRet := .F.
	EndIf

Return ( zlRet )
