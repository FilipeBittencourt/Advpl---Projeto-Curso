#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA040alt  � Autor � AP7 IDE            � Data �  06/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Bloquear a alteracao   titulos que tenham o percentual de  ���
���          � comissao e que estejam incluidos nos tipos=MV_YNPCOM       ���
�������������������������������������������������������������������������͹��
���Uso       � AP7 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA040ALT()
Local nret := .t.
If Alltrim(E1_TIPO) $ GetMV("MV_YNPCOM") .and. (E1_COMIS1 > 0 .or. E1_COMIS2 > 0 .or. E1_COMIS3 > 0 .or. E1_COMIS4 > 0 .or. E1_COMIS5 > 0)
	Alert("Esse tipo de titulo nao pode ter percentual diferente de zero nos campos % DE COMISSAO")
	nret := .F.
EndIf

Return(nret)	