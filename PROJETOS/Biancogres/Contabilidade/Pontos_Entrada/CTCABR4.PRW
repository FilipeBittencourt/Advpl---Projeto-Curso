#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CTCABR4  � Autor � Ranisses A. Corona    � Data � 26/08/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Este P.E. permite a customizacao do cabecalho padrao para   ��
���          � os relatorios da versao 4																	���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Contabilidade                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CTCABR4()               

If NomeProg == "CTBR510" // Exemplo -> Se for o Diario Contabil

//abec[3] := "CNPJ "+"02.077.546/0001-76         �DT.Ref.: 26/08/10"

/*        dDataIni        := mv_par01 
        dDataFim        := mv_par02 
        cDataExt := Transform(Day(dDataIni),'99') + " de " + MesExtenso(dDataIni) + " de " + Transform(Year(dDataIni),'9999');
            + " a " + Transform(Day(dDataFim),'99') + " de " + MesExtenso(dDataFim) + " de " + Transform(Year(dDataFim),'9999')
        aCabec := { cChar + " " + "EMPRESA TESTE S/A" + " " + cChar;
              , cChar + " " + "000.000.000-0" + " " + cChar;
              , cChar + " " + "LIVRO DIARIO" + " " + cChar;
              , cChar + " " + cDataExt + " " + cChar;
               , cChar + " " + RptFolha + TRANSFORM(oReport:Page(),'999999') }             */
Endif 

Return(aCabec)