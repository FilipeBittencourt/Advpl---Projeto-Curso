#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function BIA349()

/*��������������������������������������������������������������������������
Autor     := Marcos Alberto Soprani
Programa  := BIA349
Empresa   := Biancogres Cer�micas S/A
Data      := 14/11/14
Uso       := Faturamento
Aplica��o := Impress�o da DANFE padr�o Totvs a partir do MENU
���������������������������������������������������������������������������*/

Public aFilBrw := {,}

aFilBrw[1] := "SF2"
aFilBrw[2] := ""

SpedDanfe()

Return
