User Function M460MARK()
Local oDocSai := TCacDocumentoSaida():New()

	If oDocSai:PossuiDanfeATransmitir()
		Aviso("M460MARK",OemToAnsi("A emiss�o de Documentos de Sa�da estar� liberada ap�s transmiss�o de todas as DANFES."),{"Ok"},2)
	EndIf
Return(!oDocSai:lPossuiDanfeATransmitir)