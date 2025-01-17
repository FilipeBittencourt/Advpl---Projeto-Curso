#include "rwmake.ch"
#include "topconn.ch"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  矪IA833    � Autor � Ranisses A. Corona � Data �  23/11/10   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋escricao � Codigo do Banco - CNAB A Pagar Bradesco [096 a 098]        罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � Financeiro                                                 罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/

User Function BIA833()
	Local nBanco := ""

	If SEA->EA_MODELO $ "01_03_08"		//CREDITO EM CONTA / DOC / TED
	
		nBanco := StrZero(Val(SA2->A2_BANCO),3)
		
	ElseIf SEA->EA_MODELO == "31"			//PAGAMENTO DE TITULOS MESMO BANCO / PAGAMENTO DE TITULOS OUTROS BANCOS
	
		If !Empty(Substr(SE2->E2_CODBAR,1,3))
		
			nBanco	:=	Substr(SE2->E2_CODBAR,1,3)

		ElseIf !Empty(Substr(SE2->E2_LINDIG,1,3))
		
			nBanco	:=	Substr(SE2->E2_LINDIG,1,3)
					
		ElseIf !Empty(Substr(SE2->E2_YLINDIG,1,3))
		
			nBanco	:=	Substr(SE2->E2_YLINDIG,1,3)
			
		Else
			
			/*
		MSGBOX("ATENCAO, TITULO: "+SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA+CHR(13)+CHR(10)+;
		"NAO POSSUI C覦IGO DE BARRAS OU LINHA DIGIT罺EL INFORMADOS","VERIFICAR ERRO","STOP")
			*/
			
			Help(NIL, NIL, "Codigo de barras obrigatorio", NIL,;
				"ATENCAO, TITULO: "+SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA+CHR(13)+CHR(10)+;
				"NAO POSSUI C覦IGO DE BARRAS OU LINHA DIGIT罺EL INFORMADOS", 1, 0, NIL, NIL, NIL, NIL, NIL,;
				{"Verifique o modelo e tipo de pagamento, pois esperam titulos com codigo de barras"})
							
		EndIf
		
	Else
		
		//MsgBox("Modalidade de Pagamento n鉶 � valida para Opera珲es no Banco Bradesco.","ATEN敲O","STOP")
		
		Help(NIL, NIL, "Modalidade invalida", NIL,;
			"Modalidade de Pagamento n鉶 � valida para Opera珲es no Banco Bradesco. O arquivo ser� gerado com ERRO!", 1, 0, NIL, NIL, NIL, NIL, NIL,;
			{"Verifique a modalidade " + SEA->EA_MODELO})
	
	EndIf

Return(nBanco)