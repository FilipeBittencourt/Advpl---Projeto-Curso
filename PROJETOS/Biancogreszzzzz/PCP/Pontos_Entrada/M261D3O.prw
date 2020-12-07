#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function M261D3O()

/*��������������������������������������������������������������������������
Autor     := Marcos Alberto Soprani
Programa  := M261D3O
Empresa   := Biancogres Cer�mica S/A
Data      := 04/09/12
Uso       := PCP
Aplica��o := E chamado na gravacao de cada registro de transfer�ncia de
.            origem no SD3
���������������������������������������������������������������������������*/

Public zt_NSeqD3 := SD3->D3_NUMSEQ // Vari�vel para o Programa BIA292

Return
