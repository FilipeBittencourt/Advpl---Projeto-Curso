#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#INCLUDE "TBICONN.CH"
#include "TOTVS.CH"

/*/{Protheus.doc} BIA724
@description Workflow para Integra��o da terceira unidade de medida para o MES
@author Marcos Alberto Soprani
@since 16/01/19
@version 1.0
/*/

User Function BIA724()

	Local aMATA650      := {}       //-Array com os campos
	//������������������Ŀ
	//� 3 - Inclusao     �
	//� 4 - Alteracao    �
	//� 5 - Exclusao     �
	//��������������������
	Local nOpc              := 4
	Private lMsErroAuto     := .F.

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

	aMata650  := {  {'C2_FILIAL'   ,"01"                    ,NIL},;
	{                'C2_PRODUTO'  ,"BO0257L1       "       ,NIL},;          
	{                'C2_NUM'      ,"074554"                ,NIL},;          
	{                'C2_ITEM'     ,"01"                    ,NIL},;          
	{                'C2_SEQUEN'   ,"001"                   ,NIL},;          
	{                'C2_OBS'      ,"XXX"                   ,NIL}}             

	ConOut("Inicio  : "+Time())

	//��������������������������������������������������������������Ŀ
	//� Se alteracao ou exclusao, deve-se posicionar no registro     �
	//� da SC2 antes de executar a rotina automatica                 �
	//����������������������������������������������������������������
	If nOpc == 4 .Or. nOpc == 5
		SC2->(DbSetOrder(1)) // FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
		SC2->(DbSeek(xFilial("SC2")+"074554"+"01"+"001"))
	EndIf

	msExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)
	If !lMsErroAuto
		ConOut("Sucesso! ")
	Else
		ConOut("Erro!")
		MostraErro()
	EndIf

	ConOut("Fim  : "+Time())

	RESET ENVIRONMENT

Return
