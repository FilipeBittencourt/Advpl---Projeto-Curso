#include "rwMake.ch"
#include "Topconn.ch"
/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    � FA330FLT   � Autor � Nilton                � Data � 25/11/04 ���
���          �            � Alter � Ranisses A. Corona    � Data � 29/10/09 ���
���������������������������������������������������������������������������Ĵ��
���Descricao �*Filtrar titulos na tela Compensacao CR                       ���
���          �*Filtrar apenas Titulos de Contrato                           ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Financeiro                                                   ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FA330FLT()

//Exibe Pergunta
Pergunte("FA330F", .T.)  

//Apos a migracao para versao MP10, desativamos o filtro de E1_PREFIXO <> RA. O 

If MV_PAR01 == 2
	//Filtro titulos com Forma de Pagamento = CT
	dbSelectArea("SE1")
	Set filter to SE1->E1_YFORMA == "4"
//	Set filter to !SE1->E1_PREFIXO == "RA" .And. SE1->E1_YFORMA == "4"
//Else
//	Filtro titulos com Prefixo <> RA
//	dbSelectArea("SE1")
//	Set filter to !SE1->E1_PREFIXO == "RA"
EndIf

Return