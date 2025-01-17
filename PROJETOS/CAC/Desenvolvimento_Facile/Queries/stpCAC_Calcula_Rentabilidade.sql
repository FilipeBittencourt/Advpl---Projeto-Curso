USE [P11]
GO
/****** Object:  StoredProcedure [dbo].[stpCAC_Calcula_Rentabilidade]    Script Date: 08/05/2015 13:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[stpCAC_Calcula_Rentabilidade](@Cli_De varchar(6), @Cli_Ate varchar(6), @Dt_De Varchar(8), @Dt_Ate Varchar(8))
As Begin

DECLARE @VL_CUSTO FLOAT,
		@Dt_Emissao Varchar(8),
		@Cd_Produto Varchar(15)

IF OBJECT_ID('TEMPDB.DBO.#NOTAS') IS NOT NULL DROP TABLE #NOTAS			--Caso seja necess�rio Rodar Na M�o
IF OBJECT_ID('TEMPDB.DBO.#PRODUTOS') IS NOT NULL DROP TABLE #PRODUTOS	--Caso seja necess�rio Rodar Na M�o

SELECT D2_DOC, 
		D2_SERIE,
		D2_EMISSAO, 
		D2_CLIENTE, 
		A1_NOME, 
		D2_LOJA, 
		D2_COD, 
		D2_QUANT - D2_QTDEDEV AS D2_QUANT, 
		D2_TOTAL, 
		D2_CUSTO1 CUSUNI,
		CAST(0 AS FLOAT) CUSTOT 
	INTO #NOTAS
	FROM SD2010 A
		JOIN SA1010 B
			ON A.D2_CLIENTE = B.A1_COD
				AND A.D2_LOJA = B.A1_LOJA
				AND B.D_E_L_E_T_ = ''
	WHERE D2_TIPO <> 'D' 
			AND D2_NFORI = ''
			AND D2_EMISSAO BETWEEN  @DT_DE AND @DT_ATE 
			AND SUBSTRING(D2_COD,1,1) = '3' 
			AND A.D_E_L_E_T_ = ''
			AND D2_QUANT - D2_QTDEDEV > 0
			AND D2_TES IN (Select F4_CODIGO from SF4010 where F4_CODIGO >= '500' and F4_ESTOQUE = 'S' and D_E_L_E_T_ = '')

SELECT DISTINCT D2_COD, 
				D2_EMISSAO, 
				0 AS PROCESS
	INTO #PRODUTOS
	FROM #NOTAS


WHILE EXISTS( SELECT 1 FROM #PRODUTOS WHERE PROCESS = 0)
	BEGIN
		
		SELECT @CD_PRODUTO = D2_COD, @DT_EMISSAO = D2_EMISSAO  FROM #PRODUTOS WHERE PROCESS = 0

		SELECT TOP 1 @VL_CUSTO = ISNULL(D1_VUNIT,0)
			FROM SD1010 A
				WHERE A.D1_TIPO  <> 'D' 
				AND A.D1_NFORI = ''
				AND A.D_E_L_E_T_ = ''
				AND A.D1_COD = @CD_PRODUTO
				AND A.D1_DTDIGIT <= @DT_EMISSAO
				AND A.D1_QUANT - D1_QTDEDEV > 0
				AND D1_TES IN (Select F4_CODIGO from SF4010 where F4_CODIGO >= '500' and F4_ESTOQUE = 'S' and D_E_L_E_T_ = '')
		ORDER BY D1_DTDIGIT DESC

		UPDATE #NOTAS 
			SET CUSUNI = @VL_CUSTO
		WHERE D2_COD = @CD_PRODUTO 
		AND D2_EMISSAO = @DT_EMISSAO
		AND @VL_CUSTO <> 0
		AND CUSUNI = 0

		UPDATE #PRODUTOS 
			SET PROCESS = 1
		WHERE D2_COD = @CD_PRODUTO
			AND D2_EMISSAO = @DT_EMISSAO

		SET @VL_CUSTO = 0
		

	END

UPDATE #NOTAS 
	SET CUSTOT = D2_QUANT * CUSUNI


SELECT D2_DOC AS DOC ,
		D2_SERIE AS SERIE,
		D2_EMISSAO AS EMISSAO,
		D2_CLIENTE AS CODCLI,
		A1_NOME AS NOMCLI,
		D2_LOJA AS LOJA,
		SUM(D2_TOTAL) AS TOTVEN,
		SUM(CUSTOT) AS TOTCUS
FROM #NOTAS
GROUP BY D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE, A1_NOME, D2_LOJA

END