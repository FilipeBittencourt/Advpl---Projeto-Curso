#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTACOR    � Autor � AP6 IDE            � Data �  04/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa que extrai o numero da conta do Fornecedor para   ���
���          � Cnab de Pagamentos Banestes. (BANTRD.CPE)                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CTACOR


	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������

	Local i
	Private cNumcon := "", mNumCon:="", nTam:=0

	If SEA->EA_MODELO == "01" .OR. SEA->EA_MODELO == "03"
		mNumCon := SA2->A2_NUMCON
		nTam	:= Len(mNumCon)
		For i:=1 to nTam
			If Substr(mNumCon,i,1) <> "."
				cNumCon := cNumCon + Substr(mNumCon,i,1)
			Endif
		Next
		nTam := Len(Alltrim(cNumCon))
		If nTam <> 12
			cNumCon := Replicate("0",12-nTam) + cNumCon
		Endif
	Else 
		cNumCon := Replicate("0",12)   
	Endif	
Return(cNumCon)