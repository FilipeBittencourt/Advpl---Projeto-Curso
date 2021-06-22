#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} TParComprovanteVistoriaObraEngenharia
@author Tiago Rossini Coradini
@since 20/11/2019
@version 1.0
@description Classe de parametros para controle do Comprovante de Vistorias em Obras de Engenharia
@obs Ticket: 19122
@type class
/*/


Class TParComprovanteVistoriaObraEngenharia From LongClassName

	Data cName
	Data aParam
	Data aParRet
	Data bConfirm
	Data lConfirm
	
	Data dSurveyForecast // Data de previsao da vistoria
	Data dSurveyRealization // Data de realizacao da vistoria
	Data cSigned // Assinatura
	Data c01File // Arquvo de comprovante 01 da vistoria
	Data c02File // Arquvo de comprovante 02 da vistoria
	Data c03File // Arquvo de comprovante 03 da vistoria		
			
	Method New() Constructor
	Method Update()
	Method Add()
	Method Box()
	Method Validate()
	Method Confirm()	
	
EndClass


Method New() Class TParComprovanteVistoriaObraEngenharia
	
	::cName := "ParComprovanteVistoriaObraEngenharia"
	
	::aParam := {}
	::aParRet := {}
	::bConfirm := {|| .T.}
	::lConfirm := .F.
	
	::dSurveyForecast := dDataBase
	::dSurveyRealization := dDataBase
	::cSigned := "N�o"
	::c01File := ""
	::c02File := ""
	::c03File := ""
	
Return()


Method Update() Class TParComprovanteVistoriaObraEngenharia
	
	::aParam := {}
	
	::cSigned := "N�o"
	::c01File := ""
	::c02File := ""
	::c03File := ""
	
Return()


Method Add() Class TParComprovanteVistoriaObraEngenharia
		
	aAdd(::aParam, {9, "Informe os dados para o confirma��o da vistoria.", 200,, .T.})	
	aAdd(::aParam, {1, "Dt. Previs�o", ::dSurveyForecast, "@D", ".T.",,".F.",,.T.})
	aAdd(::aParam, {1, "Dt. Realiza��o", ::dSurveyRealization, "@D", ".T.",,".F.",,.T.})
	aAdd(::aParam, {2, "Termo Assinado", ::cSigned, {"Sim", "N�o"}, 60, ".T.", .T.})
	aAdd(::aParam, {6, "Comprovante 01", ::c01File, "@!", ".T.", ".T.", 90, .T., "BMP (*.bmp) | *.bmp | JPEG (*.jpg) | *.jp* | PNG (*.png) | *.png | PDF (*.pdf) | *.pdf"})
	aAdd(::aParam, {6, "Comprovante 02", ::c02File, "@!", ".T.", ".T.", 90, .F., "BMP (*.bmp) | *.bmp | JPEG (*.jpg) | *.jp* | PNG (*.png) | *.png | PDF (*.pdf) | *.pdf"})
	aAdd(::aParam, {6, "Comprovante 03", ::c03File, "@!", ".T.", ".T.", 90, .F., "BMP (*.bmp) | *.bmp | JPEG (*.jpg) | *.jp* | PNG (*.png) | *.png | PDF (*.pdf) | *.pdf"})		
	
Return()


Method Box() Class TParComprovanteVistoriaObraEngenharia
Local lRet := .F.
Private cCadastro := "Parametros"
	
	::Update()
	
	::Add()
	
	::bConfirm := {|| ::Confirm() }
		
	If ParamBox(::aParam, "Opera��es", ::aParRet, ::bConfirm,,,,,,::cName, .F., .F.)
		
		lRet := .T.
			
		::dSurveyForecast := ::aParRet[2]
		::dSurveyRealization := ::aParRet[3]
		::cSigned := ::aParRet[4]
		::c01File := ::aParRet[5]
		::c02File := ::aParRet[6]
		::c03File := ::aParRet[7]

	EndIf
	
Return(lRet)


Method Validate() Class TParComprovanteVistoriaObraEngenharia
Local lRet := .T.
	//Ticket 32725 - Removido o DataValida permitindo os representantes realizarem vistoria de obras em dias n�o �teis.
	/*
	If MV_PAR03 <> DataValida(MV_PAR03)
			
		lRet := .F.
		
		MsgStop("Aten��o, data de realiza��o da vistoria inv�lida.")
	*/	
	If !File(MV_PAR05)
		
		lRet := .F.
		
		MsgStop("Aten��o, arquivo de comprovante 01 inv�lido.")
	
	ElseIf !Empty(MV_PAR06) .And. !File(MV_PAR06)
		
		lRet := .F.
		
		MsgStop("Aten��o, arquivo de comprovante 02 inv�lido.")
		
	ElseIf !Empty(MV_PAR07) .And. !File(MV_PAR07)
		
		lRet := .F.
		
		MsgStop("Aten��o, arquivo de comprovante 03 inv�lido.")
		
	EndIf
	
Return(lRet)


Method Confirm() Class TParComprovanteVistoriaObraEngenharia
	
	::lConfirm := ::Validate()
		
Return(::lConfirm)
