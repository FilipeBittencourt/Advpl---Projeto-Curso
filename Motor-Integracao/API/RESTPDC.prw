#include "protheus.ch"
#Include 'RESTFUL.CH'

#Define cEOL Chr(13)+Chr(10)

WsRestFul pedidocompra Description "Facile Sistemas Webservices - Motor de Integra��o"
  WSMETHOD POST DESCRIPTION "Session Motor de Integra��o" WSSYNTAX "/pedidocompra"
End WsRestFul

WSMETHOD POST WSSERVICE pedidocompra
 
  Local cBody    := "" 
  Local oJson    := JsonObject():New() 
  Local oIMAbast := TIntegracaoMotorAbastecimentoParse():New()
  
  ::SetContentType("application/json")   

  //|Recupera os dados do body |  
  cBody := ::GetContent()
  conOut('pedidocompra - POST METHOD')  
  oJson:FromJson(cBody)  // converte para JsonObject 


  oJson := oIMAbast:PedidoCompra(oJson)
  ::SetStatus(oJson["Status"])  
  ::SetResponse(oJson:ToJson())

  FreeObj(oJson)   

Return .T.
 
 