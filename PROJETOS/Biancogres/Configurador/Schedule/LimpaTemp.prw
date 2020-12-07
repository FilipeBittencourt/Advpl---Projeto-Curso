#INCLUDE "FILEIO.CH"

User Function LimpaTemp()

	RPCSetType(3)
	RPCSetEnv("01", "01")
		
	ConOut("Iniciando limpeza dos arquivos tempor�rios " + time())

	DelArqTmp()

	LimpaCob()

	ConOut("Terminado limpeza dos arquivos tempor�rios " + time())
	
	RpcClearEnv()

Return

/*----------------- LimpaCob -----------------*/
Static Function LimpaCob()

	Local cPathLog		:= "" 	//GetNewPar("MV_TMKDILG","")							// Indica o diretorio onde sera gravado o arquivo de log
	Local aFiles 	   			//Armazena os arquivos a serem apagados

	ConOut("Limpando arquivos " + time())

	//�����������������������������������Ŀ
	//|Apaga os arquivos do dia anterior  |
	//�������������������������������������
	aFiles := Directory(cPathLog + "*" + dtos(Date()-1) + ".COB")
	AEval(aFiles, {|aFile|fErase(cPathLog + aFile[1])})

	//���������������������������������������������������������������������Ŀ
	//|Apaga os arquivos do mes anterior, garantindo que nao sobre arquivos |
	//�����������������������������������������������������������������������
	aFiles := Directory(cPathLog + "*" + SubStr(dtos(Date()-1),1,6) + "??.COB")
	AEval(aFiles, {|aFile|fErase(cPathLog + aFile[1])})

	//��������������������������������������������Ŀ
	//�Apaga os arquivos de rejeicao dos operadores�
	//����������������������������������������������
	aFiles := Directory(cPathLog + "rej*.COB")
	AEval(aFiles, {|aFile|fErase(cPathLog + aFile[1])})

	// ===>   Apaga os arquivos de wf*.ctl que n�o s�o apagados pela rotina padr�o.
	*******************************************************************************
	aFiles := Directory(cPathLog + "wf*.ctl")
	AEval(aFiles, {|aFile|FErase(cPathLog + aFile[1])})

	// ===>     Apaga os arquivos de *.mem que n�o s�o apagados pela rotina padr�o.
	*******************************************************************************
	aFiles := Directory(cPathLog + "*.mem")
	AEval(aFiles, {|aFile|FErase(cPathLog + aFile[1])})

	// ===>   Apaga os arquivos de sc*.txt que n�o s�o apagados pela rotina padr�o.
	*******************************************************************************
	aFiles := Directory(cPathLog + "sc*.txt")
	AEval(aFiles, {|aFile|FErase(cPathLog + aFile[1])})

	// ===>     Apaga os arquivos de *.tmp que n�o s�o apagados pela rotina padr�o.
	*******************************************************************************
	aFiles := Directory(cPathLog + "*.tmp")
	AEval(aFiles, {|aFile|FErase(cPathLog + aFile[1])})

	// ===>     Apaga os arquivos de *.log que n�o s�o apagados pela rotina padr�o.
	*******************************************************************************
	aFiles := Directory(cPathLog + "*.log")
	AEval(aFiles, {|aFile|FErase(cPathLog + aFile[1])})

	// ===>   Apaga os arquivos de sc*.001 que n�o s�o apagados pela rotina padr�o.
	*******************************************************************************
	aFiles := Directory(cPathLog + "sc*.001")
	AEval(aFiles, {|aFile|FErase(cPathLog + aFile[1])})

	// ===>   Apaga os arquivos de sc*.002 que n�o s�o apagados pela rotina padr�o.
	*******************************************************************************
	aFiles := Directory(cPathLog + "sc*.002")
	AEval(aFiles, {|aFile|FErase(cPathLog + aFile[1])})

	ConOut("Deletados arquivos avulsos " + time())

Return .T.
