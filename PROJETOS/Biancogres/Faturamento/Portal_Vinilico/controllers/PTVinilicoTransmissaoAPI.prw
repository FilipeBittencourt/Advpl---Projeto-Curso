#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} PTVinilicoTransmissaoAPI
Classe respons�vel por realizar as transmiss�es para o portal vinilico
@type class
@version 1.0
@author Pontin - Facile Sistemas
@since 15/12/2020
/*/
Class PTVinilicoTransmissaoAPI From PTVinilicoAbstractAPI

  Data cEndPoint
  Data cToken
  Data cBcoAuth
  Data cUrl
  Data jBody

  Method New() Constructor

  Method Post()
  Method Put()
  Method Get()

  Method Valid()

EndClass


/*/{Protheus.doc} PTVinilicoTransmissaoAPI::New
M�todo construtor da classe
@type method
@version 1.0
@author Pontin - Facile Sistemas
@since 15/12/2020
/*/
Method New() Class PTVinilicoTransmissaoAPI

  _Super:New()

  ::cEndPoint       := ""
  ::cToken          := ""
  ::cBcoAuth        := ""
  ::jBody           := JsonObject():New()
  ::cUrl            := SuperGetMV("ZZ_VNURL", .F., "https://vinilicobackend.appfacile.com.br")

Return


/*/{Protheus.doc} PTVinilicoTransmissaoAPI::Post
M�todo para envio do verbo POST 
@type method
@version 1.0
@author Pontin - Facile Sistemas
@since 15/12/2020
@return object, resultado do envio
/*/
Method Post() Class PTVinilicoTransmissaoAPI

  Local aHeader     := {}
  Local jResult     := JsonObject():New()
  Local jValid      := Nil
  Local oRest       := Nil
  Local cError      := ""
  Local cBody       := ""

  //|Monta object de retorno |
  jResult["code"]         := 0
  jResult["status"]       := ""
  jResult["message"]      := ""

  If ValType(self:jBody) == "J"

    cBody     := ::jBody:ToJson()

    jValid    := ::Valid()

    If jValid["status"] == "OK"

      oRest := FWRest():New( ::cUrl )

      //|Cabe�alho de requisi��o |
      aAdd( aHeader, "Accept-Encoding: UTF-8" )
      aAdd( aHeader, "Content-Type: application/json; charset=utf-8" )
      aAdd( aHeader, "Authorization: " + AllTrim(::cToken) )

      //|Endpoint |
      oRest:SetPath( ::cEndPoint )
      oRest:SetChkStatus(.F.)

      //|Seta o body |
      oRest:SetPostParams( cBody )

      If oRest:Post(aHeader)

        cError            := ""
        jResult["code"]   := HTTPGetStatus(@cError)

        If jResult["code"] >= 200 .And. jResult["code"] <= 299

          jResult["status"]     := "OK"
          jResult["message"]   := _Super:DecodeConvert( oRest:GetResult() )

        Else
          jResult["status"]     := "ERRO"
          jResult["message"]    := cError + " #### " + CRLF + _Super:ErroConvert( _Super:DecodeConvert( oRest:GetResult() ) )
        EndIf

      Else

        jResult["code"]       := 400
        jResult["status"]     := "ERRO"
        jResult["message"]    := _Super:ErroConvert( _Super:DecodeConvert( oRest:GetLastError() ) )

      EndIf

    Else

      jResult["code"]         := 401
      jResult["status"]       := "ERRO"
      jResult["message"]      := jValid["message"]

    EndIf

  Else

    jResult["code"]         := 400
    jResult["status"]       := "ERRO"
    jResult["message"]      := "Body enviado n�o est� no formato de JsonObject"

  EndIf

  FreeObj(jValid)
  FreeObj(oRest)

Return jResult


/*/{Protheus.doc} PTVinilicoTransmissaoAPI::Put
M�todo respons�vel por enviar altera��es para o Portal Vinilico atrav�s do verbo PUT
@type method
@version 1.0
@author Pontin - Facile Sistemas
@since 15/12/2020
@return object, Retorno do envio
/*/
Method Put() Class PTVinilicoTransmissaoAPI

  Local aHeader     := {}
  Local jResult     := JsonObject():New()
  Local jValid      := Nil
  Local oRest       := Nil
  Local cError      := ""
  Local cBody       := ""

  //|Monta object de retorno |
  jResult["code"]         := 0
  jResult["status"]       := ""
  jResult["message"]      := ""

  If ValType(self:jBody) == "J"

    cBody     := ::jBody:ToJson()

    jValid    := ::Valid()

    If jValid["status"] == "OK"

      oRest := FWRest():New( ::cUrl )

      //|Cabe�alho de requisi��o |
      aAdd( aHeader, "Accept-Encoding: UTF-8" )
      aAdd( aHeader, "Content-Type: application/json; charset=utf-8" )
      aAdd( aHeader, "Authorization: " + AllTrim(::cToken) )

      //|Endpoint |
      oRest:SetPath( ::cEndPoint )
      oRest:SetChkStatus(.F.)

      If oRest:Put(aHeader, cBody)

        cError            := ""
        jResult["code"]   := HTTPGetStatus(@cError)

        If jResult["code"] >= 200 .And. jResult["code"] <= 299

          jResult["status"]     := "OK"
          jResult["message"]   := _Super:DecodeConvert( oRest:GetResult() )

        Else
          jResult["status"]     := "ERRO"
          jResult["message"]    := cError + " #### " + CRLF + _Super:ErroConvert( _Super:DecodeConvert( oRest:GetResult() ) )
        EndIf

      Else

        jResult["code"]       := 400
        jResult["status"]     := "ERRO"
        jResult["message"]    := _Super:ErroConvert( _Super:DecodeConvert( oRest:GetLastError() ) )

      EndIf

    Else

      jResult["code"]         := 401
      jResult["status"]       := "ERRO"
      jResult["message"]      := jValid["message"]

    EndIf

  Else

    jResult["code"]         := 400
    jResult["status"]       := "ERRO"
    jResult["message"]      := "Body enviado n�o est� no formato de JsonObject"

  EndIf

  FreeObj(jValid)
  FreeObj(oRest)

Return jResult


/*/{Protheus.doc} PTVinilicoTransmissaoAPI::Get
M�todo respons�vel por buscar informa��es no portal vin�lico atrav�s do verbo GET
@type method
@version 1.0
@author Pontin - Facile Sistemas
@since 15/12/2020
@return object, Objeto de retorno
/*/
Method Get() Class PTVinilicoTransmissaoAPI

  Local aHeader     := {}
  Local jResult     := JsonObject():New()
  Local jValid      := Nil
  Local oRest       := Nil
  Local cError      := ""

  //|Monta object de retorno |
  jResult["code"]         := 0
  jResult["status"]       := ""
  jResult["message"]      := ""

  jValid    := ::Valid()

  If jValid["status"] == "OK"

    oRest := FWRest():New( ::cUrl )

    //|Cabe�alho de requisi��o |
    aAdd( aHeader, "Accept-Encoding: UTF-8" )
    aAdd( aHeader, "Content-Type: application/json; charset=utf-8" )
    aAdd( aHeader, "Authorization: " + AllTrim(::cToken) )

    //|Endpoint |
    oRest:SetPath( ::cEndPoint )
    oRest:SetChkStatus(.F.)

    If oRest:Get(aHeader)

      cError            := ""
      jResult["code"]   := HTTPGetStatus(@cError)

      If jResult["code"] >= 200 .And. jResult["code"] <= 299

        jResult["status"]     := "OK"
        jResult["message"]   := _Super:DecodeConvert( oRest:GetResult() )

      Else
        jResult["status"]     := "ERRO"
        jResult["message"]    := cError + " #### " + CRLF + _Super:ErroConvert( _Super:DecodeConvert( oRest:GetResult() ) )
      EndIf

    Else

      jResult["code"]       := 400
      jResult["status"]     := "ERRO"
      jResult["message"]    := _Super:ErroConvert( _Super:DecodeConvert( oRest:GetLastError() ) )

    EndIf

  Else

    jResult["code"]         := 401
    jResult["status"]       := "ERRO"
    jResult["message"]      := jValid["message"]

  EndIf

  FreeObj(jValid)
  FreeObj(oRest)

Return jResult



/*/{Protheus.doc} PTVinilicoTransmissaoAPI::Valid
Valida se o requisito b�sico para consumir o portal est� satisfeito
@type method
@version 1.0
@author Pontin - Facile Sistemas
@since 15/12/2020
@return object, objeto com resultado da valida��o
/*/
Method Valid() Class PTVinilicoTransmissaoAPI

  Local jResult     := JsonObject():New()
  Local jLogin      := JsonObject():New()
  Local oSession    := Nil

  //|Monta object de retorno |
  jResult["status"]       := "OK"
  jResult["message"]      := ""

  //|Faz login se necess�rio |
  If Empty(::cToken)

    oSession := PTVinilicoSessionAuth():New()
    jLogin   := oSession:Login()

    ::cToken := jLogin["token"]

    If Empty( ::cToken )

      jResult["status"]       := "ERRO"
      jResult["message"]      := "N�o foi poss�vel realizar o login no Portal Vinilico. " + CRLF + ::ErroConvert( jLogin["result"] )

    EndIf

  EndIf

Return jResult
