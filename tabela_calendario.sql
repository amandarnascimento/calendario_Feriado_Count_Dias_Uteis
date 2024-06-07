SET LANGUAGE Portuguese;

CREATE TABLE D_CALENDARIO (
    [ID] INT IDENTITY(1, 1) PRIMARY KEY,
    [DATA] DATE,
    [DATA_BR] AS (CONVERT(varchar(10), [DATA], 103)),
    [DIA] AS (DATEPART(DAY, [DATA])),
    [TRI_NUM] AS (DATEPART(QUARTER, [DATA])),
    [TRIMESTRE] AS CASE
                        WHEN (DATEPART(QUARTER, [DATA])) = 1 THEN '1o Trimestre'
                        WHEN (DATEPART(QUARTER, [DATA])) = 2 THEN '2o Trimestre'
                        WHEN (DATEPART(QUARTER, [DATA])) = 3 THEN '3o Trimestre'
                        WHEN (DATEPART(QUARTER, [DATA])) = 4 THEN '4o Trimestre' END,
    [QUADRIMESTRE] AS CASE
                          WHEN (DATEPART(MONTH, [DATA])) BETWEEN 1 AND 4 THEN '1o Quadrimestre'
                          WHEN (DATEPART(MONTH, [DATA])) BETWEEN 5 AND 8 THEN '2o Quadrimestre'
                          WHEN (DATEPART(MONTH, [DATA])) BETWEEN 9 AND 12 THEN '3o Quadrimestre' END,
    [QUINZENA] AS CASE
                       WHEN DATEPART(DAY, [DATA]) > 15 THEN '2a Quinzena'
                       ELSE '1a Quinzena' END,
    [SEMESTRE] AS CASE
                       WHEN DATEPART(QUARTER, [DATA]) <= 2 THEN '1o Semestre'
                       ELSE '2o Semestre' END,
    [SEM_NUM] AS CASE
                      WHEN DATEPART(QUARTER, [DATA]) <= 2 THEN 1
                      ELSE 2 END,
    [DIA_SEMANA] AS (DATENAME(WEEKDAY, [DATA])),
    [ANO] AS (DATEPART(YEAR, [DATA])),
    [MES_NUM] AS (DATEPART(MONTH, [DATA])),
    [MES_EXTENSO] AS CASE
                          WHEN (DATEPART(MONTH, [DATA])) = 1 THEN 'Janeiro'
                          WHEN (DATEPART(MONTH, [DATA])) = 2 THEN 'Fevereiro'
                          WHEN (DATEPART(MONTH, [DATA])) = 3 THEN 'Março'
                          WHEN (DATEPART(MONTH, [DATA])) = 4 THEN 'Abril'
                          WHEN (DATEPART(MONTH, [DATA])) = 5 THEN 'Maio'
                          WHEN (DATEPART(MONTH, [DATA])) = 6 THEN 'Junho'
                          WHEN (DATEPART(MONTH, [DATA])) = 7 THEN 'Julho'
                          WHEN (DATEPART(MONTH, [DATA])) = 8 THEN 'Agosto'
                          WHEN (DATEPART(MONTH, [DATA])) = 9 THEN 'Setembro'
                          WHEN (DATEPART(MONTH, [DATA])) = 10 THEN 'Outubro'
                          WHEN (DATEPART(MONTH, [DATA])) = 11 THEN 'Novembro'
                          WHEN (DATEPART(MONTH, [DATA])) = 12 THEN 'Dezembro' END,
    [MES_ANO_FN] AS CASE
                         WHEN (DATEPART(MONTH, [DATA])) = 1 THEN 'Jan.' + CAST(DATEPART(YEAR, [DATA]) AS VARCHAR)
                         WHEN (DATEPART(MONTH, [DATA])) = 2 THEN 'Fev.' + CAST(DATEPART(YEAR, [DATA]) AS VARCHAR)
                         WHEN (DATEPART(MONTH, [DATA])) = 3 THEN 'Mar.' + CAST(DATEPART(YEAR, [DATA]) AS VARCHAR)
                         WHEN (DATEPART(MONTH, [DATA])) = 4 THEN 'Abr.' + CAST(DATEPART(YEAR, [DATA]) AS VARCHAR)
                         WHEN (DATEPART(MONTH, [DATA])) = 5 THEN 'Mai.' + CAST(DATEPART(YEAR, [DATA]) AS VARCHAR)
                         WHEN (DATEPART(MONTH, [DATA])) = 6 THEN 'Jun.' + CAST(DATEPART(YEAR, [DATA]) AS VARCHAR)
                         WHEN (DATEPART(MONTH, [DATA])) = 7 THEN 'Jul.' + CAST(DATEPART(YEAR, [DATA]) AS VARCHAR)
                         WHEN (DATEPART(MONTH, [DATA])) = 8 THEN 'Ago.' + CAST(DATEPART(YEAR, [DATA]) AS VARCHAR)
                         WHEN (DATEPART(MONTH, [DATA])) = 9 THEN 'Set.' + CAST(DATEPART(YEAR, [DATA]) AS VARCHAR)
                         WHEN (DATEPART(MONTH, [DATA])) = 10 THEN 'Out.' + CAST(DATEPART(YEAR, [DATA]) AS VARCHAR)
                         WHEN (DATEPART(MONTH, [DATA])) = 11 THEN 'Nov.' + CAST(DATEPART(YEAR, [DATA]) AS VARCHAR)
                         WHEN (DATEPART(MONTH, [DATA])) = 12 THEN 'Dez.' + CAST(DATEPART(YEAR, [DATA]) AS VARCHAR)END,
    [MES_ANO] AS FORMAT([DATA], 'MM.yyyy'),
    [SegASex] AS CASE
                     WHEN DATENAME(WEEKDAY, [DATA]) IN ('sábado', 'domingo') THEN 0
                     ELSE 1
                 END
);

DECLARE @DataInicio DATE,
        @DataFim    DATE;

-- Definindo as datas no formato correto
SET @DataInicio = '2020-12-31';
SET @DataFim = '2026-12-31';

TRUNCATE TABLE D_CALENDARIO;

WHILE @DataInicio <= @DataFim
BEGIN
    INSERT INTO D_CALENDARIO ([DATA])
    VALUES (@DataInicio);
    SET @DataInicio = DATEADD(DAY, 1, @DataInicio);
END

-- Adicionando a coluna Feriado
ALTER TABLE D_CALENDARIO ADD [Feriado] BIT;

-- Atualizando a coluna Feriado com base na tabela feriados
UPDATE D_CALENDARIO
SET [Feriado] = CASE
                    WHEN EXISTS (SELECT 1 FROM feriados WHERE feriados.FeriadoData = D_CALENDARIO.DATA) THEN 1
                    ELSE 0
                END;

SELECT *
  FROM D_CALENDARIO;
