#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������Ŀ��
���Funcao    � MT241CAB � Autor � Ranisses A. Corona    � Data � 28/06/11    �          ���
���������������������������������������������������������������������������������������Ĵ��
���Descricao � Habilita os campos D3_CLVL/D3_ITEMCTA, no cabecalho do Mov. Internos II  ���
���������������������������������������������������������������������������������������Ĵ��
��� Uso      � RDMAKE                                                                   ���
����������������������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
/*/



User Function MT241CAB()
Local oNewDialog := PARAMIXB[1]
Public aCV := Array(2,2) 

	aCV[1][1] = "D3_CLVL"
	
	If PARAMIXB[2] == 3 //Inclusao
		
		aCV[1][2] := Space(10)		
		@2.9, 46.5 SAY "Classe Valor" OF oNewDialog
		@2.8, 51.5 MSGET aCV[1][2] SIZE 40,08 OF oNewDialog Valid fv_ChkClv() F3 "CTH"
		
	Else
		
		aCV[1][2] := SD3->D3_CLVL
		@2.9, 46.5 SAY "Classe Valor" OF oNewDialog
		@2.8, 51.5 MSGET aCV[1][2] SIZE 40,08 OF oNewDialog F3 "CTH"  When .f.
		
	EndIf

Return(aCV)

/*---------+-----------+-------+-----------------------+------+------------+
| Funcao   | fv_ChkClv | Autor | Marcos Alberto        | Data | 29/09/2011 |
+----------+-----------+-------+-----------------------+------+------------+
| Descricao| Valida digita��o da Classe de Valor                           |
+----------+--------------------------------------------------------------*/
Static Function fv_ChkClv()

Local dx_Ret := .T.
CTH->(dbSetOrder(1))
If !CTH->(dbSeek(xFilial("CTH") + aCV[1][2])) //.or. Substr(CCC,1,1) <> Substr(aCV[1][2],1,1)
	MsgINFO("Classe de Valor incorreta!!! Favor verificar.", "MT241CAB (1)")
	dx_Ret := .F.
EndIf

DbSelectArea("CTH")
DbSeek(xFilial("CTH") + aCV[1][2])
If CTH->CTH_BLOQ == '1'
	MsgINFO("Classe de Valor Bloqueada!!! Favor verificar.", "MT241CAB (2)")
	dx_Ret := .F.
EndIf

// Inclu�do por Marcos Alberto Soprani em 09/06/15 para atender ao novo controle de CLVL por empresa
If dx_Ret
	dx_Ret := ExecBlock("BIA555", .F., .F.)
EndIf

If dx_Ret .And. ( SZJ->(FieldPos("ZJ_CLVL")) > 0 ) .And. ( SubStr(aCV[1][2],1,2) == "31" ) .and. AllTrim(FunName()) <> "MATA241"  // Esta ultima regra inclu�da por Maros A. Soprani depois de alinhado com Fernando - 31/12/15
	
	MsgAlert("Esta classe de valor � v�lida somente para os ITENS ap�s a sele��o da TAG.","MT241CAB")
	dx_Ret := .F.
	
EndIf


Return( dx_Ret )
