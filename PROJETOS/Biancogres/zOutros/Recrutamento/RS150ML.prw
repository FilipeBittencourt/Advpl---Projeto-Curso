/*---------+-----------+-------+----------------------+------+------------+
|Funcao    |RS150ML    | Autor | Marcelo Sousa        | Data | 31.07.2018 |
|          |           |       | Facile Sistemas      |      |            |
+----------+-----------+-------+----------------------+------+------------+
|Descricao |PONTO DE ENTRADA UTILIZADO PARA INFORMAR QUAL SER� A FUNCAO   |
|          |DE ENVIO PARA OS E-MAILS NA TELA DE AGENDA. 			      |
+----------+--------------------------------------------------------------+
|Uso       |RECRUTAMENTO E SELE��O                                        |
+----------+-------------------------------------------------------------*/
#include 'protheus.ch'
#include 'parmtype.ch'

user function RS150ML()
	
	S4WB005N := U_BIAFM003()

Return S4WB005N