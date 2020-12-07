#include "rwmake.ch"
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TRM004C   � Autor � Julio Almeida      � Data �  01/02/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastros Tabelas Auxiliares - SX5                         ���
���          � R8 - Tipos de Despesas                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � TRM - Treinamento                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TRM004C()


Private cCadastro := "SX5: Tabela R8 - Tipos de Despesas"

Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
                     {"Visualizar","AxVisual",0,2},;
                     {"Incluir","AxInclui",0,3},;
                     {"Alterar","AxAltera",0,4},;
                     {"Excluir","AxDeleta",0,5}}

Private cString := "SX5"

dbSelectArea(cString)
dbSetOrder(1)
dbSetFilter({|| X5_TABELA = 'R8'},"X5_TABELA = 'R8'") // filtrar apenas a tabela R8 - Tipos de Despesas

mBrowse(6,1,22,75,cString)