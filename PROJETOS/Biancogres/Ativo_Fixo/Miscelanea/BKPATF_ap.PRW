#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 13/08/04

User Function BKPATF()        // incluido pelo assistente de conversao do AP6 IDE em 13/08/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("WARQ,WDIR,CSAY2,WRET,WQTD,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿍kpAtf    � Autor 쿒ustav Koblinger Junior� Data � 01.08.00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿽escri뇙o 쿒era Backup dos Arquivos do Ativo Fixo de SQL para DBF      낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/  
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Exibe janela com descritivo do programa                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wArq      := ""
PRIVATE wDir      := "\P10\BKPATF\"+Space(20)
cSay2     := "Diretorio     "
wRet      := .T.
While wRet
   @ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Backup do Arquivos SQL em DBF"
   @ 8,10 TO 84,222
   
   @ 22,15 SAY cSay2               Object oLabel2
   @ 22,58 GET wDir                pict "@!"

   @ 91,166 BMPBUTTON TYPE 1 ACTION RunProc()// Substituido pelo assistente de conversao do AP6 IDE em 13/08/04 ==>    @ 91,166 BMPBUTTON TYPE 1 ACTION Execute(RunProc)
   @ 91,195 BMPBUTTON TYPE 2 ACTION ClsProc()// Substituido pelo assistente de conversao do AP6 IDE em 13/08/04 ==>    @ 91,195 BMPBUTTON TYPE 2 ACTION Execute(ClsProc)
   ACTIVATE DIALOG oDlg5 CENTERED
End
//Close(oDlg5)
Return
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿎lsProc   � Autor 쿒ustav Koblinger Junior� Data � 15.02.96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿎onfirma o Processamento                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/  
// Substituido pelo assistente de conversao do AP6 IDE em 13/08/04 ==> Function ClsProc
Static Function ClsProc()
wRet := .F.
Close(oDlg5)
Return
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿝unProc   � Autor � Ary Medeiros          � Data � 15.02.96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿐xecuta o Processamento                                     낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/  
// Substituido pelo assistente de conversao do AP6 IDE em 13/08/04 ==> Function RunProc
Static Function RunProc()
Processa( {|| Back() } )// Substituido pelo assistente de conversao do AP6 IDE em 13/08/04 ==> Processa( {|| Execute(Back) } )
wRet := .F.
Close(oDlg5)
Return

// Substituido pelo assistente de conversao do AP6 IDE em 13/08/04 ==> Function Back
Static Function Back()

dbselectarea("SX2")
wQtd := LastRec()//Reccount()
ProcRegua(wQtd)
dbGoTop()

While !eof() 
	IF ALLTRIM(substr(SX2->X2_CHAVE,1,2)) = "SN"
		IncProc("Copiando " + SX2->X2_CHAVE + "-" + SX2->X2_NOME)
		dbselectarea(SX2->X2_CHAVE)
		If  Subst(Alias(),1,2) == "SN" .and. RecCount() <> 0
			wArq := Alltrim(wDir) + Alltrim(SX2->X2_ARQUIVO) + ".dbf"
			copy to &wArq //SDF
		End
		(SX2->X2_CHAVE)->(dbclosearea())
		dbselectarea("SX2")
	END IF
	dbSkip()
End

Return
