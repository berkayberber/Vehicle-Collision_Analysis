
--use VehicleandWeather;
-- Create the table
DROP TABLE IF EXISTS dbo.dimCrashTime
CREATE TABLE dbo.dimCrashTime (
    TimeID INT Identity(1,1)PRIMARY KEY,
    CrashTime VARCHAR(5) NOT NULL, 
    [Hour] INT NOT NULL,
    [Minute] INT NOT NULL,
    isDay TINYINT NOT NULL,
    isNight TINYINT NOT NULL
);

-- Declare the variables for looping through hours and minutes
DECLARE @Hour INT = 0;
DECLARE @Minute INT = 0;
DECLARE @TimeID INT;
DECLARE @CrashTime VARCHAR(5);

-- Loop through each hour of the day
WHILE @Hour < 24
BEGIN
    -- Loop through each minute of the hour
    WHILE @Minute < 60
    BEGIN
        -- Format TimeID as HHMM with leading zeros
        SET @TimeID = CAST(RIGHT('0' + CAST(@Hour AS VARCHAR(2)), 2) + RIGHT('0' + CAST(@Minute AS VARCHAR(2)), 2) AS INT);

        -- Format CrashTime as HH:MM with leading zeros
        SET @CrashTime = RIGHT('0' + CAST(@Hour AS VARCHAR(2)), 2) + ':' + RIGHT('0' + CAST(@Minute AS VARCHAR(2)), 2);

        -- Determine if it is day (6 AM to 6 PM) or night (6 PM to 6 AM)
        IF @Hour >= 6 AND @Hour < 18
        BEGIN
            INSERT INTO dbo.dimCrashTime ( CrashTime, [Hour], [Minute], isDay, isNight)
            VALUES ( @CrashTime, @Hour, @Minute, 1, 0);
        END
        ELSE
        BEGIN
            INSERT INTO dbo.dimCrashTime ( CrashTime, [Hour], [Minute], isDay, isNight)
            VALUES ( @CrashTime, @Hour, @Minute, 0, 1);
        END

        -- Increment the minute
        SET @Minute = @Minute + 1;
    END

    -- Reset the minute and increment the hour
    SET @Minute = 0;
    SET @Hour = @Hour + 1;
END;
SELECT * FROM dbo.dimCrashTime



--crashdate

DROP TABLE IF EXISTS dbo.dimCrashDate
CREATE TABLE dbo.dimCrashDate (
    DateID INT PRIMARY KEY,
    CrashDate DATE,
    TheDay INT,
    TheDayName NVARCHAR(50),
    TheMonthName NVARCHAR(50),
    TheYear INT
);
-- Declare the variables for looping through the dates
DECLARE @StartDate DATE = '2016-01-01';
DECLARE @EndDate DATE = '2019-12-31';
DECLARE @CurrentDate DATE = @StartDate;

-- Loop through each date from the start date to the end date
WHILE @CurrentDate <= @EndDate
BEGIN
    INSERT INTO dbo.dimCrashDate (
        DateID,
        CrashDate,
        TheDay,
        TheDayName,
        TheMonthName,
        TheYear
    )
    VALUES (
        CAST(CONVERT(VARCHAR, @CurrentDate, 112) AS INT), -- Convert date to YYYYMMDD format
        @CurrentDate,
        DAY(@CurrentDate),
        DATENAME(WEEKDAY, @CurrentDate),
        DATENAME(MONTH, @CurrentDate),
        YEAR(@CurrentDate)
    );

    -- Increment the date
    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END;



