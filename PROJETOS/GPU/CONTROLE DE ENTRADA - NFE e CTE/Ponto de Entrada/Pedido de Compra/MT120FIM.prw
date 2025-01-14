#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
------------------------------------------------------------------------------------------------------------
Fun��o		: MT120FIM
Tipo		: Ponto de Entrada
Descri��o	: Ap�s a restaura��o do filtro da FilBrowse depois de fechar a opera��o realizada no pedido de 
			  compras, � a ultima instru��o da fun��o A120Pedido.
Uso			: Compras
Par�metros	: 
Retorno	: 
------------------------------------------------------------------------------------------------------------
Atualiza��es:
- 05/10/2015 - Henrique - Constru��o inicial do fonte
------------------------------------------------------------------------------------------------------------
*/
User Function MT120FIM()
	Local lPedBloq := .F.
	//Local nOpcao	:= PARAMIXB[1]   // Op��o Escolhida pelo usuario 
	//Local cNumPC	:= PARAMIXB[2]   // Numero do Pedido de Compras
	Local nOpcA	:= PARAMIXB[3]  // Indica se a a��o foi Cancelada = 0  ou Confirmada = 1.CODIGO DE APLICA��O DO USUARIO  

	SetKey( VK_F6,Nil )
	SetKey( VK_F7,nil) 
	
	If nOpcA == 0 .OR. AllTrim(FunName())=='VIXA116'
		Return
	EndIf
	
	lPedBloq := SC7->C7_CONAPRO == 'B'
	
	If (PARAMIXB[1] == 3 .Or. PARAMIXB[1] == 4) .And. !IsBlind() // inclusao ou alteracao
	
		U_VIX259CR(SC7->C7_NUM, SC7->C7_FORNECE, SC7->C7_LOJA) // Busca o trecho do fornecedor (ZZ0) e copia para o trecho do PC tabela (ZZE)
	
	EndIf
		
	If lPedBloq .AND. !IsBlind()
		If MsgYesNo("Gostaria de transmitir o pedido para o fornecedor?")
			U_VIXA114()
		EndIf
	EndIf

Return