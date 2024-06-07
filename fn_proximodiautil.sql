CREATE OR ALTER FUNCTION FuncaoProximoDiaUtil
(
    @Data DATE,
    @DiasUteis INT
)
RETURNS DATE
AS
BEGIN
    DECLARE @ProximaData DATE = @Data;
    DECLARE @Contador INT = 0;

    WHILE @Contador < ABS(@DiasUteis)
    BEGIN
        SET @ProximaData = DATEADD(DAY, SIGN(@DiasUteis), @ProximaData);

        -- Se o próximo dia não for feriado nem final de semana, incrementar o contador
        IF NOT EXISTS (SELECT 1 FROM d_calendario WHERE DATA = @ProximaData AND (Feriado = 1 OR SegASex = 0))
        BEGIN
            SET @Contador = @Contador + 1;
        END
    END

    RETURN @ProximaData;
END
GO
