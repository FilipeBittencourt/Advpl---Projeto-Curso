#INCLUDE "PROTHEUS.CH"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
    "    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
    "    border-top-width: 3px; "+;
    "    border-left-width: 3px; "+;
    "    border-right-width: 3px; "+;
    "    border-bottom-width: 3px }"+;
    "QPushButton:pressed {	color: #FFFFFF; "+;
    "    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
    "    border-top-width: 3px; "+;
    "    border-left-width: 3px; "+;
    "    border-right-width: 3px; "+;
    "    border-bottom-width: 3px }"

//--------------------------------------------------------------------
/*/{Protheus.doc} UPDZL8
Fun��o de update de dicion�rios para compatibiliza��o

@author TOTVS Protheus
@since  04/10/2018
@obs    Gerado por EXPORDIC - V.6.0.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDZL8( cEmpAmb, cFilAmb )

    Local   aSay      := {}
    Local   aButton   := {}
    Local   aMarcadas := {}
    Local   cTitulo   := "ATUALIZA��O DE DICION�RIOS E TABELAS DO SISTEMA (SIX/SX2/SX3)"
    Local   cDesc1    := "Projeto: C-15 "
    Local   cDesc2    := "Autor: Facile - Data: 30/06/2020 "
    Local   cDesc3    := ""
    Local   cDesc4    := "Descri��o: Campos que compoem o projeto C-15 "
    Local   cDesc5    := ""
    Local   cDesc6    := ""
    Local   cDesc7    := ""
    Local   cMsg      := ""
    Local   lOk       := .F.
    Local   lAuto     := ( cEmpAmb <> NIL .or. cFilAmb <> NIL )

    Private oMainWnd  := NIL
    Private oProcess  := NIL

    #IFDEF TOP
        TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
    #ENDIF

    __cInterNet := NIL
    __lPYME     := .F.

    Set Dele On

// Mensagens de Tela Inicial
    aAdd( aSay, cDesc1 )
    aAdd( aSay, cDesc2 )
    aAdd( aSay, cDesc3 )
    aAdd( aSay, cDesc4 )
    aAdd( aSay, cDesc5 )
    aAdd( aSay, cDesc6 )
    aAdd( aSay, cDesc7 )

// Botoes Tela Inicial
    aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
    aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

    If lAuto
        lOk := .T.
    Else
        FormBatch(  cTitulo,  aSay,  aButton )
    EndIf

    If lOk

        If FindFunction( "MPDicInDB" ) .AND. MPDicInDB()
            cMsg := "Este update N�O PODE ser executado neste Ambiente." + CRLF + CRLF + ;
                "Os arquivos de dicion�rios se encontram no Banco de Dados e este update est� preparado " + ;
                "para atualizar apenas ambientes com dicion�rios no formato ISAM (.dbf ou .dtc)."

            If lAuto
                AutoGrLog( Replicate( "-", 128 ) )
                AutoGrLog( Replicate( " ", 128 ) )
                AutoGrLog( "LOG DA ATUALIZA��O DOS DICION�RIOS" )
                AutoGrLog( Replicate( " ", 128 ) )
                AutoGrLog( Replicate( "-", 128 ) )
                AutoGrLog( Replicate( " ", 128 ) )
                AutoGrLog( cMsg )
                ConOut( DToC(Date()) + "|" + Time() + cMsg )
            Else
                MsgInfo( cMsg )
            EndIf

            Return NIL
        EndIf

        If lAuto
            aMarcadas :={{ cEmpAmb, cFilAmb, "" }}
        Else
/*
            If !FWAuthAdmin()
			Final( "Atualiza��o n�o Realizada." )
            EndIf
*/
            aMarcadas := EscEmpresa()
        EndIf

        If !Empty( aMarcadas )
            If lAuto .OR. MsgNoYes( "Confirma a atualiza��o dos dicion�rios ?", cTitulo )
                oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
                oProcess:Activate()

                If lAuto
                    If lOk
                        MsgStop( "Atualiza��o Realizada.", "UPDZL8" )
                    Else
                        MsgStop( "Atualiza��o n�o Realizada.", "UPDZL8" )
                    EndIf
                    dbCloseAll()
                Else
                    If lOk
                        Final( "Atualiza��o Realizada." )
                    Else
                        Final( "Atualiza��o n�o Realizada." )
                    EndIf
                EndIf

            Else
                Final( "Atualiza��o n�o Realizada." )

            EndIf

        Else
            Final( "Atualiza��o n�o Realizada." )

        EndIf

    EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Fun��o de processamento da grava��o dos arquivos

@author TOTVS Protheus
@since  04/10/2018
@obs    Gerado por EXPORDIC - V.6.0.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSTProc( lEnd, aMarcadas, lAuto )
    Local   aInfo     := {}
    Local   aRecnoSM0 := {}
    Local   cAux      := ""
    Local   cFile     := ""
    Local   cFileLog  := ""
    Local   cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
    Local   cTCBuild  := "TCGetBuild"
    Local   cTexto    := ""
    Local   cTopBuild := ""
    Local   lOpen     := .F.
    Local   lRet      := .T.
    Local   nI        := 0
    Local   nPos      := 0
    Local   nRecno    := 0
    Local   nX        := 0
    Local   oDlg      := NIL
    Local   oFont     := NIL
    Local   oMemo     := NIL

    Private aArqUpd   := {}

    If ( lOpen := MyOpenSm0(.T.) )

        dbSelectArea( "SM0" )
        dbGoTop()

        While !SM0->( EOF() )
            // S� adiciona no aRecnoSM0 se a empresa for diferente
            If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
                    .AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
                aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
            EndIf
            SM0->( dbSkip() )
        End

        SM0->( dbCloseArea() )

        If lOpen

            For nI := 1 To Len( aRecnoSM0 )

                If !( lOpen := MyOpenSm0(.F.) )
                    MsgStop( "Atualiza��o da empresa " + aRecnoSM0[nI][2] + " n�o efetuada." )
                    Exit
                EndIf

                SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

                RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

                lMsFinalAuto := .F.
                lMsHelpAuto  := .F.

                AutoGrLog( Replicate( "-", 128 ) )
                AutoGrLog( Replicate( " ", 128 ) )
                AutoGrLog( "LOG DA ATUALIZA��O DOS DICION�RIOS" )
                AutoGrLog( Replicate( " ", 128 ) )
                AutoGrLog( Replicate( "-", 128 ) )
                AutoGrLog( " " )
                AutoGrLog( " Dados Ambiente" )
                AutoGrLog( " --------------------" )
                AutoGrLog( " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt )
                AutoGrLog( " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) )
                AutoGrLog( " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) )
                AutoGrLog( " DataBase...........: " + DtoC( dDataBase ) )
                AutoGrLog( " Data / Hora �nicio.: " + DtoC( Date() )  + " / " + Time() )
                AutoGrLog( " Environment........: " + GetEnvServer()  )
                AutoGrLog( " StartPath..........: " + GetSrvProfString( "StartPath", "" ) )
                AutoGrLog( " RootPath...........: " + GetSrvProfString( "RootPath" , "" ) )
                AutoGrLog( " Vers�o.............: " + GetVersao(.T.) )
                AutoGrLog( " Usu�rio TOTVS .....: " + __cUserId + " " +  cUserName )
                AutoGrLog( " Computer Name......: " + GetComputerName() )

                aInfo   := GetUserInfo()
                If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
                    AutoGrLog( " " )
                    AutoGrLog( " Dados Thread" )
                    AutoGrLog( " --------------------" )
                    AutoGrLog( " Usu�rio da Rede....: " + aInfo[nPos][1] )
                    AutoGrLog( " Esta��o............: " + aInfo[nPos][2] )
                    AutoGrLog( " Programa Inicial...: " + aInfo[nPos][5] )
                    AutoGrLog( " Environment........: " + aInfo[nPos][6] )
                    AutoGrLog( " Conex�o............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) ) )
                EndIf
                AutoGrLog( Replicate( "-", 128 ) )
                AutoGrLog( " " )

                If !lAuto
                    AutoGrLog( Replicate( "-", 128 ) )
                    AutoGrLog( "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF )
                EndIf

                oProcess:SetRegua1( 8 )

                //------------------------------------
                // Atualiza o dicion�rio SX2
                //------------------------------------
                oProcess:IncRegua1( "Dicion�rio de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
                FSAtuSX2()

                //------------------------------------
                // Atualiza o dicion�rio SX3
                //------------------------------------
                FSAtuSX3()

                //------------------------------------
                // Atualiza o dicion�rio SIX
                //------------------------------------
                oProcess:IncRegua1( "Dicion�rio de �ndices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
                FSAtuSIX()

                oProcess:IncRegua1( "Dicion�rio de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
                oProcess:IncRegua2( "Atualizando campos/�ndices" )

                // Altera��o f�sica dos arquivos
                __SetX31Mode( .F. )

                If FindFunction(cTCBuild)
                    cTopBuild := &cTCBuild.()
                EndIf

                For nX := 1 To Len( aArqUpd )

                    If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
                        If ( ( aArqUpd[nX] >= "NQ " .AND. aArqUpd[nX] <= "NZZ" ) .OR. ( aArqUpd[nX] >= "O0 " .AND. aArqUpd[nX] <= "NZZ" ) ) .AND.;
                                !aArqUpd[nX] $ "NQD,NQF,NQP,NQT"
                            TcInternal( 25, "CLOB" )
                        EndIf
                    EndIf

                    If Select( aArqUpd[nX] ) > 0
                        dbSelectArea( aArqUpd[nX] )
                        dbCloseArea()
                    EndIf

                    X31UpdTable( aArqUpd[nX] )

                    If __GetX31Error()
                        Alert( __GetX31Trace() )
                        MsgStop( "Ocorreu um erro desconhecido durante a atualiza��o da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicion�rio e da tabela.", "ATEN��O" )
                        AutoGrLog( "Ocorreu um erro desconhecido durante a atualiza��o da estrutura da tabela : " + aArqUpd[nX] )
                    EndIf

                    If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
                        TcInternal( 25, "OFF" )
                    EndIf

                Next nX

                //------------------------------------
                // Atualiza o dicion�rio SX7
                //------------------------------------
                oProcess:IncRegua1( "Dicion�rio de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
                FSAtuSX7( @cTexto )

                //------------------------------------
                // Atualiza o dicion�rio SXB
                //------------------------------------
                oProcess:IncRegua1( "Dicion�rio de consultas padr�o" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
                FSAtuSXB()

                AutoGrLog( Replicate( "-", 128 ) )
                AutoGrLog( " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time() )
                AutoGrLog( Replicate( "-", 128 ) )

                RpcClearEnv()

            Next nI

            If !lAuto

                cTexto := LeLog()

                Define Font oFont Name "Mono AS" Size 5, 12

                Define MsDialog oDlg Title "Atualiza��o concluida." From 3, 0 to 340, 417 Pixel

                @ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
                oMemo:bRClicked := { || AllwaysTrue() }
                oMemo:oFont     := oFont

                Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
                Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
                    MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel

                Activate MsDialog oDlg Center

            EndIf

        EndIf

    Else

        lRet := .F.

    EndIf

Return lRet


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX2
Fun��o de processamento da grava��o do SX2 - Arquivos

@author TOTVS Protheus
@since  04/10/2018
@obs    Gerado por EXPORDIC - V.6.0.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX2()
    Local aEstrut   := {}
    Local aSX2      := {}
    Local cAlias    := ""
    Local cCpoUpd   := "X2_ROTINA /X2_UNICO  /X2_DISPLAY/X2_SYSOBJ /X2_USROBJ /X2_POSLGT /X2_ARQUIVO/"
    Local cEmpr     := ""
    Local cPath     := ""
    Local nI        := 0
    Local nJ        := 0

    AutoGrLog( "�nicio da Atualiza��o" + " SX2" + CRLF )

    aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"   , "X2_NOMESPA", "X2_NOMEENG", "X2_MODO"   , ;
        "X2_TTS"    , "X2_ROTINA" , "X2_PYME"   , "X2_UNICO"  , "X2_DISPLAY", "X2_SYSOBJ" , "X2_USROBJ" , ;
        "X2_POSLGT" , "X2_CLOB"   , "X2_AUTREC" , "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" }


    dbSelectArea( "SX2" )
    SX2->( dbSetOrder( 1 ) )
    SX2->( dbGoTop() )
    cPath := SX2->X2_PATH
    cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
    cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

//
// Tabela ZL8
//
    aAdd( aSX2, { ;
        'ZL8'																	, ; //X2_CHAVE
    cPath																	, ; //X2_PATH
    'ZL8010'																, ; //X2_ARQUIVO
    'INTEGRACAO BAIXA QUEBRA'   											, ; //X2_NOME
    'INTEGRACAO BAIXA QUEBRA'   											, ; //X2_NOMESPA
    'INTEGRACAO BAIXA QUEBRA'   											, ; //X2_NOMEENG
    'C'																		, ; //X2_MODO
    ''																		, ; //X2_TTS
    ''																		, ; //X2_ROTINA
    ''																		, ; //X2_PYME
    ''																		, ; //X2_UNICO
    ''																		, ; //X2_DISPLAY
    ''																		, ; //X2_SYSOBJ
    ''																		, ; //X2_USROBJ
    ''																		, ; //X2_POSLGT
    ''																		, ; //X2_CLOB
    ''																		, ; //X2_AUTREC
    'C'																		, ; //X2_MODOEMP
    'C'																		, ; //X2_MODOUN
    0																		} ) //X2_MODULO

//
// Atualizando dicion�rio
//
    oProcess:SetRegua2( Len( aSX2 ) )

    dbSelectArea( "SX2" )
    dbSetOrder( 1 )

    For nI := 1 To Len( aSX2 )

        oProcess:IncRegua2( "Atualizando Arquivos (SX2)..." )

        If !SX2->( dbSeek( aSX2[nI][1] ) )

            If !( aSX2[nI][1] $ cAlias )
                cAlias += aSX2[nI][1] + "/"
                AutoGrLog( "Foi inclu�da a tabela " + aSX2[nI][1] )
            EndIf

            RecLock( "SX2", .T. )
            For nJ := 1 To Len( aSX2[nI] )
                If FieldPos( aEstrut[nJ] ) > 0
                    //If AllTrim( aEstrut[nJ] ) == "X2_ARQUIVO"
                    //FieldPut( FieldPos( aEstrut[nJ] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  "0" )
                    //Else
                    FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
                    //EndIf
                EndIf
            Next nJ
            MsUnLock()

        Else

            If  !( StrTran( Upper( AllTrim( SX2->X2_UNICO ) ), " ", "" ) == StrTran( Upper( AllTrim( aSX2[nI][12]  ) ), " ", "" ) )
                RecLock( "SX2", .F. )
                SX2->X2_UNICO := aSX2[nI][12]
                MsUnlock()

                If MSFILE( RetSqlName( aSX2[nI][1] ),RetSqlName( aSX2[nI][1] ) + "_UNQ"  )
                    TcInternal( 60, RetSqlName( aSX2[nI][1] ) + "|" + RetSqlName( aSX2[nI][1] ) + "_UNQ" )
                EndIf

                AutoGrLog( "Foi alterada a chave �nica da tabela " + aSX2[nI][1] )
            EndIf

            RecLock( "SX2", .F. )
            For nJ := 1 To Len( aSX2[nI] )
                If FieldPos( aEstrut[nJ] ) > 0
                    If PadR( aEstrut[nJ], 10 ) $ cCpoUpd
                        FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
                    EndIf

                EndIf
            Next nJ
            MsUnLock()

        EndIf

    Next nI

    AutoGrLog( CRLF + "Final da Atualiza��o" + " SX2" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX3
Fun��o de processamento da grava��o do SX3 - Campos

@author TOTVS Protheus
@since  04/10/2018
@obs    Gerado por EXPORDIC - V.6.0.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX3()
    Local aEstrut   := {}
    Local aSX3      := {}
    Local cAlias    := ""
    Local cAliasAtu := ""
    Local cMsg      := ""
    Local cSeqAtu   := ""
    Local cX3Campo  := ""
    Local cX3Dado   := ""
    Local lTodosNao := .F.
    Local lTodosSim := .T.
    Local nI        := 0
    Local nJ        := 0
    Local nOpcA     := 0
    Local nPosArq   := 0
    Local nPosCpo   := 0
    Local nPosOrd   := 0
    Local nPosSXG   := 0
    Local nPosTam   := 0
    Local nPosVld   := 0
    Local nSeqAtu   := 0
    Local nTamSeek  := Len( SX3->X3_CAMPO )

    AutoGrLog( "�nicio da Atualiza��o" + " SX3" + CRLF )

    aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
        { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
        { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
        { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
        { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
        { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
        { "X3_AGRUP"  , 0 }, { "X3_MODAL"  , 0 }, { "X3_PYME"   , 0 } }

    aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )

//
// --- ATEN��O ---
// Coloque .F. na 2a. posi��o de cada elemento do array, para os dados do SX3
// que n�o ser�o atualizados quando o campo j� existir.
//

//
// Campos Tabela ZL8
//
    aAdd( aSX3, { ;
        { 'ZL8'																	, .T. }, ; //X3_ARQUIVO
    { '01'																	, .T. }, ; //X3_ORDEM
    { 'ZL8_FILIAL'															, .T. }, ; //X3_CAMPO
    { 'C'																	, .T. }, ; //X3_TIPO
    { 2																		, .T. }, ; //X3_TAMANHO
    { 0																		, .T. }, ; //X3_DECIMAL
    { 'Filial'																, .T. }, ; //X3_TITULO
    { 'Sucursal'															, .T. }, ; //X3_TITSPA
    { 'Branch'																, .T. }, ; //X3_TITENG
    { 'Filial do Sistema'													, .T. }, ; //X3_DESCRIC
    { 'Sucursal'															, .T. }, ; //X3_DESCSPA
    { 'Branch of the System'												, .T. }, ; //X3_DESCENG
    { '@!'																	, .T. }, ; //X3_PICTURE
    { ''																	, .T. }, ; //X3_VALID
    { Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .T. }, ; //X3_USADO
    { ''																	, .T. }, ; //X3_RELACAO
    { ''																	, .T. }, ; //X3_F3
    { 1																		, .T. }, ; //X3_NIVEL
    { Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
    { ''																	, .T. }, ; //X3_CHECK
    { ''																	, .T. }, ; //X3_TRIGGER
    { 'U'																	, .T. }, ; //X3_PROPRI
    { 'N'																	, .T. }, ; //X3_BROWSE
    { 'A'																	, .T. }, ; //X3_VISUAL
    { 'R'																	, .T. }, ; //X3_CONTEXT
    { ''																	, .T. }, ; //X3_OBRIGAT
    { ''																	, .T. }, ; //X3_VLDUSER
    { ''																	, .T. }, ; //X3_CBOX
    { ''																	, .T. }, ; //X3_CBOXSPA
    { ''																	, .T. }, ; //X3_CBOXENG
    { ''																	, .T. }, ; //X3_PICTVAR
    { ''																	, .T. }, ; //X3_WHEN
    { ''																	, .T. }, ; //X3_INIBRW
    { '033'																	, .T. }, ; //X3_GRPSXG
    { ''																	, .T. }, ; //X3_FOLDER
    { ''																	, .T. }, ; //X3_CONDSQL
    { ''																	, .T. }, ; //X3_CHKSQL
    { ''																	, .T. }, ; //X3_IDXSRV
    { 'N'																	, .T. }, ; //X3_ORTOGRA
    { ''																	, .T. }, ; //X3_TELA
    { ''																	, .T. }, ; //X3_POSLGT
    { 'N'																	, .T. }, ; //X3_IDXFLD
    { ''																	, .T. }, ; //X3_AGRUP
    { ''																	, .T. }, ; //X3_MODAL
    { ''																	, .T. }} ) //X3_PYME

    aAdd( aSX3, { ;
        { 'ZL8'																	, .T. }, ; //X3_ARQUIVO
    { '02'																	, .T. }, ; //X3_ORDEM
    { 'ZL8_CODEMP'															, .T. }, ; //X3_CAMPO
    { 'C'																	, .T. }, ; //X3_TIPO
    { 2																		, .T. }, ; //X3_TAMANHO
    { 0																		, .T. }, ; //X3_DECIMAL
    { 'Empresa'																, .T. }, ; //X3_TITULO
    { 'Empresa'																, .T. }, ; //X3_TITSPA
    { 'Empresa'																, .T. }, ; //X3_TITENG
    { 'Empresa'																, .T. }, ; //X3_DESCRIC
    { 'Empresa'																, .T. }, ; //X3_DESCSPA
    { 'Empresa'																, .T. }, ; //X3_DESCENG
    { ''																	, .T. }, ; //X3_PICTURE
    { ''																	, .T. }, ; //X3_VALID
    { Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
    { ''																	, .T. }, ; //X3_RELACAO
    { 'YM0'																	, .T. }, ; //X3_F3
    { 0																		, .T. }, ; //X3_NIVEL
    { Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
    { ''																	, .T. }, ; //X3_CHECK
    { ''																	, .T. }, ; //X3_TRIGGER
    { 'U'																	, .T. }, ; //X3_PROPRI
    { 'S'																	, .T. }, ; //X3_BROWSE
    { 'V'																	, .T. }, ; //X3_VISUAL
    { 'R'																	, .T. }, ; //X3_CONTEXT
    { ''																	, .T. }, ; //X3_OBRIGAT
    { ''																	, .T. }, ; //X3_VLDUSER
    { ''																	, .T. }, ; //X3_CBOX
    { ''																	, .T. }, ; //X3_CBOXSPA
    { ''																	, .T. }, ; //X3_CBOXENG
    { ''																	, .T. }, ; //X3_PICTVAR
    { ''																	, .T. }, ; //X3_WHEN
    { ''	                                                                , .T. }, ; //X3_INIBRW
    { ''																	, .T. }, ; //X3_GRPSXG
    { ''																	, .T. }, ; //X3_FOLDER
    { ''																	, .T. }, ; //X3_CONDSQL
    { ''																	, .T. }, ; //X3_CHKSQL
    { ''																	, .T. }, ; //X3_IDXSRV
    { 'N'																	, .T. }, ; //X3_ORTOGRA
    { ''																	, .T. }, ; //X3_TELA
    { ''																	, .T. }, ; //X3_POSLGT
    { 'N'																	, .T. }, ; //X3_IDXFLD
    { ''																	, .T. }, ; //X3_AGRUP
    { ''																	, .T. }, ; //X3_MODAL
    { ''																	, .T. }} ) //X3_PYME

    aAdd( aSX3, { ;
        { 'ZL8'																	, .T. }, ; //X3_ARQUIVO
    { '03'																	, .T. }, ; //X3_ORDEM
    { 'ZL8_CODFIL'															, .T. }, ; //X3_CAMPO
    { 'C'																	, .T. }, ; //X3_TIPO
    { 2																		, .T. }, ; //X3_TAMANHO
    { 0																		, .T. }, ; //X3_DECIMAL
    { 'Filial'																, .T. }, ; //X3_TITULO
    { 'Filial'																, .T. }, ; //X3_TITSPA
    { 'Filial'																, .T. }, ; //X3_TITENG
    { 'Filial'																, .T. }, ; //X3_DESCRIC
    { 'Filial'																, .T. }, ; //X3_DESCSPA
    { 'Filial'																, .T. }, ; //X3_DESCENG
    { ''																	, .T. }, ; //X3_PICTURE
    { ''																	, .T. }, ; //X3_VALID
    { Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
    { ''																	, .T. }, ; //X3_RELACAO
    { 'SM0FIL'																, .T. }, ; //X3_F3
    { 0																		, .T. }, ; //X3_NIVEL
    { Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
    { ''																	, .T. }, ; //X3_CHECK
    { ''																	, .T. }, ; //X3_TRIGGER
    { 'U'																	, .T. }, ; //X3_PROPRI
    { 'S'																	, .T. }, ; //X3_BROWSE
    { 'A'																	, .T. }, ; //X3_VISUAL
    { 'R'																	, .T. }, ; //X3_CONTEXT
    { ''																	, .T. }, ; //X3_OBRIGAT
    { ''																	, .T. }, ; //X3_VLDUSER
    { ''																	, .T. }, ; //X3_CBOX
    { ''																	, .T. }, ; //X3_CBOXSPA
    { ''																	, .T. }, ; //X3_CBOXENG
    { ''																	, .T. }, ; //X3_PICTVAR
    { ''																	, .T. }, ; //X3_WHEN
    { ''                                                                	, .T. }, ; //X3_INIBRW
    { ''																	, .T. }, ; //X3_GRPSXG
    { ''																	, .T. }, ; //X3_FOLDER
    { ''																	, .T. }, ; //X3_CONDSQL
    { ''																	, .T. }, ; //X3_CHKSQL
    { ''																	, .T. }, ; //X3_IDXSRV
    { 'N'																	, .T. }, ; //X3_ORTOGRA
    { ''																	, .T. }, ; //X3_TELA
    { ''																	, .T. }, ; //X3_POSLGT
    { 'N'																	, .T. }, ; //X3_IDXFLD
    { ''																	, .T. }, ; //X3_AGRUP
    { ''																	, .T. }, ; //X3_MODAL
    { ''																	, .T. }} ) //X3_PYME

    aAdd( aSX3, { ;
        { 'ZL8'																	, .T. }, ; //X3_ARQUIVO
    { '04'																	, .T. }, ; //X3_ORDEM
    { 'ZL8_QUANT'															, .T. }, ; //X3_CAMPO
    { 'N'																	, .T. }, ; //X3_TIPO
    { 18																	, .T. }, ; //X3_TAMANHO
    { 8																		, .T. }, ; //X3_DECIMAL
    { 'Quantidade'															, .T. }, ; //X3_TITULO
    { 'Cantidad'															, .T. }, ; //X3_TITSPA
    { 'Amount'																, .T. }, ; //X3_TITENG
    { 'Quantidade do Movimento'												, .T. }, ; //X3_DESCRIC
    { 'Cantidad del Movimiento'												, .T. }, ; //X3_DESCSPA
    { 'Transaction Amt'														, .T. }, ; //X3_DESCENG
    { '@E 999,999,999.99999999'												, .T. }, ; //X3_PICTURE
    { 'A240Quant()'															, .T. }, ; //X3_VALID
    { Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
    { ''																	, .T. }, ; //X3_RELACAO
    { ''																	, .T. }, ; //X3_F3
    { 1																		, .T. }, ; //X3_NIVEL
    { Chr(154) + Chr(192)													, .T. }, ; //X3_RESERV
    { ''																	, .T. }, ; //X3_CHECK
    { 'S'																	, .T. }, ; //X3_TRIGGER
    { ''																	, .T. }, ; //X3_PROPRI
    { 'S'																	, .T. }, ; //X3_BROWSE
    { 'A'																	, .T. }, ; //X3_VISUAL
    { 'R'																	, .T. }, ; //X3_CONTEXT
    { ''																	, .T. }, ; //X3_OBRIGAT
    { ''																	, .T. }, ; //X3_VLDUSER
    { ''																	, .T. }, ; //X3_CBOX
    { ''																	, .T. }, ; //X3_CBOXSPA
    { ''																	, .T. }, ; //X3_CBOXENG
    { ''																	, .T. }, ; //X3_PICTVAR
    { ''																	, .T. }, ; //X3_WHEN
    { ''																	, .T. }, ; //X3_INIBRW
    { ''																	, .T. }, ; //X3_GRPSXG
    { ''																	, .T. }, ; //X3_FOLDER
    { ''																	, .T. }, ; //X3_CONDSQL
    { ''																	, .T. }, ; //X3_CHKSQL
    { 'N'																	, .T. }, ; //X3_IDXSRV
    { 'N'																	, .T. }, ; //X3_ORTOGRA
    { ''																	, .T. }, ; //X3_TELA
    { '1'																	, .T. }, ; //X3_POSLGT
    { 'N'																	, .T. }, ; //X3_IDXFLD
    { ''																	, .T. }, ; //X3_AGRUP
    { '2'																	, .T. }, ; //X3_MODAL
    { 'S'																	, .T. }} ) //X3_PYME

    aAdd( aSX3, { ;
        { 'ZL8'																	, .T. }, ; //X3_ARQUIVO
    { '05'																	, .T. }, ; //X3_ORDEM
    { 'ZL8_ETIQUE'															, .T. }, ; //X3_CAMPO
    { 'N'																	, .T. }, ; //X3_TIPO
    { 18																	, .T. }, ; //X3_TAMANHO
    { 0																		, .T. }, ; //X3_DECIMAL
    { 'Etiqueta'															, .T. }, ; //X3_TITULO
    { 'Etiqueta'															, .T. }, ; //X3_TITSPA
    { 'Etiqueta'															, .T. }, ; //X3_TITENG
    { 'Etiqueta'															, .T. }, ; //X3_DESCRIC
    { 'Etiqueta'															, .T. }, ; //X3_DESCSPA
    { 'Etiqueta'															, .T. }, ; //X3_DESCENG
    { ''																	, .T. }, ; //X3_PICTURE
    { ''																	, .T. }, ; //X3_VALID
    { Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
    { ''																	, .T. }, ; //X3_RELACAO
    { ''																	, .T. }, ; //X3_F3
    { 0																		, .T. }, ; //X3_NIVEL
    { Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
    { ''																	, .T. }, ; //X3_CHECK
    { ''																	, .T. }, ; //X3_TRIGGER
    { 'U'																	, .T. }, ; //X3_PROPRI
    { 'S'																	, .T. }, ; //X3_BROWSE
    { 'A'																	, .T. }, ; //X3_VISUAL
    { 'R'																	, .T. }, ; //X3_CONTEXT
    { ''																	, .T. }, ; //X3_OBRIGAT
    { ''																	, .T. }, ; //X3_VLDUSER
    { ''																	, .T. }, ; //X3_CBOX
    { ''																	, .T. }, ; //X3_CBOXSPA
    { ''																	, .T. }, ; //X3_CBOXENG
    { ''																	, .T. }, ; //X3_PICTVAR
    { ''																	, .T. }, ; //X3_WHEN
    { ''																	, .T. }, ; //X3_INIBRW
    { ''																	, .T. }, ; //X3_GRPSXG
    { ''																	, .T. }, ; //X3_FOLDER
    { ''																	, .T. }, ; //X3_CONDSQL
    { ''																	, .T. }, ; //X3_CHKSQL
    { ''																	, .T. }, ; //X3_IDXSRV
    { 'N'																	, .T. }, ; //X3_ORTOGRA
    { ''																	, .T. }, ; //X3_TELA
    { ''																	, .T. }, ; //X3_POSLGT
    { 'N'																	, .T. }, ; //X3_IDXFLD
    { ''																	, .T. }, ; //X3_AGRUP
    { ''																	, .T. }, ; //X3_MODAL
    { ''																	, .T. }} ) //X3_PYME

    aAdd( aSX3, { ;
        { 'ZL8'																	, .T. }, ; //X3_ARQUIVO
    { '06'																	, .T. }, ; //X3_ORDEM
    { 'ZL8_PRODUT'															, .T. }, ; //X3_CAMPO
    { 'C'																	, .T. }, ; //X3_TIPO
    { 15																	, .T. }, ; //X3_TAMANHO
    { 0																		, .T. }, ; //X3_DECIMAL
    { 'Produto'																, .T. }, ; //X3_TITULO
    { 'Produto'																, .T. }, ; //X3_TITSPA
    { 'Produto'																, .T. }, ; //X3_TITENG
    { 'Produto'																, .T. }, ; //X3_DESCRIC
    { 'Produto'																, .T. }, ; //X3_DESCSPA
    { 'Produto'																, .T. }, ; //X3_DESCENG
    { ''																	, .T. }, ; //X3_PICTURE
    { ''																	, .T. }, ; //X3_VALID
    { Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
    { ''																	, .T. }, ; //X3_RELACAO
    { 'SB1'																	, .T. }, ; //X3_F3
    { 0																		, .T. }, ; //X3_NIVEL
    { Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
    { ''																	, .T. }, ; //X3_CHECK
    { ''																	, .T. }, ; //X3_TRIGGER
    { 'U'																	, .T. }, ; //X3_PROPRI
    { 'S'																	, .T. }, ; //X3_BROWSE
    { 'A'																	, .T. }, ; //X3_VISUAL
    { 'R'																	, .T. }, ; //X3_CONTEXT
    { ''																	, .T. }, ; //X3_OBRIGAT
    { ''																	, .T. }, ; //X3_VLDUSER
    { ''																	, .T. }, ; //X3_CBOX
    { ''																	, .T. }, ; //X3_CBOXSPA
    { ''																	, .T. }, ; //X3_CBOXENG
    { ''																	, .T. }, ; //X3_PICTVAR
    { ''																	, .T. }, ; //X3_WHEN
    { ''																	, .T. }, ; //X3_INIBRW
    { ''																	, .T. }, ; //X3_GRPSXG
    { ''																	, .T. }, ; //X3_FOLDER
    { ''																	, .T. }, ; //X3_CONDSQL
    { ''																	, .T. }, ; //X3_CHKSQL
    { ''																	, .T. }, ; //X3_IDXSRV
    { 'N'																	, .T. }, ; //X3_ORTOGRA
    { ''																	, .T. }, ; //X3_TELA
    { ''																	, .T. }, ; //X3_POSLGT
    { 'N'																	, .T. }, ; //X3_IDXFLD
    { ''																	, .T. }, ; //X3_AGRUP
    { ''																	, .T. }, ; //X3_MODAL
    { ''																	, .T. }} ) //X3_PYME

    aAdd( aSX3, { ;
        { 'ZL8'																	, .T. }, ; //X3_ARQUIVO
    { '07'																	, .T. }, ; //X3_ORDEM
    { 'ZL8_LOTECT'															, .T. }, ; //X3_CAMPO
    { 'C'																	, .T. }, ; //X3_TIPO
    { 10																	, .T. }, ; //X3_TAMANHO
    { 0																		, .T. }, ; //X3_DECIMAL
    { 'Lote'																, .T. }, ; //X3_TITULO
    { 'Lote'																, .T. }, ; //X3_TITSPA
    { 'Lote'																, .T. }, ; //X3_TITENG
    { 'Lote'																, .T. }, ; //X3_DESCRIC
    { 'Lote'																, .T. }, ; //X3_DESCSPA
    { 'Lote'																, .T. }, ; //X3_DESCENG
    { ''																	, .T. }, ; //X3_PICTURE
    { ''																	, .T. }, ; //X3_VALID
    { Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
    { ''																	, .T. }, ; //X3_RELACAO
    { ''																	, .T. }, ; //X3_F3
    { 0																		, .T. }, ; //X3_NIVEL
    { Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
    { ''																	, .T. }, ; //X3_CHECK
    { ''																	, .T. }, ; //X3_TRIGGER
    { 'U'																	, .T. }, ; //X3_PROPRI
    { 'S'																	, .T. }, ; //X3_BROWSE
    { 'A'																	, .T. }, ; //X3_VISUAL
    { 'R'																	, .T. }, ; //X3_CONTEXT
    { ''																	, .T. }, ; //X3_OBRIGAT
    { ''																	, .T. }, ; //X3_VLDUSER
    { ''																	, .T. }, ; //X3_CBOX
    { ''																	, .T. }, ; //X3_CBOXSPA
    { ''																	, .T. }, ; //X3_CBOXENG
    { ''																	, .T. }, ; //X3_PICTVAR
    { ''																	, .T. }, ; //X3_WHEN
    { ''																	, .T. }, ; //X3_INIBRW
    { ''																	, .T. }, ; //X3_GRPSXG
    { ''																	, .T. }, ; //X3_FOLDER
    { ''																	, .T. }, ; //X3_CONDSQL
    { ''																	, .T. }, ; //X3_CHKSQL
    { ''																	, .T. }, ; //X3_IDXSRV
    { 'N'																	, .T. }, ; //X3_ORTOGRA
    { ''																	, .T. }, ; //X3_TELA
    { ''																	, .T. }, ; //X3_POSLGT
    { 'N'																	, .T. }, ; //X3_IDXFLD
    { ''																	, .T. }, ; //X3_AGRUP
    { ''																	, .T. }, ; //X3_MODAL
    { ''																	, .T. }} ) //X3_PYME

    aAdd( aSX3, { ;
        { 'ZL8'																	, .T. }, ; //X3_ARQUIVO
    { '08'																	, .T. }, ; //X3_ORDEM
    { 'ZL8_USER'															, .T. }, ; //X3_CAMPO
    { 'C'																	, .T. }, ; //X3_TIPO
    { 15																	, .T. }, ; //X3_TAMANHO
    { 0																		, .T. }, ; //X3_DECIMAL
    { 'Usuario'																, .T. }, ; //X3_TITULO
    { 'Usuario'																, .T. }, ; //X3_TITSPA
    { 'Usuario'																, .T. }, ; //X3_TITENG
    { 'Usuario'																, .T. }, ; //X3_DESCRIC
    { 'Usuario'																, .T. }, ; //X3_DESCSPA
    { 'Usuario'																, .T. }, ; //X3_DESCENG
    { ''																	, .T. }, ; //X3_PICTURE
    { ''																	, .T. }, ; //X3_VALID
    { Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
    { '__cUserId'															, .T. }, ; //X3_RELACAO
    { ''																	, .T. }, ; //X3_F3
    { 0																		, .T. }, ; //X3_NIVEL
    { Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
    { ''																	, .T. }, ; //X3_CHECK
    { ''																	, .T. }, ; //X3_TRIGGER
    { 'U'																	, .T. }, ; //X3_PROPRI
    { 'S'																	, .T. }, ; //X3_BROWSE
    { 'V'																	, .T. }, ; //X3_VISUAL
    { 'R'																	, .T. }, ; //X3_CONTEXT
    { ''																	, .T. }, ; //X3_OBRIGAT
    { ''																	, .T. }, ; //X3_VLDUSER
    { ''																	, .T. }, ; //X3_CBOX
    { ''																	, .T. }, ; //X3_CBOXSPA
    { ''																	, .T. }, ; //X3_CBOXENG
    { ''																	, .T. }, ; //X3_PICTVAR
    { ''																	, .T. }, ; //X3_WHEN
    { ''																	, .T. }, ; //X3_INIBRW
    { ''																	, .T. }, ; //X3_GRPSXG
    { ''																	, .T. }, ; //X3_FOLDER
    { ''																	, .T. }, ; //X3_CONDSQL
    { ''																	, .T. }, ; //X3_CHKSQL
    { ''																	, .T. }, ; //X3_IDXSRV
    { 'N'																	, .T. }, ; //X3_ORTOGRA
    { ''																	, .T. }, ; //X3_TELA
    { ''																	, .T. }, ; //X3_POSLGT
    { 'N'																	, .T. }, ; //X3_IDXFLD
    { ''																	, .T. }, ; //X3_AGRUP
    { ''																	, .T. }, ; //X3_MODAL
    { ''																	, .T. }} ) //X3_PYME

    aAdd( aSX3, { ;
        { 'ZL8'																	, .T. }, ; //X3_ARQUIVO
    { '09'																	, .T. }, ; //X3_ORDEM
    { 'ZL8_DATA'															, .T. }, ; //X3_CAMPO
    { 'D'																	, .T. }, ; //X3_TIPO
    { 8																		, .T. }, ; //X3_TAMANHO
    { 0																		, .T. }, ; //X3_DECIMAL
    { 'Data'																, .T. }, ; //X3_TITULO
    { 'Data'																, .T. }, ; //X3_TITSPA
    { 'Data'																, .T. }, ; //X3_TITENG
    { 'Data'																, .T. }, ; //X3_DESCRIC
    { 'Data'																, .T. }, ; //X3_DESCSPA
    { 'Data'																, .T. }, ; //X3_DESCENG
    { ''																	, .T. }, ; //X3_PICTURE
    { ''																	, .T. }, ; //X3_VALID
    { Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
    { ''																	, .T. }, ; //X3_RELACAO
    { ''																	, .T. }, ; //X3_F3
    { 0																		, .T. }, ; //X3_NIVEL
    { Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
    { ''																	, .T. }, ; //X3_CHECK
    { ''																	, .T. }, ; //X3_TRIGGER
    { 'U'																	, .T. }, ; //X3_PROPRI
    { 'S'																	, .T. }, ; //X3_BROWSE
    { 'V'																	, .T. }, ; //X3_VISUAL
    { 'R'																	, .T. }, ; //X3_CONTEXT
    { ''																	, .T. }, ; //X3_OBRIGAT
    { ''																	, .T. }, ; //X3_VLDUSER
    { ''																	, .T. }, ; //X3_CBOX
    { ''																	, .T. }, ; //X3_CBOXSPA
    { ''																	, .T. }, ; //X3_CBOXENG
    { ''																	, .T. }, ; //X3_PICTVAR
    { ''																	, .T. }, ; //X3_WHEN
    { ''																	, .T. }, ; //X3_INIBRW
    { ''																	, .T. }, ; //X3_GRPSXG
    { ''																	, .T. }, ; //X3_FOLDER
    { ''																	, .T. }, ; //X3_CONDSQL
    { ''																	, .T. }, ; //X3_CHKSQL
    { ''																	, .T. }, ; //X3_IDXSRV
    { 'N'																	, .T. }, ; //X3_ORTOGRA
    { ''																	, .T. }, ; //X3_TELA
    { ''																	, .T. }, ; //X3_POSLGT
    { 'N'																	, .T. }, ; //X3_IDXFLD
    { ''																	, .T. }, ; //X3_AGRUP
    { ''																	, .T. }, ; //X3_MODAL
    { ''																	, .T. }} ) //X3_PYME

    aAdd( aSX3, { ;
        { 'ZL8'																	, .T. }, ; //X3_ARQUIVO
    { '10'																	, .T. }, ; //X3_ORDEM
    { 'ZL8_HORA'															, .T. }, ; //X3_CAMPO
    { 'C'																	, .T. }, ; //X3_TIPO
    { 8																		, .T. }, ; //X3_TAMANHO
    { 0																		, .T. }, ; //X3_DECIMAL
    { 'Hora'																, .T. }, ; //X3_TITULO
    { 'Hora'																, .T. }, ; //X3_TITSPA
    { 'Hora'																, .T. }, ; //X3_TITENG
    { 'Hora'																, .T. }, ; //X3_DESCRIC
    { 'Hora'																, .T. }, ; //X3_DESCSPA
    { 'Hora'																, .T. }, ; //X3_DESCENG
    { '@! 99:99'															, .T. }, ; //X3_PICTURE
    { ''																	, .T. }, ; //X3_VALID
    { Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
    { ''																	, .T. }, ; //X3_RELACAO
    { ''																	, .T. }, ; //X3_F3
    { 0																		, .T. }, ; //X3_NIVEL
    { Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
    { ''																	, .T. }, ; //X3_CHECK
    { ''																	, .T. }, ; //X3_TRIGGER
    { 'U'																	, .T. }, ; //X3_PROPRI
    { 'S'																	, .T. }, ; //X3_BROWSE
    { 'V'																	, .T. }, ; //X3_VISUAL
    { 'R'																	, .T. }, ; //X3_CONTEXT
    { ''																	, .T. }, ; //X3_OBRIGAT
    { ''																	, .T. }, ; //X3_VLDUSER
    { ''																	, .T. }, ; //X3_CBOX
    { ''																	, .T. }, ; //X3_CBOXSPA
    { ''																	, .T. }, ; //X3_CBOXENG
    { ''																	, .T. }, ; //X3_PICTVAR
    { ''																	, .T. }, ; //X3_WHEN
    { ''																	, .T. }, ; //X3_INIBRW
    { ''																	, .T. }, ; //X3_GRPSXG
    { ''																	, .T. }, ; //X3_FOLDER
    { ''																	, .T. }, ; //X3_CONDSQL
    { ''																	, .T. }, ; //X3_CHKSQL
    { ''																	, .T. }, ; //X3_IDXSRV
    { 'N'																	, .T. }, ; //X3_ORTOGRA
    { ''																	, .T. }, ; //X3_TELA
    { ''																	, .T. }, ; //X3_POSLGT
    { 'N'																	, .T. }, ; //X3_IDXFLD
    { ''																	, .T. }, ; //X3_AGRUP
    { ''																	, .T. }, ; //X3_MODAL
    { ''																	, .T. }} ) //X3_PYME

    aAdd( aSX3, { ;
        { 'ZL8'																	, .T. }, ; //X3_ARQUIVO
    { '11'																	, .T. }, ; //X3_ORDEM
    { 'ZL8_STATUS'															, .T. }, ; //X3_CAMPO
    { 'C'																	, .T. }, ; //X3_TIPO
    { 1																		, .T. }, ; //X3_TAMANHO
    { 0																		, .T. }, ; //X3_DECIMAL
    { 'Status'																, .T. }, ; //X3_TITULO
    { 'Status'																, .T. }, ; //X3_TITSPA
    { 'Status'																, .T. }, ; //X3_TITENG
    { 'Status'																, .T. }, ; //X3_DESCRIC
    { 'Status'																, .T. }, ; //X3_DESCSPA
    { 'Status'																, .T. }, ; //X3_DESCENG
    { ''																	, .T. }, ; //X3_PICTURE
    { ''																	, .T. }, ; //X3_VALID
    { Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
    { ''																	, .T. }, ; //X3_RELACAO
    { ''																	, .T. }, ; //X3_F3
    { 0																		, .T. }, ; //X3_NIVEL
    { Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
    { ''																	, .T. }, ; //X3_CHECK
    { ''																	, .T. }, ; //X3_TRIGGER
    { 'U'																	, .T. }, ; //X3_PROPRI
    { 'S'																	, .T. }, ; //X3_BROWSE
    { 'A'																	, .T. }, ; //X3_VISUAL
    { 'R'																	, .T. }, ; //X3_CONTEXT
    { ''																	, .T. }, ; //X3_OBRIGAT
    { ''																	, .T. }, ; //X3_VLDUSER
    { 'A=Aguard. Processamento;P=Processado;B=Bloqueado;E=Erro'				, .T. }, ; //X3_CBOX
    { ''																	, .T. }, ; //X3_CBOXSPA
    { ''																	, .T. }, ; //X3_CBOXENG
    { ''																	, .T. }, ; //X3_PICTVAR
    { ''																	, .T. }, ; //X3_WHEN
    { ''																	, .T. }, ; //X3_INIBRW
    { ''																	, .T. }, ; //X3_GRPSXG
    { ''																	, .T. }, ; //X3_FOLDER
    { ''																	, .T. }, ; //X3_CONDSQL
    { ''																	, .T. }, ; //X3_CHKSQL
    { ''																	, .T. }, ; //X3_IDXSRV
    { 'N'																	, .T. }, ; //X3_ORTOGRA
    { ''																	, .T. }, ; //X3_TELA
    { ''																	, .T. }, ; //X3_POSLGT
    { 'N'																	, .T. }, ; //X3_IDXFLD
    { ''																	, .T. }, ; //X3_AGRUP
    { ''																	, .T. }, ; //X3_MODAL
    { ''																	, .T. }} ) //X3_PYME

    aAdd( aSX3, { ;
        { 'ZL8'																	, .T. }, ; //X3_ARQUIVO
    { '12'																	, .T. }, ; //X3_ORDEM
    { 'ZL8_TPGER'															, .T. }, ; //X3_CAMPO
    { 'C'																	, .T. }, ; //X3_TIPO
    { 1																		, .T. }, ; //X3_TAMANHO
    { 0																		, .T. }, ; //X3_DECIMAL
    { 'Gerado por'															, .T. }, ; //X3_TITULO
    { 'Gerado por'															, .T. }, ; //X3_TITSPA
    { 'Gerado por'															, .T. }, ; //X3_TITENG
    { 'Gerado por'															, .T. }, ; //X3_DESCRIC
    { 'Gerado por'															, .T. }, ; //X3_DESCSPA
    { 'Gerado por'															, .T. }, ; //X3_DESCENG
    { ''																	, .T. }, ; //X3_PICTURE
    { ''																	, .T. }, ; //X3_VALID
    { Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
        Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
    { 'U'																	, .T. }, ; //X3_RELACAO
    { ''																	, .T. }, ; //X3_F3
    { 0																		, .T. }, ; //X3_NIVEL
    { Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
    { ''																	, .T. }, ; //X3_CHECK
    { ''																	, .T. }, ; //X3_TRIGGER
    { 'U'																	, .T. }, ; //X3_PROPRI
    { 'S'																	, .T. }, ; //X3_BROWSE
    { 'V'																	, .T. }, ; //X3_VISUAL
    { 'R'																	, .T. }, ; //X3_CONTEXT
    { ''																	, .T. }, ; //X3_OBRIGAT
    { ''																	, .T. }, ; //X3_VLDUSER
    { 'J=Job;U=User'                                     					, .T. }, ; //X3_CBOX
    { ''																	, .T. }, ; //X3_CBOXSPA
    { ''																	, .T. }, ; //X3_CBOXENG
    { ''																	, .T. }, ; //X3_PICTVAR
    { ''																	, .T. }, ; //X3_WHEN
    { ''																	, .T. }, ; //X3_INIBRW
    { ''																	, .T. }, ; //X3_GRPSXG
    { ''																	, .T. }, ; //X3_FOLDER
    { ''																	, .T. }, ; //X3_CONDSQL
    { ''																	, .T. }, ; //X3_CHKSQL
    { ''																	, .T. }, ; //X3_IDXSRV
    { 'N'																	, .T. }, ; //X3_ORTOGRA
    { ''																	, .T. }, ; //X3_TELA
    { ''																	, .T. }, ; //X3_POSLGT
    { 'N'																	, .T. }, ; //X3_IDXFLD
    { ''																	, .T. }, ; //X3_AGRUP
    { ''																	, .T. }, ; //X3_MODAL
    { ''																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'ZL8'																	, .T. }, ; //X3_ARQUIVO
	{ '13'																	, .T. }, ; //X3_ORDEM
	{ 'ZL8_LOG'		    													, .T. }, ; //X3_CAMPO
	{ 'M'																	, .T. }, ; //X3_TIPO
	{ 10																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Log'															, .T. }, ; //X3_TITULO
	{ 'Log'															, .T. }, ; //X3_TITSPA
	{ 'Log'															, .T. }, ; //X3_TITENG
	{ 'Log'															, .T. }, ; //X3_DESCRIC
	{ 'Log'															, .T. }, ; //X3_DESCSPA
	{ 'Log'															, .T. }, ; //X3_DESCENG
	{ ''																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 0																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'U'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ ''																	, .T. }, ; //X3_MODAL
	{ ''																	, .T. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'ZL8'																	, .T. }, ; //X3_ARQUIVO
	{ '14'																	, .T. }, ; //X3_ORDEM
	{ 'ZL8_LOGSBF'		    													, .T. }, ; //X3_CAMPO
	{ 'M'																	, .T. }, ; //X3_TIPO
	{ 10																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Log SBF'															, .T. }, ; //X3_TITULO
	{ 'Log SBF'															, .T. }, ; //X3_TITSPA
	{ 'Log SBF'															, .T. }, ; //X3_TITENG
	{ 'Log SBF'															, .T. }, ; //X3_DESCRIC
	{ 'Log SBF'															, .T. }, ; //X3_DESCSPA
	{ 'Log SBF'															, .T. }, ; //X3_DESCENG
	{ ''																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 0																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'U'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ ''																	, .T. }, ; //X3_MODAL
	{ ''																	, .T. }} ) //X3_PYME

    aAdd( aSX3, { ;
	{ 'ZL8'																	, .T. }, ; //X3_ARQUIVO
	{ '15'																	, .T. }, ; //X3_ORDEM
	{ 'ZL8_LOGSC0'		    													, .T. }, ; //X3_CAMPO
	{ 'M'																	, .T. }, ; //X3_TIPO
	{ 10																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Log SC0'															, .T. }, ; //X3_TITULO
	{ 'Log SC0'															, .T. }, ; //X3_TITSPA
	{ 'Log SC0'															, .T. }, ; //X3_TITENG
	{ 'Log SC0'															, .T. }, ; //X3_DESCRIC
	{ 'Log SC0'															, .T. }, ; //X3_DESCSPA
	{ 'Log SC0'															, .T. }, ; //X3_DESCENG
	{ ''																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 0																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'U'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ ''																	, .T. }, ; //X3_MODAL
	{ ''																	, .T. }} ) //X3_PYME

    aAdd( aSX3, { ;
	{ 'ZL8'																	, .T. }, ; //X3_ARQUIVO
	{ '16'																	, .T. }, ; //X3_ORDEM
	{ 'ZL8_LOGSC9'		    													, .T. }, ; //X3_CAMPO
	{ 'M'																	, .T. }, ; //X3_TIPO
	{ 10																	, .T. }, ; //X3_TAMANHO
	{ 0																		, .T. }, ; //X3_DECIMAL
	{ 'Log SC9'															, .T. }, ; //X3_TITULO
	{ 'Log SC9'															, .T. }, ; //X3_TITSPA
	{ 'Log SC9'															, .T. }, ; //X3_TITENG
	{ 'Log SC9'															, .T. }, ; //X3_DESCRIC
	{ 'Log SC9'															, .T. }, ; //X3_DESCSPA
	{ 'Log SC9'															, .T. }, ; //X3_DESCENG
	{ ''																	, .T. }, ; //X3_PICTURE
	{ ''																	, .T. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .T. }, ; //X3_USADO
	{ ''																	, .T. }, ; //X3_RELACAO
	{ ''																	, .T. }, ; //X3_F3
	{ 0																		, .T. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .T. }, ; //X3_RESERV
	{ ''																	, .T. }, ; //X3_CHECK
	{ ''																	, .T. }, ; //X3_TRIGGER
	{ 'U'																	, .T. }, ; //X3_PROPRI
	{ 'S'																	, .T. }, ; //X3_BROWSE
	{ 'V'																	, .T. }, ; //X3_VISUAL
	{ 'R'																	, .T. }, ; //X3_CONTEXT
	{ ''																	, .T. }, ; //X3_OBRIGAT
	{ ''																	, .T. }, ; //X3_VLDUSER
	{ ''																	, .T. }, ; //X3_CBOX
	{ ''																	, .T. }, ; //X3_CBOXSPA
	{ ''																	, .T. }, ; //X3_CBOXENG
	{ ''																	, .T. }, ; //X3_PICTVAR
	{ ''																	, .T. }, ; //X3_WHEN
	{ ''																	, .T. }, ; //X3_INIBRW
	{ ''																	, .T. }, ; //X3_GRPSXG
	{ ''																	, .T. }, ; //X3_FOLDER
	{ ''																	, .T. }, ; //X3_CONDSQL
	{ ''																	, .T. }, ; //X3_CHKSQL
	{ ''																	, .T. }, ; //X3_IDXSRV
	{ 'N'																	, .T. }, ; //X3_ORTOGRA
	{ ''																	, .T. }, ; //X3_TELA
	{ ''																	, .T. }, ; //X3_POSLGT
	{ 'N'																	, .T. }, ; //X3_IDXFLD
	{ ''																	, .T. }, ; //X3_AGRUP
	{ ''																	, .T. }, ; //X3_MODAL
	{ ''																	, .T. }} ) //X3_PYME

//
// Atualizando dicion�rio
//
    nPosArq := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ARQUIVO" } )
    nPosOrd := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ORDEM"   } )
    nPosCpo := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_CAMPO"   } )
    nPosTam := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_TAMANHO" } )
    nPosSXG := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_GRPSXG"  } )
    nPosVld := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_VALID"   } )

    aSort( aSX3,,, { |x,y| x[nPosArq][1]+x[nPosOrd][1]+x[nPosCpo][1] < y[nPosArq][1]+y[nPosOrd][1]+y[nPosCpo][1] } )

    oProcess:SetRegua2( Len( aSX3 ) )

    dbSelectArea( "SX3" )
    dbSetOrder( 2 )
    cAliasAtu := ""

    For nI := 1 To Len( aSX3 )

        //
        // Verifica se o campo faz parte de um grupo e ajusta tamanho
        //
        If !Empty( aSX3[nI][nPosSXG][1] )
            SXG->( dbSetOrder( 1 ) )
            If SXG->( MSSeek( aSX3[nI][nPosSXG][1] ) )
                If aSX3[nI][nPosTam][1] <> SXG->XG_SIZE
                    aSX3[nI][nPosTam][1] := SXG->XG_SIZE
                    AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " N�O atualizado e foi mantido em [" + ;
                        AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
                        " por pertencer ao grupo de campos [" + SXG->XG_GRUPO + "]" + CRLF )
                EndIf
            EndIf
        EndIf

        SX3->( dbSetOrder( 2 ) )

        If !( aSX3[nI][nPosArq][1] $ cAlias )
            cAlias += aSX3[nI][nPosArq][1] + "/"
            aAdd( aArqUpd, aSX3[nI][nPosArq][1] )
        EndIf

        If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo][1], nTamSeek ) ) )

            //
            // Busca ultima ocorrencia do alias
            //
            If ( aSX3[nI][nPosArq][1] <> cAliasAtu )
                cSeqAtu   := "00"
                cAliasAtu := aSX3[nI][nPosArq][1]

                dbSetOrder( 1 )
                SX3->( dbSeek( cAliasAtu + "ZZ", .T. ) )
                dbSkip( -1 )

                If ( SX3->X3_ARQUIVO == cAliasAtu )
                    cSeqAtu := SX3->X3_ORDEM
                EndIf

                nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
            EndIf

            nSeqAtu++
            cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )

            RecLock( "SX3", .T. )
            For nJ := 1 To Len( aSX3[nI] )
                //comente o If abaixo para obedecer a ordem do SX3 que estiver no compatibiliador (X3_ORDEM)
			/*
                If     nJ == nPosOrd  // Ordem
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), cSeqAtu ) )

                Else
			*/
                    If aEstrut[nJ][2] > 0
                        SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ][1] ) )

                    EndIf
                Next nJ

                dbCommit()
                MsUnLock()

                AutoGrLog( "Criado campo " + aSX3[nI][nPosCpo][1] )

            Else

                //
                // Verifica se o campo faz parte de um grupo e ajsuta tamanho
                //
                If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG][1]
                    SXG->( dbSetOrder( 1 ) )
                    If SXG->( MSSeek( SX3->X3_GRPSXG ) )
                        If aSX3[nI][nPosTam][1] <> SXG->XG_SIZE
                            aSX3[nI][nPosTam][1] := SXG->XG_SIZE
                            AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " N�O atualizado e foi mantido em [" + ;
                                AllTrim( Str( SXG->XG_SIZE ) ) + "]"+ CRLF + ;
                                "   por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF )
                        EndIf
                    EndIf
                EndIf

                //
                // Verifica todos os campos
                //
                For nJ := 1 To Len( aSX3[nI] )

                    //
                    // Se o campo estiver diferente da estrutura
                    //
                    If aSX3[nI][nJ][2]
                        cX3Campo := AllTrim( aEstrut[nJ][1] )
                        cX3Dado  := SX3->( FieldGet( aEstrut[nJ][2] ) )

                        If  aEstrut[nJ][2] > 0 .AND. ;
                                PadR( StrTran( AllToChar( cX3Dado ), " ", "" ), 250 ) <> ;
                                PadR( StrTran( AllToChar( aSX3[nI][nJ][1] ), " ", "" ), 250 ) ;
                                .AND. !cX3Campo == "X3_ORDEM"

                            cMsg := "O campo " + aSX3[nI][nPosCpo][1] + " est� com o " + cX3Campo + ;
                                " com o conte�do" + CRLF + ;
                                "[" + RTrim( AllToChar( cX3Dado ) ) + "]" + CRLF + ;
                                "que ser� substitu�do pelo NOVO conte�do" + CRLF + ;
                                "[" + RTrim( AllToChar( aSX3[nI][nJ][1] ) ) + "]" + CRLF + ;
                                "Deseja substituir ? "

                            If      lTodosSim
                                nOpcA := 1
                            ElseIf  lTodosNao
                                nOpcA := 2
                            Else
                                nOpcA := Aviso( "ATUALIZA��O DE DICION�RIOS E TABELAS", cMsg, { "Sim", "N�o", "Sim p/Todos", "N�o p/Todos" }, 3, "Diferen�a de conte�do - SX3" )
                                lTodosSim := ( nOpcA == 3 )
                                lTodosNao := ( nOpcA == 4 )

                                If lTodosSim
                                    nOpcA := 1
                                    lTodosSim := MsgNoYes( "Foi selecionada a op��o de REALIZAR TODAS altera��es no SX3 e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma a a��o [Sim p/Todos] ?" )
                                EndIf

                                If lTodosNao
                                    nOpcA := 2
                                    lTodosNao := MsgNoYes( "Foi selecionada a op��o de N�O REALIZAR nenhuma altera��o no SX3 que esteja diferente da base e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta a��o [N�o p/Todos]?" )
                                EndIf

                            EndIf

                            If nOpcA == 1
                                AutoGrLog( "Alterado campo " + aSX3[nI][nPosCpo][1] + CRLF + ;
                                    "   " + PadR( cX3Campo, 10 ) + " de [" + AllToChar( cX3Dado ) + "]" + CRLF + ;
                                    "            para [" + AllToChar( aSX3[nI][nJ][1] )           + "]" + CRLF )

                                RecLock( "SX3", .F. )
                                FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ][1] )
                                MsUnLock()
                            EndIf

                        EndIf

                    EndIf

                Next

            EndIf

            oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

        Next nI

        AutoGrLog( CRLF + "Final da Atualiza��o" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )

        Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSIX
Fun��o de processamento da grava��o do SIX - Indices

@author TOTVS Protheus
@since  04/10/2018
@obs    Gerado por EXPORDIC - V.6.0.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSIX()
    Local aEstrut   := {}
    Local aSIX      := {}
    Local lAlt      := .F.
    Local lDelInd   := .F.
    Local nI        := 0
    Local nJ        := 0

    AutoGrLog( "�nicio da Atualiza��o" + " SIX" + CRLF )

    aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
        "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

    //
    // Tabela ZL8
    //
    aAdd( aSIX, { ;
    'ZL8'																	, ; //INDICE
    '1'																		, ; //ORDEM
    'ZL8_FILIAL+ZL8_CODEMP+ZL8_CODFIL+ZL8_ETIQUE'							, ; //CHAVE
    'Empresa/Filial+Etiqueta'												, ; //DESCRICAO
    'Empresa/Filial+Etiqueta'												, ; //DESCSPA
    'Empresa/Filial+Etiqueta'												, ; //DESCENG
    'U'																		, ; //PROPRI
    ''																		, ; //F3
    ''																		, ; //NICKNAME
    'S'																		} ) //SHOWPESQ

    //
    // Atualizando dicion�rio
    //
    oProcess:SetRegua2( Len( aSIX ) )

    dbSelectArea( "SIX" )
    SIX->( dbSetOrder( 1 ) )

    For nI := 1 To Len( aSIX )

        lAlt    := .F.
        lDelInd := .F.

        If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
            AutoGrLog( "�ndice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
        Else
            lAlt := .T.
            aAdd( aArqUpd, aSIX[nI][1] )
            If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "" ) == ;
                    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
                AutoGrLog( "Chave do �ndice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
                lDelInd := .T. // Se for altera��o precisa apagar o indice do banco
            EndIf
        EndIf

        RecLock( "SIX", !lAlt )
        For nJ := 1 To Len( aSIX[nI] )
            If FieldPos( aEstrut[nJ] ) > 0
                FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
            EndIf
        Next nJ
        MsUnLock()

        dbCommit()

        If lDelInd
            TcInternal( 60, RetSqlName( aSIX[nI][1] ) + "|" + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] )
        EndIf

        oProcess:IncRegua2( "Atualizando �ndices..." )

    Next nI

    AutoGrLog( CRLF + "Final da Atualiza��o" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX7
Fun��o de processamento da grava��o do SX7 - Gatilhos

@author TOTVS Protheus
@since  03/07/14
@obs    Gerado por EXPORDIC - V.4.19.9.3 EFS / Upd. V.4.18.9 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX7( cTexto )
    Local aEstrut   := {}
    Local aAreaSX3  := SX3->( GetArea() )
    Local aSX7      := {}
    Local cAlias    := ""
    Local nI        := 0
    Local nJ        := 0
    Local nTamSeek  := Len( SX7->X7_CAMPO )

    cTexto  += "�nicio da Atualiza��o" + " SX7" + CRLF + CRLF

    aEstrut := { "X7_CAMPO", "X7_SEQUENC", "X7_REGRA", "X7_CDOMIN", "X7_TIPO", "X7_SEEK", ;
        "X7_ALIAS", "X7_ORDEM"  , "X7_CHAVE", "X7_PROPRI", "X7_CONDIC" }

//
// Campo ZL8_CODREG
//
/*
aAdd( aSX7, { ;
	'ZL8_CODREG'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'Posicione("ZL8",1,xFilial("ZL8")+FwFldGet("ZL8_CODREG"),"ZL8_DESCRI")'	, ; //X7_REGRA
	'ZL8_DESCRE'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	''																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC
*/
//
// Atualizando dicion�rio
//
    oProcess:SetRegua2( Len( aSX7 ) )

    dbSelectArea( "SX3" )
    dbSetOrder( 2 )

    dbSelectArea( "SX7" )
    dbSetOrder( 1 )

    For nI := 1 To Len( aSX7 )

        If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )

            If !( aSX7[nI][1] $ cAlias )
                cAlias += aSX7[nI][1] + "/"
                AutoGrLog( "Foi inclu�do o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] )
            EndIf

            RecLock( "SX7", .T. )
        Else

            If !( aSX7[nI][1] $ cAlias )
                cAlias += aSX7[nI][1] + "/"
                AutoGrLog( "Foi alterado o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] )
            EndIf

            RecLock( "SX7", .F. )
        EndIf

        For nJ := 1 To Len( aSX7[nI] )
            If FieldPos( aEstrut[nJ] ) > 0
                FieldPut( FieldPos( aEstrut[nJ] ), aSX7[nI][nJ] )
            EndIf
        Next nJ

        dbCommit()
        MsUnLock()

        If SX3->( dbSeek( SX7->X7_CAMPO ) )
            RecLock( "SX3", .F. )
            SX3->X3_TRIGGER := "S"
            MsUnLock()
        EndIf

        oProcess:IncRegua2( "Atualizando Arquivos (SX7)..." )

    Next nI

    RestArea( aAreaSX3 )

    AutoGrLog( CRLF + "Final da Atualiza��o" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL

//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSXB
Fun��o de processamento da grava��o do SXB - Consultas Padrao

@author TOTVS Protheus
@since  04/10/2018
@obs    Gerado por EXPORDIC - V.6.0.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSXB()
    Local aEstrut   := {}
    Local aSXB      := {}
    Local cAlias    := ""
    Local cMsg      := ""
    Local lTodosNao := .F.
    Local lTodosSim := .F.
    Local nI        := 0
    Local nJ        := 0
    Local nOpcA     := 0

    AutoGrLog( "�nicio da Atualiza��o" + " SXB" + CRLF )

    aEstrut := { "XB_ALIAS"  , "XB_TIPO"   , "XB_SEQ"    , "XB_COLUNA" , "XB_DESCRI" , "XB_DESCSPA", "XB_DESCENG", ;
        "XB_WCONTEM", "XB_CONTEM" }

//
// Consulta ZL8GRU
//


//
// Atualizando dicion�rio
//
    oProcess:SetRegua2( Len( aSXB ) )

    dbSelectArea( "SXB" )
    dbSetOrder( 1 )

    For nI := 1 To Len( aSXB )

        If !Empty( aSXB[nI][1] )

            If !SXB->( dbSeek( PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )

                If !( aSXB[nI][1] $ cAlias )
                    cAlias += aSXB[nI][1] + "/"
                    AutoGrLog( "Foi inclu�da a consulta padr�o " + aSXB[nI][1] )
                EndIf

                RecLock( "SXB", .T. )

                For nJ := 1 To Len( aSXB[nI] )
                    If FieldPos( aEstrut[nJ] ) > 0
                        FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
                    EndIf
                Next nJ

                dbCommit()
                MsUnLock()

            Else

                //
                // Verifica todos os campos
                //
                For nJ := 1 To Len( aSXB[nI] )

                    //
                    // Se o campo estiver diferente da estrutura
                    //
                    If aEstrut[nJ] == SXB->( FieldName( nJ ) ) .AND. ;
                            !StrTran( AllToChar( SXB->( FieldGet( nJ ) ) ), " ", "" ) == ;
                            StrTran( AllToChar( aSXB[nI][nJ]            ), " ", "" )

                        cMsg := "A consulta padr�o " + aSXB[nI][1] + " est� com o " + SXB->( FieldName( nJ ) ) + ;
                            " com o conte�do" + CRLF + ;
                            "[" + RTrim( AllToChar( SXB->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
                            ", e este � diferente do conte�do" + CRLF + ;
                            "[" + RTrim( AllToChar( aSXB[nI][nJ] ) ) + "]" + CRLF +;
                            "Deseja substituir ? "

                        If      lTodosSim
                            nOpcA := 1
                        ElseIf  lTodosNao
                            nOpcA := 2
                        Else
                            nOpcA := Aviso( "ATUALIZA��O DE DICION�RIOS E TABELAS", cMsg, { "Sim", "N�o", "Sim p/Todos", "N�o p/Todos" }, 3, "Diferen�a de conte�do - SXB" )
                            lTodosSim := ( nOpcA == 3 )
                            lTodosNao := ( nOpcA == 4 )

                            If lTodosSim
                                nOpcA := 1
                                lTodosSim := MsgNoYes( "Foi selecionada a op��o de REALIZAR TODAS altera��es no SXB e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma a a��o [Sim p/Todos] ?" )
                            EndIf

                            If lTodosNao
                                nOpcA := 2
                                lTodosNao := MsgNoYes( "Foi selecionada a op��o de N�O REALIZAR nenhuma altera��o no SXB que esteja diferente da base e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta a��o [N�o p/Todos]?" )
                            EndIf

                        EndIf

                        If nOpcA == 1
                            RecLock( "SXB", .F. )
                            FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
                            dbCommit()
                            MsUnLock()

                            If !( aSXB[nI][1] $ cAlias )
                                cAlias += aSXB[nI][1] + "/"
                                AutoGrLog( "Foi alterada a consulta padr�o " + aSXB[nI][1] )
                            EndIf

                        EndIf

                    EndIf

                Next

            EndIf

        EndIf

        oProcess:IncRegua2( "Atualizando Consultas Padr�es (SXB)..." )

    Next nI

    AutoGrLog( CRLF + "Final da Atualiza��o" + " SXB" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} EscEmpresa
Fun��o gen�rica para escolha de Empresa, montada pelo SM0

@return aRet Vetor contendo as sele��es feitas.
             Se n�o for marcada nenhuma o vetor volta vazio

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function EscEmpresa()

//---------------------------------------------
// Par�metro  nTipo
// 1 - Monta com Todas Empresas/Filiais
// 2 - Monta s� com Empresas
// 3 - Monta s� com Filiais de uma Empresa
//
// Par�metro  aMarcadas
// Vetor com Empresas/Filiais pr� marcadas
//
// Par�metro  cEmpSel
// Empresa que ser� usada para montar sele��o
//---------------------------------------------
    Local   aRet      := {}
    Local   aSalvAmb  := GetArea()
    Local   aSalvSM0  := {}
    Local   aVetor    := {}
    Local   cMascEmp  := "??"
    Local   cVar      := ""
    Local   lChk      := .F.
    Local   lOk       := .F.
    Local   lTeveMarc := .F.
    Local   oNo       := LoadBitmap( GetResources(), "LBNO" )
    Local   oOk       := LoadBitmap( GetResources(), "LBOK" )
    Local   oDlg, oChkMar, oLbx, oMascEmp, oSay
    Local   oButDMar, oButInv, oButMarc, oButOk, oButCanc

    Local   aMarcadas := {}


    If !MyOpenSm0(.F.)
        Return aRet
    EndIf


    dbSelectArea( "SM0" )
    aSalvSM0 := SM0->( GetArea() )
    dbSetOrder( 1 )
    dbGoTop()

    While !SM0->( EOF() )

        If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
            aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
        EndIf

        dbSkip()
    End

    RestArea( aSalvSM0 )

    Define MSDialog  oDlg Title "" From 0, 0 To 280, 395 Pixel

    oDlg:cToolTip := "Tela para M�ltiplas Sele��es de Empresas/Filiais"

    oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualiza��o"

    @ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", "Empresa" Size 178, 095 Of oDlg Pixel
    oLbx:SetArray(  aVetor )
    oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
        aVetor[oLbx:nAt, 2], ;
        aVetor[oLbx:nAt, 4]}}
    oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
    oLbx:cToolTip   :=  oDlg:cTitle
    oLbx:lHScroll   := .F. // NoScroll

    @ 112, 10 CheckBox oChkMar Var  lChk Prompt "Todos" Message "Marca / Desmarca"+ CRLF + "Todos" Size 40, 007 Pixel Of oDlg;
        on Click MarcaTodos( lChk, @aVetor, oLbx )

// Marca/Desmarca por mascara
    @ 113, 51 Say   oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
    @ 112, 80 MSGet oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
        Message "M�scara Empresa ( ?? )"  Of oDlg
    oSay:cToolTip := oMascEmp:cToolTip

    @ 128, 10 Button oButInv    Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
        Message "Inverter Sele��o" Of oDlg
    oButInv:SetCss( CSSBOTAO )
    @ 128, 50 Button oButMarc   Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
        Message "Marcar usando" + CRLF + "m�scara ( ?? )"    Of oDlg
    oButMarc:SetCss( CSSBOTAO )
    @ 128, 80 Button oButDMar   Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
        Message "Desmarcar usando" + CRLF + "m�scara ( ?? )" Of oDlg
    oButDMar:SetCss( CSSBOTAO )
    @ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDZL8" ) ) ) ;
        Message "Confirma a sele��o e efetua" + CRLF + "o processamento" Of oDlg
    oButOk:SetCss( CSSBOTAO )
    @ 128, 157  Button oButCanc Prompt "Cancelar"   Size 32, 12 Pixel Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) ;
        Message "Cancela o processamento" + CRLF + "e abandona a aplica��o" Of oDlg
    oButCanc:SetCss( CSSBOTAO )

    Activate MSDialog  oDlg Center

    RestArea( aSalvAmb )
    dbSelectArea( "SM0" )
    dbCloseArea()

Return  aRet


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaTodos
Fun��o auxiliar para marcar/desmarcar todos os �tens do ListBox ativo

@param lMarca  Cont�udo para marca .T./.F.
@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaTodos( lMarca, aVetor, oLbx )
    Local  nI := 0

    For nI := 1 To Len( aVetor )
        aVetor[nI][1] := lMarca
    Next nI

    oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} InvSelecao
Fun��o auxiliar para inverter a sele��o do ListBox ativo

@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function InvSelecao( aVetor, oLbx )
    Local  nI := 0

    For nI := 1 To Len( aVetor )
        aVetor[nI][1] := !aVetor[nI][1]
    Next nI

    oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} RetSelecao
Fun��o auxiliar que monta o retorno com as sele��es

@param aRet    Array que ter� o retorno das sele��es (� alterado internamente)
@param aVetor  Vetor do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function RetSelecao( aRet, aVetor )
    Local  nI    := 0

    aRet := {}
    For nI := 1 To Len( aVetor )
        If aVetor[nI][1]
            aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
        EndIf
    Next nI

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaMas
Fun��o para marcar/desmarcar usando m�scaras

@param oLbx     Objeto do ListBox
@param aVetor   Vetor do ListBox
@param cMascEmp Campo com a m�scara (???)
@param lMarDes  Marca a ser atribu�da .T./.F.

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
    Local cPos1 := SubStr( cMascEmp, 1, 1 )
    Local cPos2 := SubStr( cMascEmp, 2, 1 )
    Local nPos  := oLbx:nAt
    Local nZ    := 0

    For nZ := 1 To Len( aVetor )
        If cPos1 == "?" .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
            If cPos2 == "?" .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
                aVetor[nZ][1] := lMarDes
            EndIf
        EndIf
    Next

    oLbx:nAt := nPos
    oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} VerTodos
Fun��o auxiliar para verificar se est�o todos marcados ou n�o

@param aVetor   Vetor do ListBox
@param lChk     Marca do CheckBox do marca todos (referncia)
@param oChkMar  Objeto de CheckBox do marca todos

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function VerTodos( aVetor, lChk, oChkMar )
    Local lTTrue := .T.
    Local nI     := 0

    For nI := 1 To Len( aVetor )
        lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
    Next nI

    lChk := IIf( lTTrue, .T., .F. )
    oChkMar:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MyOpenSM0
Fun��o de processamento abertura do SM0 modo exclusivo

@author TOTVS Protheus
@since  04/10/2018
@obs    Gerado por EXPORDIC - V.6.0.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MyOpenSM0(lShared)
    Local lOpen := .F.
    Local nLoop := 0

    lShared := .T. // descomente para rodar em modo compartilhado

    If FindFunction( "_OpenSM0Excl" )
        For nLoop := 1 To 20
            If OpenSM0Excl(,lShared)
                lOpen := .T.
                Exit
            EndIf
            Sleep( 500 )
        Next nLoop
    Else
        For nLoop := 1 To 20
            dbUseArea( .T., , "SIGAMAT.EMP", "SM0", lShared, .F. )

            If !Empty( Select( "SM0" ) )
                lOpen := .T.
                dbSetIndex( "SIGAMAT.IND" )
                Exit
            EndIf
            Sleep( 500 )
        Next nLoop
    EndIf

    If !lOpen
        MsgStop( "N�o foi poss�vel a abertura da tabela " + ;
            IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATEN��O" )
    EndIf

Return lOpen


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Fun��o de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  04/10/2018
@obs    Gerado por EXPORDIC - V.6.0.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function LeLog()
    Local cRet  := ""
    Local cFile := NomeAutoLog()
    Local cAux  := ""

    FT_FUSE( cFile )
    FT_FGOTOP()

    While !FT_FEOF()

        cAux := FT_FREADLN()

        If Len( cRet ) + Len( cAux ) < 1048000
            cRet += cAux + CRLF
        Else
            cRet += CRLF
            cRet += Replicate( "=" , 128 ) + CRLF
            cRet += "Tamanho de exibi��o maxima do LOG alcan�ado." + CRLF
            cRet += "LOG Completo no arquivo " + cFile + CRLF
            cRet += Replicate( "=" , 128 ) + CRLF
            Exit
        EndIf

        FT_FSKIP()
    End

    FT_FUSE()

Return cRet
