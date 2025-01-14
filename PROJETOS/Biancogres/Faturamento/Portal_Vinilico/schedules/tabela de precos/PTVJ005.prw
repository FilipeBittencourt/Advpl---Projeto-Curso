#include 'totvs.ch'
#include 'fileio.ch'


/*/{Protheus.doc} PTVJ005
Job respons�vel por sincronizar os pre�os de venda
@type function
@version 1.0
@author Pontin - Facile Sistemas
@since 04/09/2020
/*/
User Function PTVJ005(xParam1, xParam2)

  Local aFiliais      := {}
  Local lTudoOk       := .F.
  Local nI            := 0
  Local cCgcProc      := ""
  Local cEmpX         := ""
  Local cFilX         := ""
  Local cLockName     := ""
  Local oFilial       := JsonObject():New()

  Private oSchd       := PTVinilicoSchedule():New()

  Default xParam1     := { "01", "01" }

  If ValType(xParam1) == "A"
    cEmpX		:= xParam1[1]
    cFilX		:= xParam1[2]
  ElseIf ValType(xParam1) == "C"
    cEmpX		:= xParam1
    cFilX		:= xParam2
  Else
    ConOut('## ERROR PTVJ005 - N�O FOI INFORMADO EMPRESA E FILIAL ##')
    ConOut('## ERROR PTVJ005 - FIM DO JOB ##')
    Return
  EndIf

  //|Abre o ambiente |
  oSchd:cEmpExec    := cEmpX
  oSchd:cFilExec    := cFilX
  lTudoOk := oSchd:PrepareEnv()

  If !lTudoOk
    oSchd:Comunica(cEmpX + cFilX + "ERRO: FALHA AO INICIALIZAR O AMBIENTE PROTHEUS")
    Return
  EndIf

  //|Permite apenas um processamento por vez |
  cLockName   := "PTVJ005" + cEmpAnt + cFilAnt

  If !oSchd:BeginMutex( cLockName )

    oSchd:Comunica( " [PTVJ005" + cEmpAnt + cFilAnt + "] Processamento ja iniciado por outra rotina!" )
    RpcClearEnv()
    Return

  EndIf

  //|Inicializa log do processo |
  oSchd:cFileLog    := cEmpX + cFilX + "-PTVJ005-" + FwTimeStamp() + ".log"
  lTudoOk := oSchd:BeginLog()

  If !lTudoOk

    oSchd:Comunica(cEmpX + cFilX + " ERRO: FALHA AO INICIALIZAR O ARQUIVO DE LOG")
    RpcClearEnv()
    Return

  EndIf

  oSchd:LogMessage( "--------- INICIO DA EXECUCAO DO JOB -------------"  + CRLF )

  //|Busca as filiais da empresa |
  aFiliais  := oSchd:GetFiliais()

  oFilial   := aFiliais[1]
  cCgcProc  := SubStr( oFilial["M0_CGC"], 1, 8 )

  //|########################################### |
  //|####### PROCESSA FILIAL POR FILIAL  ####### |
  //|########################################### |
  For nI := 1 To Len( aFiliais )

    oFilial   := aFiliais[nI]

    //|Nesse momento s� processa a filial 01 |
    If oFilial["M0_CODFIL"] != "01"
      Exit
    EndIf

    If cCgcProc != SubStr( oFilial["M0_CGC"], 1, 8 )
      oSchd:LogMessage( "ERRO: EMPRESA NAO FAZ PARTE DO CNPJ A SER PROCESSADO: " + oFilial["M0_CGC"]  + CRLF )
      Loop
    EndIf

    //|Inicializa o ambiente da filial ser executada |
    oSchd:cFilExec    := oFilial["M0_CODFIL"]
    lTudoOk := oSchd:PrepareEnv()

    If !lTudoOk
      oSchd:LogMessage( "ERRO: FALHA AO INICIALIZAR O AMBIENTE PROTHEUS"  + CRLF )
      Loop
    EndIf

    //|SINCRONIZA O PRE�O COM O PORTAL |
    U_PTVPRC01(@oSchd)

  Next nI

  oSchd:LogMessage( "--------- FINAL DA EXECUCAO DO JOB -------------"  + CRLF )
  oSchd:EndLog()

  oSchd:EndMutex( cLockName )

  //|Finaliza o ambiente |
  If Select("SX6") > 0
    RpcClearEnv()
  EndIf

  aFiliais  := aSize(aFiliais, 0)
  aFiliais  := Nil

  FreeObj(oSchd)
  FreeObj(oFilial)

Return

