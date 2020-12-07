#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "SHELL.CH"
#include "Fileio.ch"
#include "tbiconn.ch"

User Function A250ITOK()

/*��������������������������������������������������������������������������
Autor     := Marcos Alberto Soprani
Programa  := A250ITOK
Empresa   := Biancogres Cer�mica S/A
Data      := 24/10/11
Uso       := PCP / Estoque Custos
Aplica��o := Ponto de entrada para validar se a quantidade a ser baixada
.            a partir do empenho (SD4) possui saldo em Estoque ou na
.            InterCompany. Depois de verificado os saldo nas empresas,
.            e n�o havendo saldo, o sistema n�o permite dar continua��o ao
.            apontamento. Caso tenha saldo, deixa passar e usa o ponto de
.            entrada A250FSD4 para efetuar a baixa Intercompany
���������������������������������������������������������������������������*/

Local kj_OkRet := ParamIXB
Public qw_Varr1 := .T.
Public xk_RetPE := .T.
Public xk_AryPd := {}

Return
