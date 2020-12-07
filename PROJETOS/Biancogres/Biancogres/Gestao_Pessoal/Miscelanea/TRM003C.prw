#include "rwmake.ch"
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TRM003C   � Autor � Julio Almeida      � Data �  01/02/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastros Tabelas Auxiliares - SX5                         ���
���          � R6 - Tipos de Cursos                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � TRM - Treinamento                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TRM003C()


Private cCadastro := "SX5: Tabela R6 - Tipos de Cursos"

Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
                     {"Visualizar","AxVisual",0,2},;
                     {"Incluir","AxInclui",0,3},;
                     {"Alterar","AxAltera",0,4},;
                     {"Excluir","AxDeleta",0,5}}

Private cString := "SX5"

dbSelectArea(cString)
dbSetOrder(1)
dbSetFilter({|| X5_TABELA = 'R6'},"X5_TABELA = 'R6'") // filtrar apenas a tabela R6 - Tipos de Cursos

mBrowse(6,1,22,75,cString)