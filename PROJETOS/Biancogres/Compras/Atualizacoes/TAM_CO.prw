#INCLUDE "RWMAKE.CH"

USER FUNCTION TAM_CO()

/*���������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���PROGRAMA  � TAM_CO         �AUTOR  � BRUNO MADALENO     � DATA �  29/10/08   ���
�������������������������������������������������������������������������������͹��
���DESC.     � VALIDACAO PARA EXECUTAR A VALIDACAO NO NUMERO DA NOTA            ���
���          �	PARA NAO PERMITIR NUMERO DA NOTA MENOR QUE 6 DIGITOS            ���
�������������������������������������������������������������������������������͹��
���USO       � AP 8                                                             ���
�������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������*/

Local LLRET := .T.

//Tratamento para Totvs Colaboracao 2.0
If GetMv("MV_COMCOL1") <> 2 .And. Upper(Alltrim(FUNNAME())) == "SCHEDCOMCOL"  
	Return(LLRET)	
EndIf

If Dtos(Date()) >= "20121015" 
	CNFISCAL := strzero(val(CNFISCAL),9,0)
EndIf

IF LEN(ALLTRIM(CNFISCAL)) <> 9 .and. !Empty(cNFiscal)
	msgBox("N�MERO DA NOTA FISCAL INV�LIDO. O N�mero da NF deve conter 9 caracteres.","Documento Entrada","ALERT")
	LLRET := .F.
ENDIF	

/*If cEmpAnt == "02" .And. Dtos(Date()) >= "20120901" 
	CNFISCAL := strzero(val(CNFISCAL),9,0)
Else
	IF LEN(ALLTRIM(CNFISCAL)) <> 6 .and. !Empty(cNFiscal)
		msgBox("N�MERO DA NOTA FISCAL INV�LIDO. O N�mero da NF deve conter 6 caracteres.","Documento Entrada","ALERT")
		LLRET := .F.
	ENDIF	
EndIf*/

RETURN(LLRET)