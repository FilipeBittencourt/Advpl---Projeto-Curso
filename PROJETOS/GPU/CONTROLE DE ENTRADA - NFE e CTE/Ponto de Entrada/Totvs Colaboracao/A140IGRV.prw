#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"

#DEFINE DIRXML  "XMLNFE\"
#DEFINE DIRALER "NEW\"
#DEFINE DIRLIDO "OLD\"
#DEFINE DIRERRO "ERR\"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A140IGRV  �Autor  �Ihorran Milholi     � Data �  24/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para ajustes ap�s a inclus�o dos dados na  ���
���          �tabela SDS e SDT                                            ���
�������������������������������������������������������������������������͹��
���Uso       �SIGACOM                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A140IGRV()
	
	Local cDoc		:= ParamIxb[1] //Numero da Nota
	Local cSerie	:= ParamIxb[2] //S�rie da Nota
	Local cFornece	:= ParamIxb[3] //C�digo do Fornecedor
	Local cLoja		:= ParamIxb[4] //Loja do Fornecedor
	Local nFator	:= 0
	Local lAchou	:= .f.
	
	Local cTipoNCM	:= ""
	Local cNCM		:= ""
	Local cCEST  	:= ""
	Local cCodANP	:= ""
	Local cFCI      := ""
	Local cSitTrib	:= ""
	Local cGrTrib	:= ""
	Local cTpConv	:= ""
	
	Local cError	:= ""
	Local cWarning	:= ""
	Local aItens	:= {}
	Local aSitTrib	:= {}
	Local lMudouSB1	:= .f.
	Local nDescTot		:= 0
	Local cFileOpen	:= ""
	Local cXML			:= ""
	Local cBuffer		:= ""
	Local cXMLReturn	:= ""
	Local cEstCred12	:= SuperGetMV("MV_YESTC12",.F.,"AC/AL/MA/AP/BA/CE/DF/GO/AM/MT/MS/PB/PE/PI/RN/RO/RR/SE/TO")
	Local i				:= 0
	Local _oBj			:= VIXA164():New()
	Local lNewColab	:= Findfunction("ColUsaColab") .And. ColUsaColab('6')
	Local cXMLEncod	:= ""
	Local cGrpTrib		:= SuperGetMV("MV_YGRTRIB1",.F.,"002001/002002/002011/002012/016001/016002/016011/016012/017001/017002/017011/017012/018001/018002/018011/018012")	
	Local lRetFilGrp	:= GetNewPar("MV_YA140IG", .T.)
	Local oObjXml 		:= VIXA258():New(cFornece, cLoja, cDoc, cSerie)
	
	Private oXml
	Private oProd
	
	//Vetor com situa��o de tributa��o de ICMS
	aadd(aSitTrib,"00")
	aadd(aSitTrib,"10")
	aadd(aSitTrib,"20")
	aadd(aSitTrib,"30")
	aadd(aSitTrib,"40")
	aadd(aSitTrib,"41")
	aadd(aSitTrib,"50")
	aadd(aSitTrib,"51")
	aadd(aSitTrib,"60")
	aadd(aSitTrib,"70")
	aadd(aSitTrib,"90")
	aadd(aSitTrib,"SN101")
	aadd(aSitTrib,"SN102")
	aadd(aSitTrib,"SN103")
	aadd(aSitTrib,"SN300")
	aadd(aSitTrib,"SN400")
	aadd(aSitTrib,"SN201")
	aadd(aSitTrib,"SN202")
	aadd(aSitTrib,"SN203")
	aadd(aSitTrib,"SN500")
	aadd(aSitTrib,"SN900")

	SDS->(dbSetOrder(1))
	If SDS->(dbSeek(xFilial("SDS")+cDoc+cSerie+cFornece+cLoja))
		
		//Elimina a verifica��o de clientes do grupo
		If u_VerifCliEmp(SDS->DS_CNPJ)
		
			If lRetFilGrp
			
				Conout("MV_YA140IG = .T. - NF-e Marcado como STATUS E (nota entre grupo) - Chave: " + SDS->DS_CHAVENF)
			
				RecLock("SDS", .F.)
				SDS->DS_STATUS := "E"
				SDS->(msUnLock())

			EndIf
	
			Return()
			
		Else
		
			oObjXml:ValidNfe()
			
		Endif
		
		//Grava o XML no campo customizado
		If SDS->(FieldPos("DS_YXML")) > 0
			
			If lNewColab
				
				CKO->(dbSetOrder(1))
				If CKO->(dbSeek(Padr(SDS->DS_ARQUIVO,TamSx3("CKO_ARQUIV")[1])))
					
					cXMLEncod := CKO->CKO_XMLRET
					
				EndIf
				
			Else
				
				cXMLOri	:= ""
				cXMLEncod	:= ""
				cStrXML	:= ""
				nHandle	:= 0
				nPosPesq	:= 0
				nHandle 	:= FOpen(DIRXML+DIRLIDO+SDS->DS_ARQUIVO)
				
				If nHandle <= 0
					
					nHandle := FOpen(DIRXML+DIRALER+SDS->DS_ARQUIVO)
					
				EndIf
				
				nLength := FSeek(nHandle,0,FS_END)
				
				FSeek(nHandle,0)
				
				If nHandle > 0
					
					FRead(nHandle, cXMLOri, nLength)
					FClose(nHandle)
					
					If !Empty(cXMLOri)
						
						If SubStr(cXMLOri,1,1) != "<"
							
							nPosPesq := At("<",cXMLOri)
							cXMLOri  := SubStr(cXMLOri,nPosPesq,Len(cXMLOri))
							
						EndIf
						
					EndIf
					
					cXMLEncod := EncodeUtf8(cXMLOri)
					
					// Verifica se o encode ocorreu com sucesso, pois alguns caracteres especiais
					// provocam erro na funcao de encode, neste caso e feito o tratamento pela funcao A140IRemASC
					If Empty(cXMLEncod)
						
						cStrXML 	:= cXMLOri
						cXMLOri 	:= A140IRemASC(cStrXML)
						cXMLEncod 	:= EncodeUtf8(cXMLOri)
						
					EndIf
					
					If Empty(cXMLEncod)
						cXMLEncod := cXMLOri
					EndIf
					
				EndIf
				
			EndIf
			
			//Grava no registro do totvs colabora��o
			If !Empty(cXMLEncod)
				
				RecLock("SDS",.F.)
				SDS->DS_YXML := cXMLEncod
				SDS->(msUnLock())
				
			EndIf
			
		EndIf
		
		If SDS->DS_TIPO == "N"
			
			If SDS->(FieldPos("DS_YXML")) > 0
				
				cXMLReturn := SDS->DS_YXML
				
			EndIf
			
			If !Empty(cXMLReturn)
				
				oXML := XmlParser(cXMLReturn,"_",@cError,@cWarning)
				
			Else
				
				If lNewColab
					
					CKO->(dbSetOrder(1))
					If CKO->(dbSeek(Padr(SDS->DS_ARQUIVO,TamSx3("CKO_ARQUIV")[1])))
						
						cXMLReturn	:= CKO->CKO_XMLRET
						oXML 		:= XmlParser(cXMLReturn,"_",@cError,@cWarning)
						
					EndIf
					
				Else
					
					oXml := XmlParserFile(AllTrim(DIRXML+DIRLIDO+SDS->DS_ARQUIVO),"_",@cError,@cWarning)
					
				EndIf
				
			EndIf
			
			If Empty(cError) .and. Empty(cWarning)
				
				//-- Extrai tag _InfNfe:_Det
				If Type("oXml:_NFEPROC:_NFE:_InfNfe:_Det") == "O"
					aItens := {oXML:_NFEPROC:_NFE:_InfNfe:_Det}
				ElseIf Type("oXml:_NFEPROC:_NFE:_InfNfe:_Det") == "A"
					aItens := oXML:_NFEPROC:_NFE:_InfNfe:_Det
				EndIf
				
			EndIf
			
			SDT->(dbSetOrder(2))
			If SDT->(dbSeek(xFilial("SDT")+SDS->DS_FORNEC+SDS->DS_LOJA+SDS->DS_DOC+SDS->DS_SERIE))
				
				//Tratamento para modificar a quantidade importada do XML
				While SDT->(!Eof()) .and. SDT->DT_FILIAL+SDT->DT_FORNEC+SDT->DT_LOJA+SDT->DT_DOC+SDT->DT_SERIE == xFilial("SDT")+cFornece+cLoja+cDoc+cSerie
					
					lAchou := .f.
					
					//==================================================================
					//Os campos DT_PEDIDO e DT_ITEMPC est�o sendo limpados, pois quando
					//existem itens com o mesmo produto, o sistema grava o mesmo pedido
					//e item, gerando inconsist�ncias ao gerar o documento de entrada
					//==================================================================
					RecLock("SDT",.F.)
					SDT->DT_PEDIDO	:= ''
					SDT->DT_ITEMPC	:= ''
					SDT->(msUnLock())
					
					//Procura a chave de pesquisa
					For i := 1 to Len(aItens)
						//==============================================================
						//Foi alterada a linha abaixo pois existem notas fiscais que n�o
						//segue a ordem de produtos sequencia. Ex Item 1, item 3, item 4
						//por�m o campo DT_ITEM sempre est� da sequancia, 001,002,003
						//==============================================================
						//If Val(aItens[i]:_nItem:Text) == Val(SDT->DT_ITEM)
						//==============================================================
						If i == Val(SDT->DT_ITEM)
							oProd := aItens[i]
							lAchou:= .t.
							Exit
						EndIf
					Next
					
					If lAchou
						
						SA5->(dbSetOrder(1))
						SA5->(dbSeek(xFilial("SA5")+SDT->DT_FORNEC+SDT->DT_LOJA+SDT->DT_COD))
						
						nFator 	:= iif(SA5->(FieldPos("A5_YCONXML"))>0,SA5->A5_YCONXML,0)
						cTpConv	:= iif(SA5->(FieldPos("A5_YTPCONV"))>0,SA5->A5_YTPCONV,"M")
						cTipoNCM	:= ""
						cNCM		:= ""
						cCEST		:= ""
						cCodANP	:= ""
						cSitTrib	:= ""
						cGrTrib	:= ""
						lMudouSB1	:= .f.
						
						If SDS->(FieldPos("DS_YCFOP")) > 0
							
							//Atualiza CFOP no cabe�alho da nota fiscal
							If Type("oProd:_Prod:_CFOP:Text") <> "U" .and. Empty(SDS->DS_YCFOP)
								
								RecLock("SDS",.f.)
								SDS->DS_YCFOP := oProd:_Prod:_CFOP:Text
								SDS->(msUnLock())
								
							EndIf
							
						EndIf
						
						//Analisa valor de desconto na nota fiscal
						If Type("oProd:_Prod:_VDESC:Text") <> "U"
							
							RecLock("SDT",.f.)
							SDT->DT_VALDESC	:= Round(Val(oProd:_Prod:_VDESC:Text),TamSx3("DT_VALDESC")[2])
							SDT->(msUnLock())
							
							nDescTot += SDT->DT_VALDESC
							
						EndIf
						
						If nFator > 0
							
							Do Case
								
							Case cTpConv == "M"
								
								RecLock("SDT",.f.)
								SDT->DT_QUANT	:= Round(SDT->DT_QUANT*nFator,TamSx3("DT_QUANT")[2])
								SDT->DT_VUNIT	:= Round(SDT->DT_VUNIT/nFator,TamSx3("DT_VUNIT")[2])
								SDT->(msUnLock())
								
							Case cTpConv == "D"
								
								RecLock("SDT",.f.)
								SDT->DT_QUANT	:= Round(SDT->DT_QUANT/nFator,TamSx3("DT_QUANT")[2])
								SDT->DT_VUNIT	:= Round(SDT->DT_VUNIT*nFator,TamSx3("DT_VUNIT")[2])
								SDT->(msUnLock())
								
							EndCase
							
						EndIf
						
						//Recupera valor do IPI
						If Type("oProd:_Imposto:_IPI:_IPITrib:_pIPI:Text") <> "U"
							
							If SDT->(FieldPos("DT_YIPI")) > 0
								
								RecLock("SDT",.f.)
								SDT->DT_YIPI	:= Val(oProd:_Imposto:_IPI:_IPITrib:_pIPI:Text)
								SDT->(msUnLock())
								
							EndIf
							
						EndIf
						
						//Recupera codigo ANP do produto
						If Type("oProd:_Prod:_comb:_cProdANP:Text") <> "U"
							cCodANP	:= oProd:_Prod:_comb:_cProdANP:Text
						EndIf
						
						//Verifica se existe tag NCM
						If Type("oProd:_PROD:_NCM") <> "U"
							cNCM := Padr(oProd:_PROD:_NCM:Text,TamSX3("B1_POSIPI")[1])
						EndIf
						
						//Verifica se existe tag CEST
						If Type("oProd:_PROD:_CEST") <> "U"
							cCEST := oProd:_PROD:_CEST:Text
						Else
							cCEST := ""
						EndIf
						
						//Verifica se existe tag FCI
						If Type("oProd:_PROD:_nFCI") <> "U"
							cFCI := oProd:_PROD:_nFCI:Text
						EndIf
						
						If Type("oProd:_Imposto:_ICMS") <> "U"
							
							nLenSit := Len(aSitTrib)
							For i := 1 To nLenSit
								
								If Type("oProd:_Imposto:_ICMS:_ICMS"+aSitTrib[i]) <> "U" .and. !Empty(&("oProd:_Imposto:_ICMS:_ICMS"+aSitTrib[i]+":_ORIG:TEXT"))
									
									cSitTrib := &("oProd:_Imposto:_ICMS:_ICMS"+aSitTrib[i]+":_ORIG:TEXT")
									If Type("oProd:_Imposto:_ICMS:_ICMS"+aSitTrib[i]+":_CST:TEXT") != 'U'
										cSitTrib += &("oProd:_Imposto:_ICMS:_ICMS"+aSitTrib[i]+":_CST:TEXT")
									EndIf
									
									If SDT->(FieldPos("DT_YPICMS")) > 0
										RecLock("SDT",.f.)
										If Type("oProd:_Imposto:_ICMS:_ICMS"+aSitTrib[i]+":_pICMS:TEXT") != 'U'
											SDT->DT_YPICMS := Val(&("oProd:_Imposto:_ICMS:_ICMS"+aSitTrib[i]+":_pICMS:TEXT"))
										EndIf
										
										If Type("oProd:_Imposto:_ICMS:_ICMS"+aSitTrib[i]+":_vICMSST:TEXT") <> 'U'
											If Type("oProd:_Imposto:_ICMS:_ICMS"+aSitTrib[i]+":_pICMSST:TEXT") <> 'U'
												If Val(&("oProd:_Imposto:_ICMS:_ICMS"+aSitTrib[i]+":_vICMSST:TEXT")) > 0
												
													//Salva Aliquota do ST
													If SDT->(FieldPos("DT_YICMSRE")) > 0
														SDT->DT_YICMSRE := Val(&("oProd:_Imposto:_ICMS:_ICMS"+aSitTrib[i]+":_pICMSST:TEXT"))
													EndIf
													
													//Salva Valor do ST
													If SDT->(FieldPos("DT_VICMST")) > 0
														SDT->DT_VICMST := Val(&("oProd:_Imposto:_ICMS:_ICMS"+aSitTrib[i]+":_vICMSST:TEXT"))
													EndIf													
													
												EndIf
											EndIf
										EndIf
										
										SDT->(msUnLock())
										
									EndIf
									
									Exit
									
								EndIf
								
							Next
							
						EndIf
						
						//Atualiza informa��es do cadastro de produtos
						SB1->(dbSetOrder(1))
						If SB1->(dbSeek(xFilial("SB1")+SDT->DT_COD))
							
							RecLock("SB1",.F.)
							
							//Verifica se o NCM esta cadastrado
							SYD->(dbSetOrder(1))
							If !Empty(cNCM) .and. SYD->(dbSeek(xFilial("SYD")+cNCM))
								
								If SB1->B1_POSIPI <> cNCM
									lMudouSB1 			:= .t.
									SB1->B1_POSIPI	:= cNCM
									SB1->B1_IMPNCM 	:= SYD->YD_ALIQIMP
								EndIf
								
								If SYD->(FieldPos("YD_YTIPO")) > 0
									cTipoNCM := SYD->YD_YTIPO
								EndIf
								
								//If Empty(cCEST) .and. SYD->(FieldPos("YD_YCEST")) > 0
								If SYD->(FieldPos("YD_YCEST")) > 0
									cCEST := SYD->YD_YCEST
								EndIf
								
							Else
								
								cNCM := SB1->B1_POSIPI
								
								//Verifica se o NCM esta cadastrado
								SYD->(dbSetOrder(1))
								If SYD->(dbSeek(xFilial("SYD")+cNCM))
									
									If SYD->(FieldPos("YD_YTIPO")) > 0
										cTipoNCM := SYD->YD_YTIPO
									EndIf
									
									//If Empty(cCEST) .and. SYD->(FieldPos("YD_YCEST")) > 0
									If SYD->(FieldPos("YD_YCEST")) > 0
										cCEST := SYD->YD_YCEST
									EndIf
									
								EndIf
								
							EndIf
							
							//Verifica se o CEST esta cadastrado
							F0G->(dbSetOrder(1))
							If F0G->(dbSeek(xFilial("F0G")+cCEST)) .and. !Empty(cCEST)
								
								If SB1->B1_CEST <> cCEST
									lMudouSB1 		:= .t.
									SB1->B1_CEST	:= cCEST
								EndIf
								
							ElseIf Empty(cCEST)
								
								If !Empty(SB1->B1_CEST)
									lMudouSB1 		:= .t.
									SB1->B1_CEST	:= cCEST
								EndIf
								
							EndIf
							
							// CADASTRAR O CODIGO DA ANP SOMENTE PARA OS PRODUTOS QUE POSSUEM O GRUPO
							// DE TRIBUTA��O DO PARAMETRO. (CHAMADO 2784 - Service Desk)
							
							If (SB1->B1_GRTRIB $ cGrpTrib)
								
								
								If SB1->(FieldPos("B1_CODSIMP"))>0 .and. !Empty(cCodANP) .and. SB1->B1_CODSIMP <> cCodANP
									
									lMudouSB1 		:= .t.
									SB1->B1_CODSIMP	:= cCodANP
									
								EndIf
								
								
							End If
							
							
							//Atualiza a informa��o de FCI do produto
							If SB1->(FieldPos("B1_YFCI"))>0 .and. !Empty(cFCI)
								
								lMudouSB1 	:= .t.
								SB1->B1_YFCI:= cFCI
								
							EndIf
							
							If !Empty(cSitTrib)
								
								Do Case
									
								Case SubStr(cSitTrib,1,1) == "1"
									
									If SB1->B1_ORIGEM <> "2"
										
										lMudouSB1 		:= .t.
										SB1->B1_ORIGEM	:= "2"
										
									EndIf
									
								Case SubStr(cSitTrib,1,1) == "6"
									
									If SB1->B1_ORIGEM <> "7"
										
										lMudouSB1 		:= .t.
										SB1->B1_ORIGEM	:= "7"
										
									EndIf
									
								OtherWise
									
									SX5->(dbSetOrder(1))
									If SX5->(dbSeek(xFilial("SX5")+"S0"+Padr(SubStr(cSitTrib,1,1),6)))
										
										
										If SB1->B1_ORIGEM <> SubStr(cSitTrib,1,1)
											
											lMudouSB1 		:= .t.
											SB1->B1_ORIGEM	:= SubStr(cSitTrib,1,1)
											
										EndIf
										
									EndIf
									
								EndCase
								
							EndIf
							
							//Ajusta o GRUPO DE TRIBUTA��O DO PRODUTO
							//Posi��o 1 at� 3, tipo do produto
						
							/*
							If Len(AllTrim(SB1->B1_GRTRIB)) >= 3
								cGrTrib := SubStr(SB1->B1_GRTRIB,1,3)
							Else
								cGrTrib := "001"
							EndIf
							
							//Diferencia origem e aliquota de credito de icms
							//Posi��o 4
							If SubStr(cGrTrib,1,3) $ "004/005"
								
								If SDS->DS_EST $ cEstCred12
									cGrTrib += "0"
								Else
									cGrTrib += "1"
								EndIf
								
							Else
								
								If SDS->DS_EST $ cEstCred12
									cGrTrib += "1"
								Else
									cGrTrib += "0"
								EndIf
								
							EndIf
							
							//Verifica se o produto � importado e o classifica
							//Posi��o 5
							If SB1->B1_ORIGEM $ "1/2/3/8"
								cGrTrib += "1"
							Else
								cGrTrib += "0"
							EndIf
							
							//Verifica se o produto dever� compor PIS E COFINS
							//Posi��o 6
							If cTipoNCM == "M"
								cGrTrib += "1"
							Else
								cGrTrib += "2"
							EndIf
							*/
							If SB1->(FieldPos("B1_YPROMOC")) > 0 .and. SB1->B1_YPROMOC <> Iif(cTipoNCM=="M","N","S")
								lMudouSB1 			:= .t.
								SB1->B1_YPROMOC	:= Iif(cTipoNCM=="M","N","S")
							EndIf
							
							
							//Chamado 6009 - Service Desk
							IF cEmpAnt <> "03" 
							
								cGrTrib := U_AjusGTrib(SB1->B1_COD, cNCM, SDS->DS_EST, cTipoNCM, SDS->DS_FORNEC, SB1->B1_ORIGEM)
								
								SX5->(dbSetOrder(1))
								If SX5->(dbSeek(xFilial("SX5")+"21"+cGrTrib)) .and. SB1->B1_GRTRIB <> cGrTrib
									lMudouSB1 			:= .t.
									SB1->B1_GRTRIB	:= cGrTrib
									SB1->B1_PICMRET	:= _oBj:GatAtuPicmRet(.F.)
								EndIf
							
							End If
							
							
							If lMudouSB1
								SB1->B1_UCALSTD	:= dDataBase
							EndIf
							
							SB1->(MSUnLock())
							
							SBZ->(dbSetOrder(1))
							If SBZ->(dbSeek(xFilial("SBZ")+SB1->B1_COD))
								RecLock("SBZ",.F.)
								SBZ->BZ_GRTRIB	:= SB1->B1_GRTRIB
								SBZ->BZ_ORIGEM	:= SB1->B1_ORIGEM
								SBZ->(msUnLock())
							EndIf
							
						EndIf
						
					EndIf
					
					SDT->(dbSkip())
					
				EndDo
				
				//Grava total do desconto
				RecLock("SDS",.f.)
				SDS->DS_DESCONT	:= nDescTot
				SDS->(msUnLock())
				
			EndIf
			
		EndIf
		
	EndIf	

	oXML := NIL
	DelClassIntf()
					
Return()