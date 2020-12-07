#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

User Function MT103FIN()

/*��������������������������������������������������������������������������
Autor     := Marcos Alberto Soprani
Programa  := MT103FIN
Empresa   := Biancogres Cer�mica S/A
Data      := 01/12/11
Uso       := Compras
Aplica��o := Ponto de Entrada Respons�vel pela Valida��o do Grid Duplicatas
.            Inicialmente para tratamento do vencimento das duplicatas
���������������������������������������������������������������������������*/

Local nCount
Local xaLocHd := PARAMIXB[1]      // aHeader do getdados apresentado no folter Financeiro.
Local xaLocCl := PARAMIXB[2]      // aCols do getdados apresentado no folter Financeiro.
Local xLocRtn := PARAMIXB[3]      // Flag de valida��es anteriores padr�es do sistema.
//                                   Caso este flag esteja como .T., todas as valida��es
//                                   anteriores foram aceitas com sucesso, no contr�rio, .F.
//                                   indica que alguma valida��o anterior N�O foi aceita.

If xLocRtn
	
	If Len(xaLocCl) > 0
	
		For nCount := 1 To Len(xaLocCl)
			
			If !Empty(xaLocCl[nCount][2]) .And. xaLocCl[nCount][2] < dDataBase
				
				MsgBox("O vencimento de uma ou mais duplicatas � menor que a data de digita��o. Favor verificar!!!","MT103FIN","STOP")
				
				xLocRtn := .F.
				
			EndIf
			
		Next
	
	EndIf
	
EndIf

Return(xLocRtn)
