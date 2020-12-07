#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} BIAF167
@author Filipe Bittencourt
@since 02/09/2018
@project Automacao Financeira
@version 1.0
@description Processa os titulos a receber do banco do brasil para n�o gerar diariamente
@type function
/*/

User Function BIAF167()


  Local cSQL      := ""
  Local cQry      := GetNextAlias()
  Local cQryii    := GetNextAlias()
  Local nSoma     := 0
  Local aFINA100  := {}
  Local cError    := ""
  Local oError    := ErrorBlock({|e| cError := e:Description})
  Local cTime     := ""

  Private lMsErroAuto    := .F.

  if UDiaUtil() //Pegando e comparando ultimo dia util do mes

    // PEGANDO TODAS AS CONTAS DO BANCO DO BRASIL PARA EXECUTAR EM QUAIS DELEAS POSSUI TARIFAS
    cSQL := "SELECT DISTINCT  ZK4_BANCO,  ZK4_AGENCI, ZK4_CONTA  " + CRLF
    cSQL += " FROM " + RetSQLName("ZK4") + CRLF
    cSQL += " WHERE ZK4_FILIAL = '  '
    cSQL += " AND ZK4_EMP = " + ValToSQL(cEmpAnt) + CRLF
    cSQL += " AND ZK4_FIL     = " + ValToSQL(cFilAnt) + CRLF
    cSQL += " and ZK4_BANCO = '001' "+ CRLF
    cSQL += " and D_E_L_E_T_ = '' "+ CRLF
    cSQL += " ORDER BY  ZK4_BANCO,  ZK4_AGENCI, ZK4_CONTA "+ CRLF

    TcQuery cSQL New Alias (cQryii)

    While !(cQryii)->(Eof())

      cSQL := " SELECT  ZK4_VLTAR , ZK4_BANCO,  ZK4_AGENCI, ZK4_CONTA, R_E_C_N_O_  as RECNO" + CRLF
      cSQL += " FROM " + RetSQLName("ZK4") + CRLF
      cSQL += " WHERE ZK4_FILIAL = " + ValToSQL(xFilial("ZK4")) + CRLF
      cSQL += " AND ZK4_EMP = " + ValToSQL(cEmpAnt) + CRLF
      cSQL += " AND ZK4_FIL     = " + ValToSQL(cFilAnt) + CRLF
      cSQL += " AND ZK4_TIPO    = 'R' " + CRLF
      cSQL += " AND ZK4_STATUS  = '1' " + CRLF // Integrado + CRLF
      cSQL += " AND D_E_L_E_T_  = ''	"
      cSQL += " AND ZK4_BANCO   =  " + ValToSQL((cQryii)->ZK4_BANCO) +  CRLF
      cSQL += " AND ZK4_AGENCI  =  " + ValToSQL((cQryii)->ZK4_AGENCI) + CRLF
      cSQL += " AND ZK4_CONTA   =  " + ValToSQL((cQryii)->ZK4_CONTA) + CRLF
      cSQL += " AND ZK4_VLTAR  > 0 " + CRLF

      If Select("cQry") > 0
        cQry->(dbCloseArea())
      EndIf

      TcQuery cSQL New Alias (cQry)

      nSoma := 0
      While !(cQry)->(Eof())
        nSoma := nSoma + (cQry)->ZK4_VLTAR
        (cQry)->(DbSkip())
      EndDo

      (cQry)->(DbGoTop())

      If  nSoma > 0
        cTime := FwTimeStamp()
        cTime := SubStr(cTime,1,4)+'-'+SubStr(cTime,5,2)+'-'+SubStr(cTime,7,2)+'__'+SubStr(cTime,9,2)+'h'+SubStr(cTime,11,2)+'m'+SubStr(cTime,13,2)+'s'
        aFINA100 := {;
          {"E5_DATA"      , dDataBase                   ,Nil},;
          {"E5_MOEDA"     , "M1"                        ,Nil},;
          {"E5_VALOR"     , nSoma                       ,Nil},;
          {"E5_NATUREZ"   , "2915"                      ,Nil},;
          {"E5_BANCO"     , (cQry)->ZK4_BANCO           ,Nil},;
          {"E5_AGENCIA"   , (cQry)->ZK4_AGENCI          ,Nil},;
          {"E5_CONTA"     , (cQry)->ZK4_CONTA           ,Nil},;
          {"E5_BENEF"     , ""                          ,Nil},;
          {"E5_HISTOR"    , "TAR. Pelo JOB BIAF167.PRW as "+cTime ,Nil}}

        MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,3)


        If !lMsErroAuto

          While !(cQry)->(Eof())

            ZK4->(dbGoTo((cQry)->RECNO))
            RecLock('ZK4', .F.)
            ZK4->ZK4_STATUS := '2' // Processado
            ZK4->(MsUnlock())
            (cQry)->(DbSkip())

          EndDo

        Else

          ErrorBlock(oError)
          cError := MostraErro("/dirdoc", "error.log") //ARMAZENA A MENSAGEM DE ERRO
          FwAlertError(cError,'Error')

        EndIf

      EndIf

      (cQry)->(DbCloseArea())

      (cQryii)->(DbSkip())

    EndDo

    (cQryii)->(DbCloseArea())

  Endif

Return



Static Function UDiaUtil()

  Local aArea    := GetArea()
  Local lDiaD    := .F.
  Local dDtValid := sToD("")
  Local dDtAtu   := sToD("")
  Default dDtIni := FirstDate(Date()) //CToD("01/01/19")
  Default dDtFin := LastDate(Date()) //CToD("31/01/19")

  //Enquanto a data atual for menor ou igual a data final
  dDtAtu := dDtIni
  While dDtAtu <= dDtFin
    //Se a data atual for uma data V�lida
    If dDtAtu == DataValida(dDtAtu)

      dDtValid :=  dDtAtu

    EndIf

    dDtAtu := DaySum(dDtAtu, 1)

  EndDo

  if dDtValid == dDataBase
    lDiaD := .T.
  EndIf

  RestArea(aArea)

Return lDiaD