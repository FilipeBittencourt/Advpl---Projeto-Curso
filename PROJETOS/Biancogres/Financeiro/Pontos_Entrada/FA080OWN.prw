#include "rwMake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FA080OWN � Autor � MADALENO              � Data � 26/03/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � FUNCAO VALIDAR A DATA DA BAIXA COM O PARAMETRO MV_DATAFIM  ���
���          � NO MOMENTO DO CANCELAMENTO DA BAIXA DO CONTAS A PAGAR      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FA080OWN()

	local lFA080OWN as logical

		begin sequence
			lFA080OWN:=(!FIDC():isPGFIDC(.T.))
			if (!lFA080OWN)
				break
			endif
			lFA080OWN:=FA080OWN()
		end sequence

	return(lFA080OWN)

static function FA080OWN()

LOCAL LRET := .T.

If SE5->E5_DATA <= GETMV("MV_DATAFIN") .AND. SE5->E5_DATA <> DDATABASE
	MsgBox("Data da Baixa Invalida. N�o � permitido realizar o Cancelamento da Baixa com data anterior a "+Dtoc(GetMv("MV_DATAFIN"))+" , e a Data Base dever� ser a mesma da Data da Baixa.","DATA INVALIDA","INFO")
	LRET := .F.
EndIf

If SE5->E5_DATA <> DDATABASE
	MsgBox("Data da Baixa Invalida. N�o � permitido realizar o Cancelamento da Baixa com data anterior a "+Dtoc(GetMv("MV_DATAFIN"))+" , e a Data Base dever� ser a mesma da Data da Baixa.","DATA INVALIDA","INFO")
	LRET := .F.
EndIf

Return(LRET)
