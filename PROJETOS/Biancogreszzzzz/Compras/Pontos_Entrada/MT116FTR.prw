#include "rwmake.ch"

//---------------------------------------------------------------------------------------------
// Autor: Carlos Junqueira
// Data : 01/12/14
// Desc : 
//---------------------------------------------------------------------------------------------
// Este ponto de entrada pertence a rotina de digita��o de conhecimento de frete, MATA116(). 
// Atua como filtro para sele��o das notas de entrada.
//--------------------------------------------------------------------------------------------- 

User Function MT116FTR()// CARLOS JUNQUEIRA  26/03/2015

	Local cFiltro := ""      
    
    cFiltro := '  .And. SF1->F1_STATUS == "A" '

Return cFiltro
//---------------------------------------------------------------------------------------------
