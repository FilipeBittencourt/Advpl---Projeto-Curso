#include "rwmake.ch" 
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � FA60FIL    � Autor � WLADIMIR ILLIUSHENKO  � Data � 23/01/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Acrescenta filtro na montagem do bordero                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGAFIN                                                      潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/

User Function FA60FIL() 
Local cFiltro := ""

do while .T.
	
	//Permite apenas o tipo "1 Cobranca Simples"	
	If PARAMIXB[4] <> "1" 
		cFiltro := "E1_SITUACA == 'X'" //PARA NAO FILTRAR NENHUM REGISTRO
		MsgBox("Somente � permitido o uso de 1 - Cobran鏰 Simples. Favor realizar o filtro novamente.","FA60FIL","STOP")
		Return(cFiltro)
	EndIf
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Pergunta se deseja enviar somente os titulos a serem pagos em banco.     �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	Pergunte("FA60FI", .T.)
	
	cFiltro := "E1_YFORMA <> '0'"
	if MV_PAR01 == 1
		cFiltro := "E1_YFORMA == '1'"
	endif
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Pergunta se deseja enviar somente os titulos a dos clientes de um ...    �
	//� determinado Estado, caso o usuario tenha optado por isto na primeira ... �
	//� pergunta.                                                                �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	if MV_PAR02 == 1
		Pergunte("Y00001", .T.)
		if !MV_PAR01$'ACALAPAMBACEDFESGOMAMTMSMGPAPBPRPEPIRJRNRSRORRSCSPSETO'
			MsgBox("Unidade Federal invalida!","FA60FIL","STOP")
			Loop
		endif
		cFiltro += " .AND. E1_YUFCLI == '"+MV_PAR01+"'"
	endif
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Filtro para o prefixo do titulo                                          �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If mv_par03 == 1 //Bianco - Linha 01               
	   cFiltro += " .AND. Alltrim(E1_PREFIXO) == 'S1'"
	ElseIf mv_par03 == 2 //Incesa - Linha 02               
	   cFiltro += " .AND. Alltrim(E1_PREFIXO) == 'S2'"
	EndIf   

	If mv_par04 == 1		// FT
		cFiltro += " .AND. Alltrim(E1_TIPO) == 'FT' "
	ElseIf mv_par04 == 2	// NF (considera as NF's e as ST's para o Estado do ES a partir de 10/05/13 
		cFiltro += " .AND. Alltrim(E1_TIPO) == 'NF' .AND. !Alltrim(E1_YCLASSE) $ '1_2' " //Considera as NF, exceto com as Classes de ST e BOL  //desativado em 10/05/13
		//cFiltro += " .AND. ( Alltrim(E1_TIPO) == 'NF' .OR. ( Alltrim(E1_YUFCLI) == 'ES' .AND. Alltrim(E1_YCLASSE) == '1') ) .AND. Alltrim(E1_YCLASSE) <> '2' " //ativado em 10/05/13
	ElseIf mv_par04 == 3	// ST
        cFiltro += " .AND. Alltrim(E1_YCLASSE) == '1' " //Filtra apenas os Titulos de ST
	ElseIf mv_par04 == 4	// BOL
        cFiltro += " .AND. Alltrim(E1_YCLASSE) == '2' " //Filtra apenas os Titulos de tipo = BOL / pre = CT 	        
	ElseIf mv_par04 == 5	// RA (considera os recebimentos antecipados gerados por pedido
		cFiltro += " .AND. Alltrim(E1_YCLASSE) == '6' " //Filtra apenas os Titulos de RA com Boletos
	EndIf

	//Caso o parametro esteja preenchido, fitra clientes aleatoriamente. //OS 1909-12
	If !Empty(Alltrim(MV_PAR06))
        cFiltro += " .AND. E1_CLIENTE $ '"+Alltrim(MV_PAR06)+"' " 
	EndIf

	exit
enddo
Return(cFiltro)