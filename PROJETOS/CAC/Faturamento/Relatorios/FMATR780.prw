#INCLUDE "MATR780.CH"
#INCLUDE "PROTHEUS.CH" 
/* facile felipe -  alteracao 2019MAR15 */

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MATR780  � Autor � Marco Bianchi         � Data � 19/07/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Vendas por Cliente, quantidade de cada Produto, ���
���          � Release 4.                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER Function FMATR780()

Local oReport

Private oTmpTab_1 	:= Nil
Private oTmpTab_2 	:= Nil

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	MATR780R3()
EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Marco Bianchi         � Data � 19/07/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport

Local cAliasSD1 := GetNextAlias()
Local cAliasSD2 := GetNextAlias()
Local cAliasSA1 := GetNextAlias()


Local cCodProd	:= ""
Local cDescProd	:= ""
Local cDoc		:= ""
Local cSerie	:= ""
Local dEmissao	:= CTOD("  /  /  ")
Local cUM		:= ""
Local nTotQuant	:= 0
Local nVlrUnit	:= 0
Local nValadi		:= 0
Local nVlrTot	:= 0
Local cVends	:= ""
Local cPedido	:= ""
Local cNomeVend	:= ""
Local cClieAnt	:= ""
Local cLojaAnt	:= ""
Local nTamData  := Len(DTOC(MsDate()))  + 20
Local lValadi		:= cPaisLoc == "MEX" .AND. SD2->(FieldPos("D2_VALADI")) > 0 //  Adiantamentos Mexico
 
Private cSD1, cSD2

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New("FMATR780",STR0018,"MR780A", {|oReport| ReportPrint(oReport,cAliasSD1,cAliasSD2,cAliasSA1)},STR0019 + " " + STR0020)	// "Estatisticas de Vendas (Cliente x Produto)"###"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"###"totalizando por produto e escolhendo a moeda forte para os Valores."

	oReport:oPage:nPaperSize	:= 9  //Papel A4
	oReport:nFontBody			:= 7
	//oReport:cFontBody 			:= "Courier New"
	oReport:SetLandscape() 
	oReport:SetTotalInLine(.F.)
 
Pergunte(oReport:uParam,.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������

//������������������������������������������������������������������������Ŀ
//� Secao 1 - Cliente                                                      �
//��������������������������������������������������������������������������
oCliente := TRSection():New(oReport,STR0027,{"SA1","SD2TRB"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Estatisticas de Vendas (Cliente x Produto)"
oCliente:SetTotalInLine(.F.)

TRCell():New(oCliente,"CCLIEANT"	,/*Tabela*/	,RetTitle("D2_CLIENTE"	),PesqPict("SD2","D2_CLIENTE"	),08							,/*lPixel*/,{|| cClieAnt		})
TRCell():New(oCliente,"CLOJA"		,/*Tabela*/	,RetTitle("D2_LOJA"		),PesqPict("SD2","D2_LOJA"		),TamSx3("D2_LOJA"			)[1],/*lPixel*/,{|| cLojaAnt				})
TRCell():New(oCliente,"A1_NOME"		,/*Tabela*/	,RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),40                            ,.T.       ,{|| (cAliasSA1)->A1_NOME	})
//TRCell():New(oCliente,"A1_OBSERV"	,/*Tabela*/	,RetTitle("A1_OBSERV"	),PesqPict("SA1","A1_OBSERV"	),TamSx3("A1_OBSERV"		)[1],/*lPixel*/,{|| (cAliasSA1)->A1_OBSERV	})

// Imprimie Cabecalho no Topo da Pagina
oReport:Section(1):SetHeaderPage()                       

//������������������������������������������������������������������������Ŀ
//� Sub-Secao do Cliente - Produto                                         �
//��������������������������������������������������������������������������
oProduto := TRSection():New(oCliente,STR0028,{},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Estatisticas de Vendas (Cliente x Produto)"
oProduto:SetTotalInLine(.F.)

TRCell():New(oProduto,"CCODPROD"	,/*Tabela*/,RetTitle("D2_COD"		),PesqPict("SD2","D2_COD"					),TamSx3("D2_COD"		)[1],/*lPixel*/,{|| cCodProd	})
TRCell():New(oProduto,"CDESCPROD"	,/*Tabela*/,RetTitle("B1_DESC"		),PesqPict("SB1","B1_DESC"					),50,.T.,{|| cDescProd	})
TRCell():New(oProduto,"CDOC"		,/*Tabela*/,RetTitle("D2_DOC"		),PesqPict("SD2","D2_DOC"					),TamSx3("D2_DOC"		)[1],/*lPixel*/,{|| cDoc		})
TRCell():New(oProduto,"CSERIE" 		,/*Tabela*/,SerieNfId("SD2",7,"D2_SERIE"),PesqPict("SD2","D2_SERIE"			),SerieNfId("SD2",6,"D2_SERIE"),/*lPixel*/,{|| cSerie		})
TRCell():New(oProduto,"CPEDIDO" 	,/*Tabela*/,RetTitle("D2_PEDIDO"	),PesqPict("SD2","D2_PEDIDO"		   		),TamSx3("D2_PEDIDO")[1],/*lPixel*/,{|| cPedido		})

TRCell():New(oProduto,"DEMISSAO"	,/*Tabela*/,RetTitle("D2_EMISSAO"	),PesqPict("SD2","D2_EMISSAO"				),nTamData					,/*lPixel*/,{|| dEmissao	})
TRCell():New(oProduto,"CUM"			,/*Tabela*/,RetTitle("B1_UM"		),PesqPict("SB1","B1_UM"					),TamSx3("B1_UM"		)[1],/*lPixel*/,{|| cUM			})
TRCell():New(oProduto,"NTOTQUANT"	,/*Tabela*/,RetTitle("D2_QUANT"		),PesqPict("SD2","D2_QUANT"					),TamSx3("D2_QUANT"		)[1],/*lPixel*/,{|| nTotQuant	})
TRCell():New(oProduto,"NVLRUNIT"	,/*Tabela*/,RetTitle("D2_PRCVEN"	),PesqPict("SD2","D2_PRCVEN"				),TamSx3("D2_PRCVEN"	)[1],/*lPixel*/,{|| nVlrUnit	})
If lValadi
	TRCell():New(oProduto,"NVALADI"	,/*Tabela*/,RetTitle("D2_VALADI"	),PesqPict("SD2","D2_VALADI"				),TamSx3("D2_VALADI"	)[1],/*lPixel*/,{|| nValadi	})
EndIf
TRCell():New(oProduto,"NVLRTOT"		,/*Tabela*/,RetTitle("D2_TOTAL"		),PesqPict("SD2","D2_TOTAL"					),TamSx3("D2_TOTAL"		)[1],/*lPixel*/,{|| nVlrTot		})
//TRCell():New(oProduto,"CVENDS"		,/*Tabela*/,STR0024				 ,PesqPict("SF2","F2_VEND1"					),/*TamSx3("F2_VEND1"		)[1]*/0,/*lPixel*/,{|| cVends		})	// "Vendedor"
TRCell():New(oProduto,"CNOMEVEND"		,/*Tabela*/,STR0024				,PesqPict("SA3","A3_NOME"					),TamSx3("A3_NOME"		)[1],/*lPixel*/,{|| cNomeVend		})	// "Vendedor"


// Alinhamento a direita das colunas de valor
oProduto:Cell("NTOTQUANT"):SetHeaderAlign("RIGHT") 
oProduto:Cell("NVLRUNIT"):SetHeaderAlign("RIGHT")
If lValadi
	oProduto:Cell("NVALADI"):SetHeaderAlign("RIGHT")
EndIf 
oProduto:Cell("NVLRTOT"):SetHeaderAlign("RIGHT") 

// Totalizador por Produto
oTotal1 := TRFunction():New(oProduto:Cell("NTOTQUANT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
If lValadi
	TRFunction():New(oProduto:Cell("NVALADI"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
EndIf
oTotal2 := TRFunction():New(oProduto:Cell("NVLRTOT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

// Totalizador por Cliente
oTotal3 := TRFunction():New(oProduto:Cell("NTOTQUANT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/,oCliente)
oTotal4 := TRFunction():New(oProduto:Cell("NVLRTOT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/,oCliente)
If lValadi
	TRFunction():New(oProduto:Cell("NVALADI"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/,oCliente)
EndIf

// Imprimie Cabecalho no Topo da Pagina
oReport:Section(1):Section(1):SetHeaderPage()

//������������������������������������������������������������������������Ŀ
//� Secao 2 - Filtro das nota de devolucao                                 �
//��������������������������������������������������������������������������
oTemp1 := TRSection():New(oReport,STR0029,{"SD1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Estatisticas de Vendas (Cliente x Produto)"
oTemp1:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//� Secao 4 - Filtro das Notas de Saida                                    �
//��������������������������������������������������������������������������
oTemp3 := TRSection():New(oReport,STR0028,{"SD2"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Estatisticas de Vendas (Cliente x Produto)"
oTemp3:SetTotalInLine(.F.) 

oReport:Section(2):SetEditCell(.F.)
oReport:Section(3):SetEditCell(.F.)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Marco Bianchi         � Data � 19/07/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasSD1,cAliasSD2,cAliasSA1)

Local  nV := 0
Local cProdAnt	  := "", cLojaAnt := ""
Local lNewProd	  := .T.
Local nTamRef	  := Val(Substr(GetMv("MV_MASCGRD"),1,2))
Local cProdRef	  := ""
Local cUM		  := ""
Local nTotQuant	  := 0
Local nReg		  := 0
Local cFiltro	  := ""
Local cEstoq	  := If( (mv_par13 == 1),"S",If( (mv_par13 == 2),"N","SN" ))
Local cDupli	  := If( (mv_par14 == 1),"S",If( (mv_par14 == 2),"N","SN" ))
Local cArqTrab1, cArqTrab2, cCondicao1
Local aDevImpr	  := {}
Local cVends	  := ""
Local nVend		  := FA440CntVend()
Local nDevQtd	  := 0
Local nDevVal	  := 0
Local aDev		  := {}
Local nIndD2	  := 0
Local aStru
Local lNfD2Ori	  := .F. 
Local cVendedores := ""
Local lNewCli     := .T.
Local lValadi		:= cPaisLoc == "MEX" .AND. SD2->(FieldPos("D2_VALADI")) > 0 //  Adiantamentos Mexico

Local nj	:= 0
Local cWhere:= ""	


Private nIndD1  :=0
Private nDecs	:=msdecimais(mv_par09)


//��������������������������������������������������������������Ŀ
//� Define o bloco de codigo que retornara o conteudo de impres- �
//� sao da celula.                                               �
//����������������������������������������������������������������
oReport:Section(1):Cell("CCLIEANT" 	):SetBlock({|| cClieAnt		})
oReport:Section(1):Cell("CLOJA" 	):SetBlock({|| cLojaAnt		})
oReport:Section(1):Section(1):Cell("CCODPROD" 	):SetBlock({|| cCodProd		})
oReport:Section(1):Section(1):Cell("CDESCPROD" ):SetBlock({|| cDescProd	})
oReport:Section(1):Section(1):Cell("CDOC"		):SetBlock({|| cDoc			})
oReport:Section(1):Section(1):Cell("CSERIE" 	):SetBlock({|| cSerie 		})
oReport:Section(1):Section(1):Cell("CPEDIDO" 	):SetBlock({|| cPedido 		})
oReport:Section(1):Section(1):Cell("DEMISSAO" 	):SetBlock({|| dEmissao		})
oReport:Section(1):Section(1):Cell("CUM"		):SetBlock({|| cUM			})
oReport:Section(1):Section(1):Cell("NTOTQUANT"	):SetBlock({|| nTotQuant	})
oReport:Section(1):Section(1):Cell("NVLRUNIT" 	):SetBlock({|| nVlrUnit		})
If lValadi
	oReport:Section(1):Section(1):Cell("NVALADI" 	):SetBlock({|| nValadi	})
EndIf
oReport:Section(1):Section(1):Cell("NVLRTOT" 	):SetBlock({|| nVlrTot		})
//oReport:Section(1):Section(1):Cell("CVENDS" 	):SetBlock({|| cVends		}) 
oReport:Section(1):Section(1):Cell("CNOMEVEND" 	):SetBlock({|| cNomeVend	})


//������������������������������������������������������������������������Ŀ
//� Seleciona ordem dos arquivos consultados no processamento    		   �
//��������������������������������������������������������������������������
SF1->(dbsetorder(1))
SF2->(dbsetorder(1))
SB1->(dbSetOrder(1))
SA7->(dbSetOrder(2))

//������������������������������������������������������������������������Ŀ
//� Monta o Cabecalho de acordo com parametros                             �
//��������������������������������������������������������������������������
oReport:SetTitle(oReport:Title() + " " + STR0021 +GetMV("MV_SIMB"+Str(mv_par09,1)))		// "Estatisticas de Vendas (Cliente x Produto)"###"Valores em "

//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//�Filtra nota de devolucao                                                �
//��������������������������������������������������������������������������
dbSelectArea("SD1")


cSD1   := "SD1TMP"
aStru  := dbStruct()
cWhere := "%NOT ("+IsRemito(3,'SD1.D1_TIPODOC')+ ")%"
oReport:Section(2):BeginQuery()
BeginSql Alias cAliasSD1
SELECT *
FROM %Table:SD1% SD1
WHERE SD1.D1_FILIAL = %xFilial:SD1% AND
    SD1.D1_FORNECE >= %Exp:mv_par01% AND SD1.D1_FORNECE <= %Exp:mv_par02% AND
    SD1.D1_DTDIGIT >= %Exp:DtoS(mv_par03)% AND SD1.D1_DTDIGIT <= %Exp:DtoS(mv_par04)% AND
    SD1.D1_COD >= %Exp:mv_par05% AND SD1.D1_COD <= %Exp:mv_par06% AND
    SD1.D1_TIPO = 'D' AND
	%Exp:cWhere% AND		    
    SD1.%NotDel%
ORDER BY SD1.D1_FILIAL,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_COD
EndSql
oReport:Section(2):EndQuery(/*Array com os parametros do tipo Range*/)

A780CriaTmp({"D1_FILIAL","D1_FORNECE","D1_LOJA","D1_COD"}, aStru, cSD1, cALiasSD1 )
    



//��������������������������������������������������������������Ŀ
//� Monta filtro para processar as vendas por cliente            �
//����������������������������������������������������������������
DbSelectArea("SD2")
cFiltro := SD2->(dbFilter())
If Empty(cFiltro)
	bFiltro := { || .T. }
Else
	cFiltro := "{ || " + cFiltro + " }"
	bFiltro := &(cFiltro)
Endif

//��������������������������������������������������������������Ŀ
//� Monta filtro para processar as vendas por cliente            �
//����������������������������������������������������������������
DbSelectArea("SD2")
            

    cSD2   := "SD2TMP"
    aStru  := dbStruct()
    cWhere := "%NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ")%"
    oReport:Section(3):BeginQuery()
    BeginSql Alias cAliasSD2
    SELECT * 
    FROM %Table:SD2% SD2
    WHERE SD2.D2_FILIAL = %xFilial:SD2% AND
    	SD2.D2_CLIENTE BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND
    	SD2.D2_EMISSAO BETWEEN %Exp:DTOS(mv_par03)% AND %Exp:DTOS(mv_par04)% AND
    	SD2.D2_COD     BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% AND
    	SD2.D2_TIPO <> 'B' AND SD2.D2_TIPO <> 'D' AND
    	%Exp:cWhere% AND
    	SD2.%NotDel%
    ORDER BY SD2.D2_FILIAL,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_COD,SD2.D2_ITEM
    EndSql
    oReport:Section(3):EndQuery()
    
    A780CriaTmp({"D2_FILIAL","D2_CLIENTE","D2_LOJA","D2_COD","D2_SERIE","D2_DOC","D2_ITEM"}, aStru, cSD2, cAliasSD2)
  

dbSelectArea("SA1")
dbSetOrder(1)

oReport:Section(1):BeginQuery()  
   
BeginSql Alias cALiasSA1

	SELECT A1_FILIAL,A1_COD,A1_LOJA,A1_NOME,A1_OBSERV
    FROM %Table:SA1% SA1
    WHERE SA1.A1_FILIAL = %xFilial:SA1% AND
    SA1.A1_COD >= %Exp:MV_PAR01% AND
	SA1.A1_COD <= %Exp:MV_PAR02% AND
    SA1.%NotDel%
    ORDER BY A1_FILIAL,A1_COD
    
EndSql
    
oReport:Section(1):EndQuery()


//��������������������������������������������������������������Ŀ
//� Verifica se aglutinara produtos de Grade                     �
//����������������������������������������������������������������
oReport:SetMeter(RecCount())		// Total de Elementos da regua

If ( (cSD2)->D2_GRADE=="S" .And. MV_PAR12 == 1)
	lGrade := .T.
	bGrade := { || Substr((cSD2)->D2_COD, 1, nTamref) }
Else
	lGrade := .F.
	bGrade := { || (cSD2)->D2_COD }
Endif


While !oReport:Cancel() .And. (cAliasSA1)->( ! EOF() .AND. A1_COD <= MV_PAR02 ) .And. (cAliasSA1)->A1_FILIAL == xFilial("SA1")
	
	//����������������������������������������������������������Ŀ
	//� Procura pelas saidas daquele cliente                     �
	//������������������������������������������������������������
	DbSelectArea(cSD2)
	If DbSeek(xFilial("SD2")+(cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA)
		lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
		
		//����������������������������������������������������������Ŀ
		//� Montagem da quebra do relatorio por  Cliente             �
		//������������������������������������������������������������
		cClieAnt := (cAliasSA1)->A1_COD
		cLojaAnt := (cAliasSA1)->A1_LOJA
		lNewProd := .T.
		lNewCli  := .T.
		While !oReport:Cancel() .And.!Eof() .and. ;
			((cSD2)->(D2_FILIAL+D2_CLIENTE+D2_LOJA)) == (xFilial("SD2")+cClieAnt+cLojaAnt)
			
			//����������������������������������������������������������Ŀ
			//� Verifica Se eh uma tipo de nota valida                   �
			//� Verifica intervalo de Codigos de Vendedor                �
			//� Valida o produto conforme a mascara                      �
			//������������������������������������������������������������
			lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
			If	! Eval(bFiltro) .Or. !A780Vend(@cVends,nVend) .Or. !lRet //.or. SD2->D2_TIPO$"BD" ja esta no filtro
				dbSkip()
				Loop
			EndIf
			
			//����������������������������������������������������������Ŀ
			//� Impressao da quebra por produto e NF                     �
			//������������������������������������������������������������
			cProdAnt := Eval(bGrade)
			lNewProd := .T.
			oReport:Section(1):Section(1):Init()
			While !oReport:Cancel() .And. ! Eof() .And. ;
				(cSD2)->(D2_FILIAL + D2_CLIENTE + D2_LOJA  + EVAL(bGrade) ) == ;
				( xFilial("SD2") + cClieAnt   + cLojaAnt + cProdAnt )
				oReport:IncMeter()
				
				//����������������������������������������������������������Ŀ
				//� Avalia TES                                               �
				//������������������������������������������������������������
				lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
				If !AvalTes((cSD2)->D2_TES,cEstoq,cDupli) .Or. !Eval(bFiltro) .Or. !lRet
					dbSkip()
					Loop
				Endif
				
				If !A780Vend(@cVends,nVend)
					dbskip()
					Loop
				Endif
				
				If lNewCli
					oReport:Section(1):Init()
					oReport:Section(1):PrintLine()
					lNewCli := .F.
				EndIf
				//����������������������������������������������������������Ŀ
				//� Se mesmo produto inibe impressao do codigo e descricao   �
				//������������������������������������������������������������
				If lNewProd
					lNewProd := .F.
					oReport:Section(1):Section(1):Cell("CCODPROD"	):Show()
					oReport:Section(1):Section(1):Cell("CDESCPROD"	):Show()
				//Se for tipo planilha e estilo relat�rio em formato de tabela.	
				ElseIf	oReport:nDevice == 4 .AND. oReport:nXlsStyle == 1
					oReport:Section(1):Section(1):Cell("CCODPROD"	):Show()
					oReport:Section(1):Section(1):Cell("CDESCPROD"	):Show()					
				Else
					oReport:Section(1):Section(1):Cell("CCODPROD"	):Hide()
					oReport:Section(1):Section(1):Cell("CDESCPROD"	):Hide()
				EndIf
				
				//����������������������������������������������������������Ŀ
				//� Caso seja grade aglutina todos produtos do mesmo Pedido  �
				//������������������������������������������������������������
				If lGrade  // Aglutina Grade
					cProdRef:= Substr((cSD2)->D2_COD,1,nTamRef)
					cNumPed := (cSD2)->D2_PEDIDO
					nReg    := 0
					nDevQtd := 0
					nDevVal := 0
					
					While !oReport:Cancel() .And. !Eof() .And. cProdRef == Eval(bGrade) .And.;
						(cSD2)->D2_GRADE == "S" .And. cNumPed == (cSD2)->D2_PEDIDO .And.;
						(cSD2)->D2_FILIAL == xFilial("SD2")
						
						nReg := Recno()
						//���������������������������������������������Ŀ
						//� Valida o produto conforme a mascara         �
						//�����������������������������������������������
						lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
						If !lRet .Or. !Eval(bFiltro)
							dbSkip()
							Loop
						EndIf
						
						//�����������������������������Ŀ
						//� Tratamento das Devolu�oes   �
						//�������������������������������
						If mv_par10 == 1 //inclui Devolucoes
							SomaDev(@nDevQtd, @nDevVal , @aDev, cEstoq, cDupli)
						EndIf
						
						nTotQuant += (cSD2)->D2_QUANT
						dbSkip()
						
					EndDo
					
					//���������������������������������������������Ŀ
					//� Verifica se processou algum registro        �
					//�����������������������������������������������
					If nReg > 0
						dbGoto(nReg)
						nReg:=0
					EndIf
					
				Else
					//�����������������������������Ŀ
					//� Tratamento das devolucoes   �
					//�������������������������������
					nDevQtd :=0
					nDevVal :=0
					
					If mv_par10 == 1 //inclui Devolucoes
						SomaDev(@nDevQtd, @nDevVal , @aDev, cEstoq, cDupli)
					EndIf
					
					nTotQuant := (cSD2)->D2_QUANT
					
				EndIf
				
				//����������������������������������������������������������Ŀ
				//� Imprime os dados da NF                                   �
				//������������������������������������������������������������
				SB1->(dbSeek(xFilial("SB1")+(cSD2)->D2_COD))
				If mv_par16 = 1
					cDescProd := SB1->B1_DESC
				Else
					If SA7->(dbSeek(xFilial("SA7")+(cSD2)->(D2_COD+D2_CLIENTE+D2_LOJA)))
						cDescProd := SA7->A7_DESCCLI
					Else
						cDescProd := SB1->B1_DESC
					Endif
				EndIf
				
				SF2->(dbSeek(xFilial("SF2")+(cSD2)->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)))
				cUM      := (cSD2)->D2_UM
				cDoc     := (cSD2)->D2_DOC
				cSerie   := (cSD2)->&(SerieNfId("SD2",3,"D2_SERIE"))
				dEmissao := (cSD2)->D2_EMISSAO
				cPedido	 := (cSD2)->D2_PEDIDO
				
				//����������������������������������������������������������Ŀ
				//� Faz Verificacao da Moeda Escolhida e Imprime os Valores  �
				//������������������������������������������������������������
				nVlrUnit := xMoeda((cSD2)->D2_PRCVEN,SF2->F2_MOEDA,MV_PAR09,(cSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
				If lValadi
					nValadi := xMoeda((cSD2)->D2_VALADI,SF2->F2_MOEDA,MV_PAR09,(cSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
				EndIf
				If (cSD2)->D2_TIPO $ "CIP" 
					If cPaisLoc == "BRA"
						nVlrTot:= nVlrUnit
					ElseIf (cSD2)->D2_TIPO $ "C" 
						nVlrTot:= nTotQuant * nVlrUnit
					EndIf	
				Else	
					If (cSD2)->D2_GRADE == "S" .And. MV_PAR12 == 1 // Aglutina Grade
						nVlrTot:= nVlrUnit * nTotQuant
					Else
						nVlrTot:=xmoeda((cSD2)->D2_TOTAL,SF2->F2_MOEDA,mv_par09,(cSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
					EndIf
				EndIf
				
				cCodProd 	:= Eval(bGrade)
				A780Vend(@cVends,nVend)  
				cVendedores := cVends   
				
				//GETAREA()
				cNomeVend := Posicione("SA3", 1, FWxFilial("SA3")+Subs(cVendedores,1,7), "A3_NOME")
				//RESTAREA() 
				                  
				//oReport:section(1):section(1):Cell("CVENDS"	):Hide() 
				
			   	cVends 		:= Subs(cVendedores,1,7)
				oReport:Section(1):Section(1):PrintLine()
				
				//����������������������������������������������������������Ŀ
				//� Impressao dos Vendedores                                 �
				//������������������������������������������������������������
				oReport:section(1):section(1):Cell("CCODPROD"	):Hide()
				oReport:section(1):section(1):Cell("CDESCPROD"	):Hide()
				oReport:section(1):section(1):Cell("CDOC"		):Hide()
				oReport:section(1):section(1):Cell("CSERIE"	):Hide()
				oReport:section(1):section(1):Cell("CPEDIDO"	):Hide()
				oReport:section(1):section(1):Cell("DEMISSAO"	):Hide()
				oReport:section(1):section(1):Cell("CUM"		):Hide()
				oReport:section(1):section(1):Cell("NTOTQUANT"	):Hide()
				oReport:section(1):section(1):Cell("NVLRUNIT"	):Hide()  
				//oReport:section(1):section(1):Cell("CVENDS"	):Hide() 
				
				//oReport:Section(1):Section(1):Cell("CNOMEVEND" 	):Hide()
				  
				If lValadi
					oReport:section(1):section(1):Cell("NVALADI"	):Hide()
				EndIf
				oReport:section(1):section(1):Cell("NVLRTOT"	):Hide()
				
				nTotQuant := 0		// Zera variaveis para que nao sejam somadas novamente nos totalizadores
				nVlrTot   := 0		// na impressao dos outros vendedores
				For nV := 8 to Len(cVendedores)
					cVends := Space(20)+Subs(cVendedores,nV,7)
				   	oReport:Section(1):Section(1):PrintLine()
					nV += 6
				Next
				
				oReport:section(1):section(1):Cell("CCODPROD"	):Show()
				oReport:section(1):section(1):Cell("CDESCPROD"	):Show()
				oReport:section(1):section(1):Cell("CDOC"		):Show()
				oReport:section(1):section(1):Cell("CSERIE"	):Show()
				oReport:section(1):section(1):Cell("CPEDIDO"	):Show()
				oReport:section(1):section(1):Cell("DEMISSAO"	):Show()
				oReport:section(1):section(1):Cell("CUM"		):Show()
				oReport:section(1):section(1):Cell("NTOTQUANT"	):Show()
				oReport:section(1):section(1):Cell("NVLRUNIT"	):Show()   
				oReport:Section(1):Section(1):Cell("CNOMEVEND" 	):Show() 
				
				If lValadi
					oReport:section(1):section(1):Cell("NVALADI"	):Show()
				EndIf
				oReport:section(1):section(1):Cell("NVLRTOT"	):Show()
				

				//����������������������������������������������������������Ŀ
				//� Imprime as devolucoes do produto selecionado             �
				//������������������������������������������������������������
				If nDevQtd!=0
					cSerie 	:= STR0025	// "DEV"
					nVlrTot   := nDevVal
					nTotQuant := nDevQtd   

					oReport:Section(1):Section(1):Cell("CDOC"		):Hide()
					oReport:Section(1):Section(1):Cell("DEMISSAO"	):Hide()
					oReport:Section(1):Section(1):Cell("NVLRUNIT"	):Hide()
					If lValadi
						oReport:section(1):section(1):Cell("NVALADI"	):Hide()
					EndIf
					
					//oReport:Section(1):Section(1):Cell("CVENDS"	):Hide()  
						oReport:Section(1):Section(1):Cell("CNOMEVEND" 	):Hide() 
					
					oReport:Section(1):Section(1):PrintLine()
					
					oReport:Section(1):Section(1):Cell("CDOC"		):Show()
					oReport:Section(1):Section(1):Cell("DEMISSAO"	):Show()
					oReport:Section(1):Section(1):Cell("NVLRUNIT"	):Show()
					If lValadi
						oReport:section(1):section(1):Cell("NVALADI"	):Show()
					EndIf
				   //	oReport:Section(1):Section(1):Cell("CVENDS"	):Show()
				   	oReport:Section(1):Section(1):Cell("CNOMEVEND" 	):Show() 
					
				EndIf
				nTotQuant := 0
				dbSkip()
				
			EndDo
			
			//����������������������������������������������������������Ŀ
			//� Imprime o total do produto selecionado                   �
			//������������������������������������������������������������
			oReport:Section(1):Section(1):SetTotalText(STR0022 + cProdAnt)	// "TOTAL DO PRODUTO - "
			oReport:Section(1):Section(1):Finish()
			
		EndDo
		oReport:Section(1):SetTotalText(STR0023 + cClieAnt)	// "TOTAL DO CLIENTE - "
		If !lNewCli
			oReport:section(1):Finish()
		EndIf	
		cClieAnt := ""
		cLojaAnt := ""
		
	EndIf
	//�������������������������������������������������������������Ŀ
	//� Procura pelas devolucoes dos clientes que nao tem NF SAIDA  �
	//���������������������������������������������������������������
	DbSelectArea(cSD1)
	If DbSeek(xFilial("SD1")+(cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA)
		lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)
		//����������������������������������������������������������Ŀ
		//� Procura as devolucoes do periodo, mas que nao pertencem  �
		//� as NFS ja impressas do cliente selecionado               �
		//������������������������������������������������������������
		If mv_par10 == 1  // Inclui Devolucao
			
			//��������������������������Ŀ
			//� Soma Devolucoes          �
			//����������������������������
			oReport:Section(1):Init()
			While !oReport:Cancel() .And. (cSD1)->(D1_FILIAL + D1_FORNECE + D1_LOJA) == ;
				( xFilial("SD1") + (cAliasSA1)->A1_COD+ (cAliasSA1)->A1_LOJA)  .AND. ! Eof()
				lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)
				
				//�������������������������������������Ŀ
				//� Verifica Vendedores da N.F.Original �
				//���������������������������������������
				
				CtrlVndDev := .F.
				lNfD2Ori   := .F.
				If AvalTes((cSD1)->D1_TES,cEstoq,cDupli)
					dbSelectArea("SD2")
					nSavOrd := IndexOrd()
					dbSetOrder(3)

					dbSeek(xFilial("SD2")+(cSD1)->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD))
					While !oReport:Cancel() .And. !Eof() .And. (xFilial("SD2")+(cSD1)->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD)) == ;
						D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD
					
						lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)
					
						If !Empty((cSD1)->D1_ITEMORI) .AND. AllTrim((cSD1)->D1_ITEMORI) != D2_ITEM .Or. !lRet .Or. !Eval(bFiltro)
							dbSkip()
							Loop
						Else
							CtrlVndDev := A780Vend(@cVends,nVend)
							If Ascan(aDev,D2_CLIENTE + D2_LOJA + D2_COD + D2_DOC + D2_SERIE + D2_ITEM) > 0
								lNfD2Ori := .T.
							EndIf
						Endif
						dbSkip()
					End
				
					dbSelectArea("SD2")
					dbSetOrder(nSavOrd)
					dbSelectArea(cSD1)
				
					If !(CtrlVndDev) .Or. lNfD2Ori
						dbSkip()
						Loop
					EndIf
				
					SF1->(dbSeek(xFilial("SF1")+(cSD1)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))
					cUM := (cSD1)->D1_UM
					cDoc := (cSD1)->D1_DOC
					cSerie := (cSD1)->&(SerieNfId("SD1",3,"D1_SERIE"))
					dEmissao := (cSD1)->D1_EMISSAO
					//dPedido := (cSD1)->D1_PEDIDO
					nVlrTot:=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,(cSD1)->D1_DTDIGIT,nDecs,SF1->F1_TXMOEDA)
					If (SD2TMP->(EOF()) .And. SD1TMP->(!EOF())) .Or. (SD2TMP->(!EOF()) .And. SD1TMP->(!EOF()))
						cClieAnt := (cAliasSA1)->A1_COD
						cLojaAnt := (cAliasSA1)->A1_LOJA
						cCodProd := D1_COD
						cDescProd := Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC")
						cDoc := D1_DOC
						cSerie := SerieNfId("SD1",2,"D1_SERIE")
						dEmissao := D1_EMISSAO
						cUM := D1_UM
						nTotQuant := D1_QUANT * -1
						nVlrUnit := D1_VUNIT * -1
						nVlrTot := D1_TOTAL * -1
						cVends := cVends  
						oReport:Section(1):PrintLine()
						oReport:Section(1):Section(1):Init()
					EndIf
					oReport:Section(1):Section(1):PrintLine()
				Endif
				dbSkip()
			EndDo
		EndIf
		
	Endif
	
	DbSelectArea(cAliasSA1)
	DbSkip()
EndDo

If( valtype(oTmpTab_1) == "O")
	oTmpTab_1:Delete()
	freeObj(oTmpTab_1)
	oTmpTab_1 := nil
EndIf

If( valtype(oTmpTab_2) == "O")
	oTmpTab_2:Delete()
	freeObj(oTmpTab_2)
	oTmpTab_2 := nil
EndIf



Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR780R3� Autor � Gilson do Nascimento  � Data � 01.09.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Vendas por Cliente, quantidade de cada Produto  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR780(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Bruno        �05.04.00�Melhor�Acertar as colunas para 12 posicoes.    ���
��� Marcello     �29/08/00�oooooo�Impressao de casas decimais de acordo   ���
���              �        �      �com a moeda selecionada e conversao     ���
���              �        �      �(xmoeda)baseada na moeda gravada na nota���
��� Rubens Pante �04/07/01�Melhor�Utilizacao de SELECT nas versoes TOP    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MATR780R3()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL wnrel
LOCAL tamanho:=IIF(cPaisLoc=="MEX","G","M")
LOCAL titulo := OemToAnsi(STR0001)	//"Estatisticas de Vendas (Cliente x Produto)"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"totalizando por produto e escolhendo a moeda forte para os Valores."
LOCAL cDesc3 := ""
LOCAL cString:= "SD2"

PRIVATE aReturn := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR780"
PRIVATE nLastKey := 0
PRIVATE cPerg   :="MR780A"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("MR780A",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // De Cliente                           �
//� mv_par02             // Ate Cliente                          �
//� mv_par03             // De Data                              �
//� mv_par04             // Ate a Data                           �
//� mv_par05             // De Produto                           �
//� mv_par06             // Ate o Produto                        �
//� mv_par07             // Do Vendedor                          �
//� mv_par08             // Ate Vendedor                         �
//� mv_par09             // Moeda                                �
//� mv_par10             // Inclui Devolu��o                     �
//� mv_par11             // Mascara do Produto                   �
//� mv_par12             // Aglutina Grade                       �
//� mv_par13	// Quanto a Estoque Movimenta/Nao Movta/Ambos    �
//� mv_par14	// Quanto a Duplicata Gera/Nao Gera/Ambos        �
//� mv_par15   // Quanto a Devolucao NF Original/NF Devolucao    �
//� mv_par16   // Quanto a Descricao  Produto  Prod x Cli.       �
//� mv_par17   // converte moeda da devolucao                    �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Monta o Cabecalho de acordo com o tipo de emissao            �
//����������������������������������������������������������������
titulo := STR0006	//"ESTATISTICAS DE VENDAS (Cliente X Produto)"
Cabec1 := STR0007	//"CLIENTE   RAZAO SOCIAL"
Cabec2 := STR0008   //"PRODUTO         DESCRICAO                  NOTA FISCAL        EMISSAO   UN   QUANTIDADE    PRECO UNITARIO            TOTAL  VENDEDOR"
// 123456789012345 123456789012345678901234567890 123456/123 12/12/1234 123456789012 1234567890123456 1234567890123456 123456/123456/123456/123456/123456

wnrel:="MATR780"

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,,.T.)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C780Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C780IMP  � Autor � Rosane Luciane Chene  � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR780                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C780Imp(lEnd,WnRel,cString)

LOCAL CbTxt
LOCAL CbCont,cabec1,cabec2,cabec3
LOCAL nTotCli1:= 0,nTotCli2:=0,nTotGer1 := 0,nTotGer2 := 0
LOCAL nOrdem
LOCAL tamanho:= "M"
LOCAL limite := IIF(cPaisLoc=="MEX",144,132)
LOCAL titulo := OemToAnsi(STR0006)	//"ESTATISTICAS DE VENDAS (Cliente X Produto)"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"totalizando por produto e escolhendo a moeda forte para os Valores."
LOCAL cDesc3 := ""
LOCAL cMoeda
LOCAL nAcN1  := 0, nAcN2 := 0, nV := 0
LOCAL cClieAnt := "", cProdAnt := "", cLojaAnt := ""
LOCAL lContinua := .T. , lProcessou := .F. , lNewProd := .T.
LOCAL cMascara :=GetMv("MV_MASCGRD")
LOCAL nTamRef  :=Val(Substr(cMascara,1,2))
LOCAL nTamLin  :=Val(Substr(cMascara,4,2))
LOCAL nTamCol  :=Val(Substr(cMascara,7,2))
LOCAL cProdRef :=""
Local cUM      :=""
LOCAL nTotQuant:=0
LOCAL nReg     :=0
LOCAL cFiltro  := ""
Local cEstoq := If( (mv_par13 == 1),"S",If( (mv_par13 == 2),"N","SN" ))
Local cDupli := If( (mv_par14 == 1),"S",If( (mv_par14 == 2),"N","SN" ))
Local cArqTrab1, cArqTrab2, cCondicao1
Local aDevImpr := {}
Local cVends   := ""
Local nVend    := FA440CntVend()
Local nDevQtd 	:=0
Local nDevVal 	:=0
Local aDev		:={}
Local nIndD2    :=0
Local cQuery, aStru
Local lNfD2Ori   := .F. 
// variaveis criadas para realinhamento das colunas para o Mexico (factura com 20 digitos)
Local aColuna   := IIf(cPaisLoc=="MEX",{46,71,82,86,99,116,135},{46,61,72,76,89,106,125})
Local nj := 0
Local cAliasSA1 := "SA1"


Private cSD1, cSD2
Private nIndD1  :=0
Private nDecs:=msdecimais(mv_par09)

//��������������������������������������������������������������Ŀ
//� Seleciona ordem dos arquivos consultados no processamento    �
//����������������������������������������������������������������
SF1->(dbsetorder(1))
SF2->(dbsetorder(1))
SB1->(dbSetOrder(1))
SA7->(dbSetOrder(2))

//��������������������������������������������������������������Ŀ
//� Monta o Cabecalho de acordo com o tipo de emissao            �
//����������������������������������������������������������������
titulo := STR0006	//"ESTATISTICAS DE VENDAS (Cliente X Produto)"
Cabec1 := STR0009	//"CLIENTE  RAZAO SOCIAL"

Cabec2 := STR0008   //"PRODUTO         DESCRICAO                  NOTA FISCAL        EMISSAO   UN   QUANTIDADE   PRECO UNITARIO             TOTAL  VENDEDOR"
If cPaisLoc=="MEX"
   Cabec2 := Substr(Cabec2,1,54)+space(10)+Substr(Cabec2,55)
EndIf

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

cMoeda := STR0010+GetMV("MV_SIMB"+Str(mv_par09,1))		//"Valores em "
titulo := titulo+" "+cMoeda

//��������������������������������������������������������������Ŀ
//� Cria filtro para impressao das devolucoes                    �
//� *** este filtro possui 208 posicoes  ***                     �
//����������������������������������������������������������������
dbSelectArea("SD1")


//��������������������������������Ŀ
//� Query para SQL                 �
//����������������������������������
cSD1   := "SD1TMP"
aStru  := dbStruct()
cQuery := "SELECT * FROM " + RetSqlName("SD1") + " SD1 "
cQuery += "WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
cQuery += "SD1.D1_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery += "SD1.D1_DTDIGIT BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+ "' AND "
cQuery += "SD1.D1_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
cQuery += "SD1.D1_TIPO = 'D' AND "
 cQuery += " NOT ("+IsRemito(3,'SD1.D1_TIPODOC')+ ") AND "
cQuery += "SD1.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY SD1.D1_FILIAL,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_COD"
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD1TRB', .F., .T.)},OemToAnsi(STR0011)) //"Seleccionado registros"
For nj := 1 to Len(aStru)
    If aStru[nj,2] != 'C'
	   TCSetField('SD1TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
    EndIf	
Next nj
A780CriaTmp({"D1_FILIAL","D1_FORNECE","D1_LOJA","D1_COD"}, aStru, cSD1, "SD1TRB")
    


dbSeek(xFilial("SD1"))

//��������������������������������������������������������������Ŀ
//� Monta filtro para processar as vendas por cliente            �
//����������������������������������������������������������������
DbSelectArea("SD2")
cFiltro := SD2->(dbFilter())
If Empty(cFiltro)
	bFiltro := { || .T. }
Else
	cFiltro := "{ || " + cFiltro + " }"
	bFiltro := &(cFiltro)
Endif
//��������������������������������������������������������������Ŀ
//� Monta filtro para processar as vendas por cliente            �
//����������������������������������������������������������������
          

//��������������������������������Ŀ
//� Query para SQL                 �
//����������������������������������
cSD2   := "SD2TMP"
aStru  := dbStruct()
cQuery := "SELECT * FROM " + RetSqlName("SD2") + " SD2 "
cQuery += "WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND "
cQuery += "SD2.D2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery += "SD2.D2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
cQuery += "SD2.D2_COD     BETWEEN '"+ mv_par05+"' AND '"+mv_par06+"' AND "
cQuery += "SD2.D2_TIPO <> 'B' AND SD2.D2_TIPO <> 'D' AND "
 cQuery += " NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ") AND "
cQuery += "SD2.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY SD2.D2_FILIAL,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_COD,SD2.D2_ITEM"
cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD2TRB', .F., .T.)},OemToAnsi(STR0011)) //"Seleccionado registros"
For nj := 1 to Len(aStru)
    If aStru[nj,2] != 'C'
	    TCSetField('SD2TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
    EndIf	
Next nj

A780CriaTmp({"D2_FILIAL","D2_CLIENTE","D2_LOJA","D2_COD","D2_SERIE","D2_DOC","D2_ITEM"}, aStru, cSD2, "SD2TRB")
   



dbSelectArea("SA1")
dbSetOrder(1)

cAliasSA1 := GetNextAlias()
aStru  := dbStruct()
cQuery := "SELECT A1_FILIAL,A1_COD,A1_LOJA,A1_NOME,A1_OBSERV "    
cQuery += "FROM " + RetSqlName("SA1") + " SA1 "
cQuery += "WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += "SA1.A1_COD >= '"        +MV_PAR01+"' AND "
cQuery += "SA1.A1_COD <= '"        +MV_PAR02+"' AND "
cQuery += "SA1.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY "+SqlOrder(SA1->(IndexKey()))
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAliasSA1, .F., .T.)


//��������������������������������������������������������������Ŀ
//� Verifica se aglutinara produtos de Grade                     �
//����������������������������������������������������������������
SetRegua(RecCount())		// Total de Elementos da regua

If ( (cSD2)->D2_GRADE=="S" .And. MV_PAR12 == 1)
	lGrade := .T.
	bGrade := { || Substr((cSD2)->D2_COD, 1, nTamref) }
Else
	lGrade := .F.
	bGrade := { || (cSD2)->D2_COD }
Endif


While (cAliasSA1)->( ! EOF() .AND. A1_COD <= MV_PAR02 ) .And. lContinua .And. (cAliasSA1)->A1_FILIAL == xFilial("SA1")
	
	If lEnd
		@Prow()+1,001 Psay STR0012	//"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIf
	
	lNewCli := .T.
	
	//����������������������������������������������������������Ŀ
	//� Procura pelas saidas daquele cliente                     �
	//������������������������������������������������������������
	DbSelectArea(cSD2)
	If DbSeek(xFilial("SD2")+(cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA)
		lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
		
		//����������������������������������������������������������Ŀ
		//� Montagem da quebra do relatorio por  Cliente             �
		//������������������������������������������������������������
		cClieAnt := (cAliasSA1)->A1_COD
		cLojaAnt := (cAliasSA1)->A1_LOJA
		lNewProd := .T.
		lNewCli  := .T.
		nTotCli1 := 0
		nTotCli2 := 0
		While !Eof() .and. ;
			((cSD2)->(D2_FILIAL+D2_CLIENTE+D2_LOJA)) == (xFilial("SD2")+cClieAnt+cLojaAnt)
			
			//����������������������������������������������������������Ŀ
			//� Verifica Se eh uma tipo de nota valida                   �
			//� Verifica intervalo de Codigos de Vendedor                �
			//� Valida o produto conforme a mascara                      �
			//������������������������������������������������������������
			lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
			If	! Eval(bFiltro) .Or. !A780Vend(@cVends,nVend) .Or. !lRet //.or. SD2->D2_TIPO$"BD" ja esta no filtro
				dbSkip()
				Loop
			EndIf
			
			//����������������������������������������������������������Ŀ
			//� Impressao do Cabecalho.                                  �
			//������������������������������������������������������������
			If Li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				lProcessou := .T.
			EndIf
			
			
			//����������������������������������������������������������Ŀ
			//� Impressao da quebra por produto e NF                     �
			//������������������������������������������������������������
			cProdAnt := Eval(bGrade)
			lNewProd := .T.
			
			While ! Eof() .And. ;
				(cSD2)->(D2_FILIAL + D2_CLIENTE + D2_LOJA  + EVAL(bGrade) ) == ;
				( xFilial("SD2") + cClieAnt   + cLojaAnt + cProdAnt )
				IncRegua()
				
				//����������������������������������������������������������Ŀ
				//� Avalia TES                                               �
				//������������������������������������������������������������
				lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
				If !AvalTes((cSD2)->D2_TES,cEstoq,cDupli) .Or. !Eval(bFiltro) .Or. !lRet
					dbSkip()
					Loop
				Endif
				
				If !A780Vend(@cVends,nVend)
					dbskip()
					Loop
				Endif
				
				//����������������������������������������������������������Ŀ
				//� Impressao  dos dados do Cliente                          �
				//������������������������������������������������������������
				If lNewCli
					
					If Li > 51
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
						lProcessou := .T.
					EndIf
					
					@ Li,000 Psay Repli('-',limite)
					Li++
					@ Li,000 Psay (cSD2)->D2_CLIENTE+"   "+(cAliasSA1)->A1_NOME
					/*If !Empty((cAliasSA1)->A1_OBSERV)
						Li++
						@ Li,000 Psay STR0013+(cAliasSA1)->A1_OBSERV		//"Obs.: "
					EndIf*/
					Li++
					lNewCli := .F.
				Endif
				
				//����������������������������������������������������������Ŀ
				//� Impressao do Cabecalho.                                  �
				//������������������������������������������������������������
				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					@ Li,000 Psay Repli('-',limite)
					Li++
					@ Li,000 Psay (cSD2)->D2_CLIENTE+"   "+(cAliasSA1)->A1_NOME
					/*If !Empty((cAliasSA1)->A1_OBSERV)
						Li++
						@ Li,000 Psay STR0013+(cAliasSA1)->A1_OBSERV		//"Obs.: "
					EndIf*/
					Li+=2
				EndIf
				
				//����������������������������������������������������������Ŀ
				//� Faz Impressao de Codigo e Descricao Do Produto.          �
				//������������������������������������������������������������
				If lNewProd
					lNewProd := .F.
					Li+=2
					@Li ,  0 Psay Eval(bGrade)
					SB1->(dbSeek(xFilial("SB1")+(cSD2)->D2_COD))
					If mv_par16 = 1
						@li , 16 Psay Substr(SB1->B1_DESC,1,28)
					Else
						If SA7->(dbSeek(xFilial("SA7")+(cSD2)->(D2_COD+D2_CLIENTE+D2_LOJA)))
							@li , 16 Psay Substr(SA7->A7_DESCCLI,1,30)
						Else
							@li , 16 Psay Substr(SB1->B1_DESC,1,28)
						Endif
					EndIf
				EndIf
				
				//����������������������������������������������������������Ŀ
				//� Caso seja grade aglutina todos produtos do mesmo Pedido  �
				//������������������������������������������������������������
				If lGrade  // Aglutina Grade
					cProdRef:= Substr((cSD2)->D2_COD,1,nTamRef)
					cNumPed := (cSD2)->D2_PEDIDO
					nReg    := 0
					nDevQtd :=0
					nDevVal :=0
					
					While !Eof() .And. cProdRef == Eval(bGrade) .And.;
						(cSD2)->D2_GRADE == "S" .And. cNumPed == (cSD2)->D2_PEDIDO .And.;
						(cSD2)->D2_FILIAL == xFilial("SD2")
						
						nReg := Recno()
						//���������������������������������������������Ŀ
						//� Valida o produto conforme a mascara         �
						//�����������������������������������������������
						lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
						If !lRet .Or. !Eval(bFiltro)
							dbSkip()
							Loop
						EndIf
						
						//�����������������������������Ŀ
						//� Tratamento das Devolu�oes   �
						//�������������������������������
						If mv_par10 == 1 //inclui Devolucoes
							SomaDev(@nDevQtd, @nDevVal , @aDev, cEstoq, cDupli)
						EndIf
						
						nTotQuant += (cSD2)->D2_QUANT
						dbSkip()
						
					EndDo
					
					//���������������������������������������������Ŀ
					//� Verifica se processou algum registro        �
					//�����������������������������������������������
					If nReg > 0
						dbGoto(nReg)
						nReg:=0
					EndIf
					
				Else
					//�����������������������������Ŀ
					//� Tratamento das devolucoes   �
					//�������������������������������
					nDevQtd :=0
					nDevVal :=0
					
					If mv_par10 == 1 //inclui Devolucoes
						SomaDev(@nDevQtd, @nDevVal , @aDev, cEstoq, cDupli)
					EndIf
					
					nTotQuant := (cSD2)->D2_QUANT
					
				EndIf
				
				//����������������������������������������������������������Ŀ
				//� Imprime os dados da NF                                   �
				//������������������������������������������������������������
				
				SF2->(dbSeek(xFilial("SF2")+(cSD2)->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)))
				cUM := (cSD2)->D2_UM
				
				@Li , aColuna[1] Psay (cSD2)->(D2_DOC+'/'+&(SerieNfId("SD2",3,"D2_SERIE")))
				@Li , aColuna[2] Psay (cSD2)->D2_EMISSAO
				@Li , aColuna[3] Psay cUM
				@Li , aColuna[4] Psay nTotQuant          PICTURE PesqPictqt("D2_QUANT",14)
				
				nAcN1 += nTotQuant
				
				//����������������������������������������������������������Ŀ
				//� Faz Verificacao da Moeda Escolhida e Imprime os Valores  �
				//������������������������������������������������������������
				nVlrUnit := xMoeda((cSD2)->D2_PRCVEN,SF2->F2_MOEDA,MV_PAR09,(cSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
				@Li , aColuna[5] Psay nVlrUnit           PICTURE PesqPict("SD2","D2_PRCVEN",14,mv_par09)
				
				If (cSD2)->D2_TIPO $ "CIP"
					@Li ,aColuna[6] Psay nVlrUnit        PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
					nAcN2 += nVlrUnit
				Else
					If (cSD2)->D2_GRADE == "S" .And. MV_PAR12 == 1 // Aglutina Grade
						nVlrTot:= nVlrUnit * nTotQuant
						@Li ,aColuna[6] Psay nVlrTot         PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
					Else
						nVlrTot:=xmoeda((cSD2)->D2_TOTAL,SF2->F2_MOEDA,mv_par09,(cSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
						@Li ,aColuna[6] Psay nVlrTot         PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
					EndIf
					nAcN2 += nVlrTot
				EndIf

				A780Vend(@cVends,nVend)
				@Li, aColuna[7] Psay Subs(cVends,1,7)
				For nV := 8 to Len(cVends)
					li ++
					@Li, aColuna[7] Psay Subs(cVends,nV,7)
					nV += 6
				Next

				//����������������������������������������������������������Ŀ
				//� Imprime as devolucoes do produto selecionado             �
				//������������������������������������������������������������
				If nDevQtd!=0
					Li++
					@Li,053 Psay STR0017 // "DEV"
					nVlrTot:= nDevVal
					@Li,aColuna[3] Psay cUM
					@Li,aColuna[4] Psay nDevQtd          PICTURE "@)"+PesqPictqt("D2_QUANT",14)
					@Li,aColuna[6] Psay nVlrTot          PICTURE "@)"+PesqPict("SD2","D2_TOTAL",16,mv_par09)
					nAcN1+= nDevQtd
					nAcN2+= nVlrTot
				EndIf
				Li++
				nTotQuant := 0
				dbSkip()
				
			EndDo
			
			//����������������������������������������������������������Ŀ
			//� Acumula o total geral do relatorio                       �
			//������������������������������������������������������������
			nTotGer1 += nAcN1
			nTotGer2 += nAcN2
			
			//����������������������������������������������������������Ŀ
			//� Acumula o total por cliente                              �
			//������������������������������������������������������������
			nTotCli1 += nAcN1
			nTotCli2 += nAcN2
			
			//����������������������������������������������������������Ŀ
			//� Imprime o total do produto selecionado                   �
			//������������������������������������������������������������
			If nAcN1#0 .Or. nAcN2#0	.Or. nDevQtd#0
				Li++
				@Li ,  07 Psay STR0014+cProdAnt	//"TOTAL DO PRODUTO - "
				@Li ,  52 Psay "---->"
				@Li , aColuna[3] Psay cUM
				@Li , aColuna[4] Psay nAcN1 PICTURE PesqPictqt("D2_QUANT",14)
				@Li , aColuna[6] Psay nAcN2 PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
				nAcN1 := 0
				nAcN2 := 0
				cProdAnt := (cSD2)->D2_COD
			EndIf
			
		EndDo
		//����������������������������������������������������������Ŀ
		//� Ocorreu quebra por cliente                               �
		//������������������������������������������������������������
		If !(lNewCli)
			LI+=2
			@Li , 07 Psay STR0015+cClieAnt+'/'+cLojaAnt	//"TOTAL DO CLIENTE - "
			@Li , 52 Psay "---->"
			@Li ,aColuna[4] Psay nTotCli1 PICTURE PesqPictqt("D2_QUANT",16)
			@Li ,aColuna[6] Psay nTotCli2 PICTURE PesqPict("SD2","D2_TOTAL",18,mv_par09)
			LI++
		EndIf
		cClieAnt := ""
		cLojaAnt := ""
		nTotCli1 := 0
		nTotCli2 := 0
		
	EndIf
	//�������������������������������������������������������������Ŀ
	//� Procura pelas devolucoes dos clientes que nao tem NF SAIDA  �
	//���������������������������������������������������������������
	nTotCli1 := 0
	nTotCli2 := 0
	DbSelectArea(cSD1)
	If DbSeek(xFilial("SD1")+(cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA)
		lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)
		//����������������������������������������������������������Ŀ
		//� Procura as devolucoes do periodo, mas que nao pertencem  �
		//� as NFS ja impressas do cliente selecionado               �
		//������������������������������������������������������������
		If mv_par10 == 1  // Inclui Devolucao
			
			//��������������������������Ŀ
			//� Soma Devolucoes          �
			//����������������������������
			While (cSD1)->(D1_FILIAL + D1_FORNECE + D1_LOJA) == ;
				( xFilial("SD1") + (cAliasSA1)->A1_COD+ (cAliasSA1)->A1_LOJA)  .AND. ! Eof()
				lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)
				
				//�������������������������������������Ŀ
				//� Verifica Vendedores da N.F.Original �
				//���������������������������������������
				
				CtrlVndDev := .F.
				lNfD2Ori   := .F.
				If AvalTes((cSD1)->D1_TES,cEstoq,cDupli)
					dbSelectArea("SD2")
					nSavOrd := IndexOrd()
					dbSetOrder(3)

					dbSeek(xFilial("SD2")+(cSD1)->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD))
					While !Eof() .And. (xFilial("SD2")+(cSD1)->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD)) == ;
						D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD
					
						lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)
					
						If !Empty((cSD1)->D1_ITEMORI) .AND. AllTrim((cSD1)->D1_ITEMORI) != D2_ITEM .Or. !lRet .Or. !Eval(bFiltro)
							dbSkip()
							Loop
						Else
							CtrlVndDev := A780Vend(@cVends,nVend)
							If Ascan(aDev,D2_CLIENTE + D2_LOJA + D2_COD + D2_DOC + D2_SERIE + D2_ITEM) > 0
								lNfD2Ori := .T.
							EndIf
						Endif
						dbSkip()
					End
				
					dbSelectArea("SD2")
					dbSetOrder(nSavOrd)
					dbSelectArea(cSD1)
				
					If !(CtrlVndDev) .Or. lNfD2Ori
						dbSkip()
						Loop
					EndIf
				
					lProcessou := .t.
				
					If li > 55
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					EndIf
				
					If lNewCli
					
						If li > 51
							cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
						EndIf
					
						@ Li,000 Psay Repli('-',limite)
					
						Li++
						@ Li,000 Psay (cAliasSA1)->A1_COD
						@ Li,009 Psay (cAliasSA1)->A1_NOME
						/*If !Empty((cAliasSA1)->A1_OBSERV)
							Li++
							@ Li,000 Psay STR0013+(cAliasSA1)->A1_OBSERV		//"Obs.: "
						EndIf*/
					
						Li+=2
					
						lNewCli := .F.
					
					EndIf
				
					LI++
					SF1->(dbSeek(xFilial("SF1")+(cSD1)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))
					cUM := (cSD1)->D1_UM
				
					@Li ,  0 Psay (cSD1)->D1_COD
					@li , 16 Psay STR0017 //"DEV"
					@Li , 46 Psay (cSD1)->(D1_DOC+'/'+&(SerieNfId("SD1",3,"D1_SERIE"))) // VERIFICAR PORQUE -
					nVlrTot:=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,(cSD1)->D1_DTDIGIT,nDecs,SF1->F1_TXMOEDA)
					@Li,aColuna[3] Psay cUM
					@Li,aColuna[4] Psay -(cSD1)->D1_QUANT PICTURE "@)"+PesqPictqt("D1_QUANT",14)
					@Li,aColuna[6] Psay -nVlrTot           PICTURE "@)"+PesqPict("SD1","D1_TOTAL",16,mv_par09)
					nTotCli1 -= (cSD1)->D1_QUANT
					nTotCli2 -= nVlrTot
					nTotGer1 -= (cSD1)->D1_QUANT
					nTotGer2 -= nVlrTot
				Endif
				dbSkip()
			EndDo
			
			If (nTotCli1 != 0) .or. (nTotCli2 != 0)
				LI+=2
				@Li , 07 Psay STR0015+(cAliasSA1)->A1_COD	//"TOTAL DO CLIENTE - "
				@Li , 52 Psay "---->"
				@Li ,aColuna[4] Psay nTotCli1 PICTURE "@)"+PesqPictqt("D2_QUANT",16)
				@Li ,aColuna[6] Psay nTotCli2 PICTURE "@)"+PesqPict("SD2","D2_TOTAL",18,mv_par09)
				LI+=1
			EndIf
			
		EndIf
		
	Endif
	
	DbSelectArea(cAliasSA1)
	DbSkip()
EndDo

If lProcessou
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	EndIf
	Li+=2
	@Li , 07 Psay STR0016		//"T O T A L   G E R A L                        ---->"
    @Li ,aColuna[4] Psay nTotGer1 PICTURE "@)"+PesqPictqt("D2_QUANT",16)
    @Li ,aColuna[6] Psay nTotGer2 PICTURE "@)"+PesqPict("SD2","D2_TOTAL",18,mv_par09)
	roda(cbcont,cbtxt,tamanho)
Endif

dbSelectArea("SD1")
dbClearFilter()
RetIndex("SD1")

dbSelectArea("SD2")
dbClearFilter()
RetIndex("SD2")

If( valtype(oTmpTab_1) == "O")
	oTmpTab_1:Delete()
	freeObj(oTmpTab_1)
	oTmpTab_1 := nil
EndIf

If( valtype(oTmpTab_2) == "O")
	oTmpTab_2:Delete()
	freeObj(oTmpTab_2)
	oTmpTab_2 := nil
EndIf

If aReturn[5] = 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
EndIf

MS_FLUSH()

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A780Vend � Autor � Rogerio F. Guimaraes  � Data � 28.10.97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica Intervalo de Vendedores                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR780			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function A780Vend(cVends,nVend)
Local cAlias:=Alias(),sVend,sCampo
Local lVend, cVend, cBusca
Local nx
lVend  := .F.
cVends := ""
// Nao tem Alias na frente dos campos do SD2 para poder trabalhar em DBF e TOP
cBusca := xFilial("SF2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA
dbSelectArea("SF2")
If dbSeek(cBusca)
	cVend := "1"
	For nx := 1 to nVend
		sCampo := "F2_VEND" + cVend
		sVend := FieldGet(FieldPos(sCampo))
		If (sVend >= mv_par07 .And. sVend <= mv_par08) .And. (!Empty(sVend))
			cVends += If(Len(cVends)>0,"/","") + sVend
		EndIf
		If (sVend >= mv_par07 .And. sVend <= mv_par08) .And. (nX == 1 .Or. !Empty(sVend))
			lVend := .T.
		EndIf
		cVend := Soma1(cVend, 1)
	Next
EndIf
dbSelectArea(cAlias)
Return(lVend)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � SomaDev  � Autor � Claudecino C Leao     � Data � 28.09.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Soma devolucoes de Vendas                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR780			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function SomaDev(nDevQtd, nDevVal, aDev, cEstoq, cDupli )

Local DtMoedaDev  := (cSD2)->D2_EMISSAO

If (cSD1)->(dbSeek(xFilial("SD1")+(cSD2)->(D2_CLIENTE + D2_LOJA + D2_COD )))
	//��������������������������Ŀ
	//� Soma Devolucoes          �
	//����������������������������
	While (cSD1)->(D1_FILIAL+D1_FORNECE+D1_LOJA+D1_COD) == (cSD2)->( xFilial("SD2")+D2_CLIENTE+D2_LOJA+D2_COD).AND.!(cSD1)->(Eof())                   
	
		//����������������������������������������������������������Ŀ
		//� Avalia TES                                               �
		//������������������������������������������������������������
		If !AvalTes((cSD1)->D1_TES,cEstoq,cDupli)
	        (cSD1)->(dbSkip())
			Loop
		Endif
	
        DtMoedaDev  := IIF(MV_PAR17 == 1,(cSD1)->D1_DTDIGIT,(cSD2)->D2_EMISSAO)

		SF1->(dbSeek(xFilial("SF1")+(cSD1)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))

		If (cSD1)->(D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)) == (cSD2)->(D2_DOC   + D2_SERIE   + D2_ITEM )

			Aadd(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)))
			nDevQtd -= (cSD1)->D1_QUANT
			nDevVal -=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,DtMoedaDev,nDecs+1,SF1->F1_TXMOEDA)

		ElseIf mv_par15 == 2 .And. (cSD1)->D1_DTDIGIT < (cSD2)->D2_EMISSAO .And.;
			   (cSD1)->(D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)) < ;
			   (cSD2)->(D2_DOC   + D2_SERIE   + D2_ITEM ) .And.;
			   Ascan(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI))) == 0

			Aadd(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)))
			nDevQtd -= (cSD1)->D1_QUANT
			nDevVal -=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,DtMoedaDev,nDecs+1,SF1->F1_TXMOEDA)

		EndIf

        (cSD1)->(dbSkip())

	EndDo

EndIf
Return .t.
/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    �A780CriaTmp� Autor � Rubens Joao Pante     � Data � 04/07/01 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Cria temporario a partir da consulta corrente (TOP)          ���
��������������������������������������������������������������������������Ĵ��
��� Uso      �MATR780 (TOPCONNECT)                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function A780CriaTmp(aIndice, aStruTmp, cAliasTmp, cAlias)
	
	Local nI, nF, nPos
	Local cFieldName := ""
	nF := (cAlias)->(Fcount())
	
    //-------------------------------------------------------------------
	// Instancia tabela tempor�ria.  
	//-------------------------------------------------------------------
	If( valtype(oTmpTab_1) == "O")
		oTmpTab_2	:= FWTemporaryTable():New( cAliasTmp )
		
		oTmpTab_2:SetFields( aStruTmp )
		oTmpTab_2:AddIndex("1",aIndice)
		oTmpTab_2:Create()
	Else
		oTmpTab_1	:= FWTemporaryTable():New( cAliasTmp )
		
		oTmpTab_1:SetFields( aStruTmp )
		oTmpTab_1:AddIndex("1",aIndice)
		oTmpTab_1:Create()
	EndIf


	(cAlias)->(DbGoTop())
	While ! (cAlias)->(Eof())
        (cAliasTmp)->(DbAppend())
		For nI := 1 To nF 
			cFieldName := (cAlias)->( FieldName( ni ))
		    If (nPos := (cAliasTmp)->(FieldPos(cFieldName))) > 0
		   		    (cAliasTmp)->(FieldPut(nPos,(cAlias)->(FieldGet((cAlias)->(FieldPos(cFieldName))))))
            EndIf   		
		Next
		(cAlias)->(DbSkip())
	End
	(cAlias)->(dbCloseArea())
    DbSelectArea(cAliasTmp)
Return Nil	
