#include "PROTHEUS.CH"

User Function MA650TOK()

/*��������������������������������������������������������������������������
Autor     := Marcos Alberto Soprani
Programa  := MA650TOK
Empresa   := Biancogres Cer�mica S/A
Data      := 12/01/15
Uso       := PCP
Aplica��o :=  Respons�vel por validar a Enchoice em rela��o as datas de
.            in�cio previsto e entrega prevista com prazo de entrega
.             Permite executar a valida��o do usu�rio ao confirmar a OP.
.             Implementado tratamento para impedir que o usu�rio incluia uma
.            revis�o vencida: inicialmente usada para PI
���������������������������������������������������������������������������*/

Local ftRet := .T.

If SB1->B1_TIPO $ "PI/PP" // Tratamento implementado em 04/12/15 para atender a OS effettivo 1383-15
	
	HG005 := " SELECT COUNT(*) CONTAD
	HG005 += "   FROM "+RetSqlName("SG1")+" SG1
	HG005 += "  WHERE G1_FILIAL = '"+xFilial("SG1")+"'
	HG005 += "    AND G1_COD = '"+M->C2_PRODUTO+"'
	If SB1->B1_TIPO == "PI"
		HG005 += "    AND G1_TRT = '"+M->C2_REVISAO+"'
	Else
		HG005 += "    AND G1_REVFIM = '"+M->C2_REVISAO+"'
	EndIf
	HG005 += "    AND '"+dtos(M->C2_DATPRI)+"' >= G1_INI
	HG005 += "    AND '"+dtos(M->C2_DATPRI)+"' <= G1_FIM
	HG005 += "    AND SG1.D_E_L_E_T_ = ' '
	HGIndex := CriaTrab(Nil,.f.)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,HG005),'HG05',.T.,.T.)
	dbSelectArea("HG05")
	dbGoTop()
	If HG05->CONTAD = 0
		Aviso('MA650TOK', 'A revis�o: '+Alltrim(M->C2_REVISAO)+' do produto: '+Alltrim(M->C2_PRODUTO)+' n�o � v�lida para o data in�cio de produ��o '+dtoc(M->C2_DATPRI)+' informada. Favor rever esta data ou a revis�o informada!!!',{'Ok'})
		ftRet := .F.
	EndIf
	HG05->(dbCloseArea())
	Ferase(HGIndex+GetDBExtension())
	Ferase(HGIndex+OrdBagExt())
	
EndIf

Return ( ftRet )
