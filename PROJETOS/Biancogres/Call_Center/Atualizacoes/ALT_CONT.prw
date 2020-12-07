#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/* 
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ���
����Programa  � ALT_CONT �Autor  � MADALENO           � Data �  10/07/09   ����
��������������������������������������������������������������������������͹���
����Desc.     � TELA PARA ALTERAR O NOME DO CONTATO.                       ����
����          �                                                            ����
��������������������������������������������������������������������������͹���
����Uso       � AP8                                                        ����
��������������������������������������������������������������������������ͼ���
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

USER FUNCTION ALT_CONT()
PRIVATE CCONTATO := SPACE(6)
PRIVATE CDESCRI := SPACE(255)
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oGet1","oGet2","oBtn1","oBtn2")

oDlg1      := MSDialog():New( 095,232,303,614,"oDlg1",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 004,004,092,184,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 016,012,{||"CODIGO CONTATO"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay2      := TSay():New( 045,013,{||"DESCRI��O"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,008)

oGet1      := TGet():New( 024,012,{|u| If(PCount()>0,CCONTATO:=u,CCONTATO)},oGrp1,052,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SU5","",,)
oGet1:bVALID 	:= {|| ATU_CON()}

oGet2      := TGet():New( 052,012,{|u| If(PCount()>0,CDESCRI:=u,CDESCRI)},oGrp1,160,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSBtn1     := SButton():New( 076,012,13,{|| CON_GRAVA() },oGrp1,,"", )
oSBtn2     := SButton():New( 077,133,02,{|| oDlg1:End() } ,oGrp1,,"", )

oDlg1:Activate(,,,.T.)


RETURN 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ATU_CON           �Microsiga           � Data �  10/07/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � ROTINA QUE BUSCA A DESCRICAO PARA SER ALTERADA             ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION ATU_CON()

DBSELECTAREA("SU5")
DBSETORDER(1)
DBSEEK(XFILIAL("SU5")+CCONTATO)
CDESCRI := PADR(SU5->U5_CONTAT,255)

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CON_GRAVA         �Microsiga           � Data �  10/07/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � ROTINA PARA GRAVAR A ALTERACAO DA DESCRICAO                ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION CON_GRAVA()

RecLock("SU5",.F.)
SU5->U5_CONTAT	:= CDESCRI
MsUnLock()

RETURN