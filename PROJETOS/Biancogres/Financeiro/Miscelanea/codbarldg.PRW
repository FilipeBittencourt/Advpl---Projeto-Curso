#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"


User Function CODBARLDG
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CODBARLDG                 �          � Data �  29/08/11     ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para retornar a linha digitavel                   ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/
                                                                                                               
Private xcodbarLdg   := Space(47)

//������������������������������������������������������������������������������������Ŀ
//� Posiciona SE2 para obter o conteudo do campo codigo de barras                      �
//��������������������������������������������������������������������������������������


If SUBS(SE2->E2_CODBAR,45,1) == SPACE(1)
    xCodbarLdg := SE2->E2_CODBAR
Else    
    xCodbarLdg := subs(SE2->E2_YLINDIG,1,4) + subs(SE2->E2_YLINDIG,33,1) + subs(SE2->E2_YLINDIG,34,14) + subs(SE2->E2_YLINDIG,5,5) + subs(SE2->E2_YLINDIG,11,10) + subs(SE2->E2_YLINDIG,22,10)
End



//If SUBS(SE2->E2_CODBAR,45,1) == SPACE(1)
//    xCodbarLdg := SE2->E2_CODBAR
//Else    
//    xCodbarLdg := subs(SE2->E2_CODBAR,1,4) + subs(SE2->E2_CODBAR,33,1) + subs(SE2->E2_CODBAR,34,14) + subs(SE2->E2_CODBAR,5,5) + subs(SE2->E2_CODBAR,11,10) + subs(SE2->E2_CODBAR,22,10)
//End
                                                                                       

//������������������������������������������������������������������������������������Ŀ
//� Fim do programa                                                                    �
//��������������������������������������������������������������������������������������
Return xCodbarLdg


