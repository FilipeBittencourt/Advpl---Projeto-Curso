#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "SHELL.CH"
#include "Fileio.ch"
#include "tbiconn.ch"

User Function A250ITOK()

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
Autor     := Marcos Alberto Soprani
Programa  := A250ITOK
Empresa   := Biancogres Cer鈓ica S/A
Data      := 24/10/11
Uso       := PCP / Estoque Custos
Aplica玢o := Ponto de entrada para validar se a quantidade a ser baixada
.            a partir do empenho (SD4) possui saldo em Estoque ou na
.            InterCompany. Depois de verificado os saldo nas empresas,
.            e n鉶 havendo saldo, o sistema n鉶 permite dar continua玢o ao
.            apontamento. Caso tenha saldo, deixa passar e usa o ponto de
.            entrada A250FSD4 para efetuar a baixa Intercompany
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

Local kj_OkRet := ParamIXB
Public qw_Varr1 := .T.
Public xk_RetPE := .T.
Public xk_AryPd := {}

Return
