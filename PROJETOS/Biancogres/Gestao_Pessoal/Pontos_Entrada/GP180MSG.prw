#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function GP180MSG()

/*��������������������������������������������������������������������������
Autor     := Marcos Alberto Soprani
Programa  := GP180MSG
Empresa   := Biancogres Cer�mica S/A
Data      := 07/03/12
Uso       := Gest�o de Pessoal
Aplica��o := Apresenta Mensagem antes de confirmar a transfer�ncia.
���������������������������������������������������������������������������*/

Local yj_RetFn := .T.

MsgSTOP("Favor verificar se o centro de custo para o qual o funcion�rio est� sendo transferido possui adcionais de Insalubridade e Perculosidade","Aten��o (GP180MSG)")
yj_RetFn := MsgYesNo("Favor conferir se a matr�cula foi alterada corretamente! Deseja prosseguir? ","Aten��o (GP180MSG)")


Return ( yj_RetFn )