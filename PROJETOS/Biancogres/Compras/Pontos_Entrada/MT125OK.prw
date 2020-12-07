
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���PROGRAMA  � MT125OK        �AUTOR  � BRUNO MADALENO     � DATA �  26/09/08   ���
�������������������������������������������������������������������������������͹��
���DESC.     � PONTO DE ENTRADA RESPONSAVEL EM VALIDAR A ROTINA DE CONTRATO     ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���USO       � MP8 - R4                                                         ���
�������������������������������������������������������������������������������ͼ��         	
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
USER FUNCTION MT125OK()
Local lRet := .T.
Local nCount := 0
Local cClvl := ""
Local cItemCta := ""
Local cSubitem := ""	

	IF ALLTRIM(UPPER(CUSERNAME)) $ "CLAUDIA.C/GEOVANI/LUIZ/LETICIA.V/ALINE/JESEBEL/AYUMY/ROSILENE/ANA PAULA/LEONARDO_X/ARTHUR"
		IF SUBSTR(SC3->C3_NUM,1,2) >= '09'
			LRET := .F.
			ALERT("Usu�rio n�o pode alterar ou incluir este tipo de Contrato")
			Return(lRet)
		END IF
	ENDIF

 	For nCount := 1 To Len(aCols)

 		If !GdDeleted(nCount)
 		
 			cClvl := Gdfieldget('C3_YCLVL', nCount)
 			cItemCta := Gdfieldget('C3_YITEMCT', nCount)
 			cSubitem := Gdfieldget('C3_YSUBITE', nCount)			
			
			If Empty(cClvl)
				
				MsgBox("Classe de Valor em branco, favor preencher o mesmo para continuar!!", "MT125OK", "ALERT")
				
				lRet := .F.
				
				Return(lRet)
				
			EndIf
			
			If !U_fValItemCta("XX", .F., cClvl, cItemCta, cSubitem)
			
				lRet := .F.
				
				Return(lRet)
				
			EndIf
			 			
		 	// Valida Subitem de projeto
			If !U_BIAF160(cClvl, cItemCta, cSubitem)
			
				MsgBox("A classe de valor e o item de selecionados, exige o preenchimento do Subitem de Projeto!", "MT125OK", "STOP")
						
				lRet := .F.
				
				Return(lRet)
							
			EndIf	
 		
 		EndIf

 	Next

RETURN(lRet)
