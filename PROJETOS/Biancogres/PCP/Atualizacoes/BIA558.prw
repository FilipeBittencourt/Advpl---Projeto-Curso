#Include "Protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#Include "font.ch"

User Function BIA558()

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
Autor     := Marcos Alberto Soprani
Programa  := BIA558
Empresa   := Biancogres Cer鈓ica S/A
Data      := 17/02/16
Uso       := PCP
Aplica玢o := Cadastro de Tanques para controle de sobras de esmalte di醨io
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

dbSelectArea("Z67")
dbGoTop()

cCadastro := " ....: Cadastro de Tanques :.... "

aRotina   := {  {"Pesquisar"  ,"AxPesqui"                             ,0, 1},;
{                "Visualizar" ,"AxVisual"                             ,0, 2},;
{                "Incluir"    ,"AxInclui"                             ,0, 3},;
{                "Alterar"    ,"AxAltera"                             ,0, 4},;
{                "Excluir"    ,"AxDeleta"                             ,0, 5} }

mBrowse(6,1,22,75, "Z67", , , , , ,)

Return
