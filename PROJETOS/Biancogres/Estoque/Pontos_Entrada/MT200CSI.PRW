#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

User Function MT200CSI()

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
Autor     := Fernando Rocha
Autor(Rev):= Marcos Alberto Soprani
Programa  := MT200CSI
Empresa   := Biancogres Cer鈓ica S/A
Data      := 13/08/10
Data(Rev) := 30/08/11
Uso       := PCP
Aplica玢o := Ponto de Entrada que permite preencher informa珲es adcionais
.            na tela do cadastro de estrutura
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

Local aArea 		:= GetArea()
Local aAreaG1 	:= SG1->(GetArea())
Local aAreaB1 	:= SB1->(GetArea())
Local cProduto 	:= PARAMIXB[1]

SG1->(dbSetOrder(1))
If INCLUI .and. SG1->(dbSeek(xFilial("SG1")+cProduto))
	While SG1->(!Eof()) .and. SG1->(G1_FILIAL+G1_COD) == (xFilial("SG1")+cProduto)
		RecLock("SG1",.F.)
		SG1->G1_YDESCCD := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC")
		SG1->(MsUnlock())
		SG1->(dbSkip())
	End
EndIf

SB1->(RestArea(aAreaB1))
SG1->(RestArea(aAreaG1))

RestArea(aArea)

Return
