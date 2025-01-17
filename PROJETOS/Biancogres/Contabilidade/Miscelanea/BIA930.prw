#include "rwmake.ch"

User Function BIA930() 

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 � BIA930	  � Autor � Gustav Koblinger Jr   � Data � 28/06/05 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Contabilizar o ICMS Autonomo                                 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso		 � Faturamento.                                                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Private LCABECALHO,CPADRAO,LPADRAO,NTOTAL,CLOTE,LDIGITA
Private LAGLUT,CARQUIVO,AROTINA,NHDLPRV,ncont:=1,dta_aux,cult := .T.
Private cfiltro
Private lop, dta_ini, dta_fin, inclui := .t.
Private _ddata, _ddata2, dt_contab

If SF2->F2_EMISSAO <= GetMv("MV_ULMES") 
	//Se o Mes ja estiver fechado, contabiliza no primeiro dia posterior ao Fechamento
	dt_contab := GetMv("MV_ULMES")+1 
Else
	dt_contab := SF2->F2_EMISSAO
EndIf

_ddata  := ddatabase
_ddata2 := _ddata  

dta_ini := SF2->F2_EMISSAO
dta_fin := SF2->F2_EMISSAO

Processa( {|| fEntrFut() } , "SF2", "Contabilizando ICMS Frete Autonomo")

RETURN

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
Funcao    := fEntrFut
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
/*/
Static Function fEntrFut()

Private LCABECALHO,CPADRAO,LPADRAO,NTOTAL,CLOTE,LDIGITA
Private LAGLUT,CARQUIVO,AROTINA,NHDLPRV,ncont:=1,dta_aux,cult := .T.

lCabecalho	:= .F.
cPadrao 	:= "P01"
lPadrao 	:= .F.
nTotal  	:= 0
clote   	:= "8820"
lDigita 	:= .T.
lAglut  	:= .F.
carquivo	:= ""
aRotina 	:= {}

cfiltro  := "@F2_EMISSAO >= '"+DTOS(dta_ini)+"' "
cfiltro  += " AND F2_FILIAL = '"+xFilial("SF2")+"' "
cfiltro  += " AND F2_EMISSAO <= '"+DTOS(dta_fin)+"' "
cfiltro  += " AND F2_DOC = '"+SF2->F2_DOC+"' "
cfiltro  += " AND F2_SERIE = '"+SF2->F2_SERIE+"' "
cfiltro  += " AND F2_CLIENTE = '"+SF2->F2_CLIENTE+"' "
cfiltro  += " AND F2_LOJA = '"+SF2->F2_LOJA+"' "
cfiltro  += " AND D_E_L_E_T_ = '' "
DbSelectArea("SF2")
DbSetOrder(1)
Set Filter to &(cfiltro)
DbGotop()

dta_aux := SF2->F2_EMISSAO
While !Eof()
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Alterar o conteudo da database para forcar contabilizacao    �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	ddatabase := dt_contab
	//ddatabase := SF2->F2_EMISSAO
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Verifica o nero do Lote                                    �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	lPadrao := VerPadrao( cPadrao )
	If lPadrao
		If !lCabecalho
			a370Cabecalho()
		Endif
		nTotal  := nTotal + DetProva(nHdlPrv,cPadrao ,"CONTABIL",cLote)
		cult := .F.
/*		dbSelectArea("SF2")
		If Empty(SF2->F2_DTLANC)
			Reclock("SF2",.F.)
			SF2->F2_DTLANC := dDataBase
			MsUnlock()
		End*/
	EndIf
	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSkip()
End

If cult == .F.
	fcont()
EndIf

ddatabase := _ddata2
Set filter to

Return

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北 Funcao := fcont
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
/*/
Static Function fcont()
If lCabecalho
	RodaProva(nHdlPrv,nTotal)
Endif
If lPadrao
	cMesCtbz 	:= Left(DtoS(ddatabase),4) + "S"
	cA100Incl(cArquivo ,nHdlPrv ,3,cLote ,lDigita , lAglut  )
   	//PutSx5(StrZero(Month(ddatabase),2),cMesCtbz)         	
	//FCLOSE(nHdlPrv)
End
Return

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北 Funcao := A370Cab
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
/*/
Static Function a370Cabecalho()
nHdlPrv := HeadProva(cLote,"CONTABIL",Substr(cUserName,1,6),@cArquivo)
lCabecalho := .T.
Return
