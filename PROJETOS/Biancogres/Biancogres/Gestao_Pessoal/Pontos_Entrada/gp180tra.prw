#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} GP180TRA
@author Marcos Alberto Soprani
@since 24/08/16
@version 1.0
@description Ponto de Entrada executado logo ap�s a atualiza��o dos dados da tabela Cadastro de Funcion�rios (SRA). 
.            A tabela fica posicionada no funcion�rio que foi transferido, e as informa��es atualizadas ficam dispon�veis e podem 
.            ser utilizadas em outros m�dulos do sistema ou rotinas espec�ficas.
@obs OS: 3338-16 - FRANCINE DIAS DE ABREU ARA�JO
@type function
/*/

User Function GP180TRA()

	Local cfgrArea := GetArea()

	U_BIAF043("0")

	RestArea(cfgrArea)

Return
