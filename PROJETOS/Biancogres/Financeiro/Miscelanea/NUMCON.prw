#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NUMCON    � Autor � AP6 IDE            � Data �  04/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa que extrai o numero da conta do Banestes para  o  ���
���          � Cnab devido ao fato de estarem com config. diferentes.     ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function NUMCON


	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local  i

	Private cNumcon := "", mNumCon:="", nTam:=0

	mNumCon := SA6->A6_NUMCON
	nTam	:= Len(mNumCon)
	For i:=1 to nTam
		If Substr(mNumCon,i,1) <> "." .AND. Substr(mNumCon,i,1) <> "-"
			cNumCon := cNumCon + Substr(mNumCon,i,1)
		Endif
	Next                           
	nTam := Len(Alltrim(cNumCon))
	If SA6->A6_COD == "001"
		If nTam <> 10
			cNumCon := Replicate("0",10-nTam) + cNumCon
		Endif
	ElseIf SA6->A6_COD == "021"
		If nTam <> 11
			cNumCon := Replicate("0",11-nTam) + cNumCon
		Endif
	Endif

Return(cNumCon)
