/*---------+-----------+-------+----------------------+------+------------+
|Funcao    |WFRSP3     | Autor | Marcelo Sousa        | Data | 31.07.2018 |
|          |           |       | Facile Sistemas      |      |            |
+----------+-----------+-------+----------------------+------+------------+
|Descricao |MENU PARA CRIA��O DOS ACESSOS DE USU�RIOS AOS MENUS DE        |
|          |CADASTRO DE VAGAS E CURR�CULOS.  						      |
+----------+--------------------------------------------------------------+
|Uso       |RECRUTAMENTO E SELE��O                                        |
+----------+-------------------------------------------------------------*/
#include 'protheus.ch'
#include 'parmtype.ch'

user function BIAFM007()

	Local i

	/*������������������������������������������������������������������������ٱ�
	�� Declara��o de Variaveis Private dos Objetos                             ��
	ٱ�������������������������������������������������������������������������*/
	cUsrtst  := __cUserID
	aUsrtst2 := UsrRetGrp(cUsrtst)
	lAlt 	 := .F.
	lCria 	 := .F.
	lAprov   := .F.
	aUsr     := cUserName

	/*������������������������������������������������������������������������ٱ�
	�� Verifiando se usu�rio possui acesso ao grupo de recrutamento.           ��
	ٱ�������������������������������������������������������������������������*/
	For i:=1 to Len(aUsrtst2)

		IF aUsrtst2[i] == '000006'
			lAlt := .T.
		ENDIF

	Next

	/*������������������������������������������������������������������������ٱ�
	�� Disparando tela de cadastro dos acessos.                                ��
	ٱ�������������������������������������������������������������������������*/
	IF lAlt
		AxCadastro("ZR3", "Acessos para Recrutamento",)
	ELSE 
		Alert("Voc� n�o possui permiss�o para este menu. Favor procurar equipe de Recrutamento.")
	ENDIF

return