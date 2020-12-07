#include "rwmake.ch"
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TRM002C   � Autor � Julio Almeida      � Data �  01/02/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastros Tabelas Auxiliares - SX5                         ���
���          � RI -  Utilizacao do Material                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � TRM - Treinamento                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TRM002C()


Private cCadastro := "SX5: Tabela RI -  Utilizacao do Material"

Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
                     {"Visualizar","AxVisual",0,2},;
                     {"Incluir","AxInclui",0,3},;
                     {"Alterar","AxAltera",0,4},;
                     {"Excluir","AxDeleta",0,5}}

Private cString := "SX5"

dbSelectArea(cString)
dbSetOrder(1)
dbSetFilter({|| X5_TABELA = 'RI'},"X5_TABELA = 'RI'") // filtrar apenas a tabela RI -  Utilizacao do Material

mBrowse(6,1,22,75,cString)