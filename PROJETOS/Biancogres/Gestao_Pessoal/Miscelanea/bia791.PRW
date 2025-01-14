#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"

User Function BIA791()

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
Autor     := Marcos Alberto Soprani
Programa  := BIA791
Empresa   := Biancogres Ceramica S.A.
Data      := 27/05/14
Uso       := Gest鉶 de Pessoal
Aplica玢o := Limpa tabela de contabiliza玢o da Folha - SRZ
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

U_BIAMsgRun("Processando Limpeza de tabelas...",, {|| gBia791SRZ() })

Return

/*___________________________________________________________________________
ΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖ�
Ζ+-----------------------------------------------------------------------+Ζ
Ζun玢o    � gBia791SRZ  � Autor � Marcos Alberto S   � Data � 27/05/14 Ζ�
Ζ+-----------------------------------------------------------------------+Ζ
ΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖΖ�
�*/
Static Function gBia791SRZ()

Local xLimpaTb := .T.

// Limpa o arquivo de operacoes alocadas
dbSelectArea("SRZ")
If MA280FLock("SRZ")
	Zap
	dbSelectArea("SRZ")
	dbCloseArea("SRZ")
Else
	Help("EXCL")
	xLimpaTb := .F.
Endif

If xLimpaTb
	Aviso('Limpeza de Tabela','A tabela de contabiliza玢o da FOLHA foi zerada com sucesso. Pode efetuar a contabiliza玢o novamente.',{'Ok'})
EndIf


Return
