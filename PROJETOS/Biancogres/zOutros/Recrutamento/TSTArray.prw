#include 'protheus.ch'
#include 'parmtype.ch'

//U_TSTArray FOR
User Function TSTArray()

	Local aFruta  := {} //Array dimensional
	Local aNome   := {} //Array dimensional
	Local nI := 0

	// add dados
	aFruta := {"Banana","Pera",100.37,"100.37",".T.",.T.}

	AADD(aNome,"Filipe")
	AADD(aNome,"Jo�o")
	AADD(aNome,"Leonardo")
	AADD(aNome,"Gielardi")

	//saber o tamanho do array  use a fun��o Len()
//	alert("O array de aFruta possui um tamanho de: "+cValToChar(Len(aFruta))+" posi��es." )
//	alert("O array de aNome  possui um tamanho de: "+cValToChar(Len(aNome))+" posi��es." )

	"USANDO o FOR O array NOMEARRAY possui um tamanho de: XXXX posi��es
	na posi��o 1 tem : XXXX
	na posi��o 2 tem : XXXX
	......
	alert()


Return .T.


/*

	/////////// especiais

	AADD(aAluno,"Filipe")
	AADD(aAluno,"Rua um dois 3 ,Casa 04,2987874-690 , Laranjeiras")
	AADD(aAluno,{"PORTUGUES","MATEMATICA","HISTORIA"})

	AADD(aEscola, aAluno)

	aAluno := {}
	AADD(aAluno,"leonardo")
	AADD(aAluno,"Rua um dois 3 ,Casa 05,2987874-690 , Laranjeiras")
	AADD(aAluno,{"PORTUGUES","MATEMATICA","HISTORIA"})

	AADD(aEscola, aAluno)

	aAluno := {}

	*/