#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/01/01

User Function BIA898()        // incluido pelo assistente de conversao do AP5 IDE em 29/01/01

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
	//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
	//� identificando as variaveis publicas do sistema utilizadas no codigo �
	//� Incluido pelo assistente de conversao do AP5 IDE                    �
	//�����������������������������������������������������������������������

	Local xxn

	Private cArq	:= ""
	Private cInd	:= 0
	Private cReg	:= 0

	Private cArqSF4	:= ""
	Private cIndSF4	:= 0
	Private cRegSF4	:= 0

	cArq := Alias()
	cInd := IndexOrd()
	cReg := Recno()

	DbSelectArea("SF4")
	cArqSF4 := Alias()
	cIndSF4 := IndexOrd()
	cRegSF4 := Recno()

	/*/
	�������������������������������������������������������������������������������
	���������������������������������������������������������������������������Ŀ��
	���Fun��o    � BIA898     � Autor � Ranisses A. Corona    � Data � 05/05/04 ���
	���������������������������������������������������������������������������Ĵ��
	���Descri��o � So pode usar TES sem gerar duplicata para o Del-Credere      ���
	���������������������������������������������������������������������������Ĵ��
	��� Uso      � Interpretador x Base                                         ���
	����������������������������������������������������������������������������ٱ�
	�������������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	/*/

	wAlias  := Alias()
	cArqSB1 := cArqSA1 := cArqSA3 := lFuncao := " "
	For xxn := 1 to Len(aHeader)
		xcCampo := Trim(aHeader[xxn][2])
		If xcCampo == "C6_TES"
			wTes    := aCols[n][xxn]
		Endif
	Next

	wYTipoVen := ALLTRIM(M->C5_YSUBTP)

	//�����������������������������������������������������������������������Ŀ
	//� Cadastro de TES                                                       �
	//�������������������������������������������������������������������������
	DbSelectArea("SF4")
	DbSetOrder(1)
	DbSeek(xFilial("SF4")+wTes,.F.)

	//Verifica se a TES utilizada confere com o Tipo de Venda
	If wYTipoVen == "A"      //Amostra
		If !Subs(SF4->F4_TEXTO,1,3) == "AMO"
			msgBox("TES Usada Invalida - Favor Entrar em Contato Com o Setor Fiscal ...","ALERT")
			wTes := ""
		EndIf
	ElseIf wYTipoVen == "B"  //Bonificacao
		If !Subs(SF4->F4_TEXTO,1,3) == "BON"
			msgBox("TES Usada Invalida - Favor Entrar em Contato Com o Setor Fiscal ...","ALERT")
			wTes := ""
		EndIf
	ElseIf wYTipoVen == "D"  //Doacao
		If !Subs(SF4->F4_TEXTO,1,3) == "DOA"
			msgBox("TES Usada Invalida - Favor Entrar em Contato Com o Setor Fiscal ...","ALERT")
			wTes := ""
		EndIf
	EndIf

	If cArqSF4 <> ""
		dbSelectArea(cArqSF4)
		dbSetOrder(cIndSF4)
		dbGoTo(cRegSF4)
		RetIndex("SF4")
	EndIf

	DbSelectArea(cArq)
	DbSetOrder(cInd)
	DbGoTo(cReg)

Return(wTes)
