use VehicleandWeather;
GO


CREATE PROCEDURE dbo.spInsertFactCollision
AS
/*
		This store procedure is designed to populate factcollision table it have checks 
		to insert only those data that are not present already in factcollision table
	 dbo.spInsertFactCollision

*/
BEGIN 

	--Getting all vehicle collisions records from stage into #VehicleCollisionStaging
	
	IF OBJECT_ID ('tempdb..#VehicleCollisionStaging','U') IS NOT NULL
		DROP TABLE #VehicleCollisionStaging

	SELECT * 
	INTO	#VehicleCollisionStaging
	FROM	[stg].[VehicleCollisionStaging]

	CREATE ColumnStore INDEX TempCollision
    ON #VehicleCollisionStaging
    ([CRASHDATE],[CRASHTIME], [BOROUGH],[ZIPCODE], [ONSTREETNAME],[CROSSSTREETNAME], [OFFSTREETNAME],
     [NUMBEROFPERSONSINJURED],[NUMBEROFPEDESTRIANSINJURED], [NUMBEROFPEDESTRIANSKILLED], [NUMBEROFCYCLISTINJURED],
     [NUMBEROFCYCLISTKILLED], [NUMBEROFMOTORISTINJURED], [NUMBEROFMOTORISTKILLED],
     [CONTRIBUTINGFACTORVEHICLE1],[VEHICLETYPECODE1]
    )

	--Getting all vehicle collisions records to populate  FactCollision
	
	IF OBJECT_ID ('tempdb..#COllisions','U') IS NOT NULL
		DROP TABLE #COllisions

	SELECT   NEWID() UNID,
			 CD.[DateID]
			,CT.[TimeID]
			,DL.[LocationID]
			,DV.[VehicleTypeID]
			,DW.[weatherID]
			,C.[NUMBEROFPERSONSINJURED]    AS [InjuredPerson]
			,C.[NUMBEROFPERSONSKILLED]	   AS [KilledPerson]
			,C.[NUMBEROFPEDESTRIANSINJURED]AS [PedestriansInjured]
			,C.[NUMBEROFPEDESTRIANSKILLED] AS [PedestriansKilled]
			,C.[NUMBEROFCYCLISTINJURED]	   AS [CyclistInjured]
			,C.[NUMBEROFCYCLISTKILLED]	   AS [CyclistKilled]
			,C.[NUMBEROFMOTORISTINJURED]   AS [MotoristInjured]
			,C.[NUMBEROFMOTORISTKILLED]	   AS [MotoristKilled]
	INTO #COllisions
	FROM #VehicleCollisionStaging C
	JOIN [stg].[WeatherStaging] W WITH(NOLOCK) ON CONVERT(DATE,C.Crashdate)= CASE	WHEN CHARINDEX('-', Datetime) = 5 -- yyyy-MM-dd format
																						 THEN CAST(Datetime AS DATE)
																					WHEN CHARINDEX('-', Datetime) = 3 -- dd-MM-yyyy format
																						THEN CAST(SUBSTRING(Datetime, 7, 4) + '-' + 
																									SUBSTRING(Datetime, 4, 2) + '-' + 
																									SUBSTRING(Datetime, 1, 2) AS DATE) END
	JOIN dbo.DimWeather DW WITH(NOLOCK) ON DW.[MaxTemperature]		= W.[tempmax] 
												AND DW.[MinTemperature] = W.[tempmin] 
												AND DW.[humidity]		= W.[humidity] 
												AND DW.[windspeed]		= W.[windspeed] 
												AND DW.[visibility]		= W.[visibility] 
												AND DW.[description]	= W.[description]

	JOIN dbo.DimLocation DL WITH(NOLOCK) ON	CONVERT(VARCHAR(50),DL.[borough])= CONVERT(VARCHAR(50),C.[BOROUGH])
										AND CONVERT(VARCHAR(50),DL.[zipcode])=	CONVERT(VARCHAR(50),C.[ZIPCODE])
										AND (REPLACE (Dl.[ONSTREETNAME]+ DL.[CROSSSTREETNAME]+DL.[OFFSTREETNAME] ,'Unknown','')=
											 REPLACE (C.[ONSTREETNAME]+ C.[CROSSSTREETNAME]+C.[OFFSTREETNAME] ,'Unknown','')
											 )
	JOIN [dbo].[DimVehicleType] DV WITH(NOLOCK) ON  DV.[VehicleType]			= C.[VEHICLETYPECODE1] 
												AND DV.[ContributingFactortype] = C.[CONTRIBUTINGFACTORVEHICLE1]
	JOIN dbo.DImCrashdate		CD WITH(NOLOCK) ON	CONVERT(DATE,CD.Crashdate)	= CONVERT(DATE,C.Crashdate)
	JOIN dbo.DimCrashtime		CT WITH(NOLOCK) ON	CONVERT(TIME(0),CT.CrashTime)		= CONVERT(TIME(0),C.[CRASHTIME])
	
	GROUP BY  CD.[DateID]
			 ,CT.[TimeID]
			 ,DL.[LocationID]
			 ,DV.[VehicleTypeID]
			 ,DW.[WeatherID]
			  ,C.[NUMBEROFPERSONSINJURED]	 
			  ,C.[NUMBEROFPERSONSKILLED]	 
			  ,C.[NUMBEROFPEDESTRIANSINJURED]
			  ,C.[NUMBEROFPEDESTRIANSKILLED] 
			  ,C.[NUMBEROFCYCLISTINJURED]	 
			  ,C.[NUMBEROFCYCLISTKILLED]	 
			  ,C.[NUMBEROFMOTORISTINJURED]   
			  ,C.[NUMBEROFMOTORISTKILLED]
	
	--Getting only those records that are not present already in FactCollision

	IF OBJECT_ID ('tempdb..#INsertCollision','U') IS NOT NULL
		DROP TABLE #INsertCollision


	SELECT		C.UNID,
				C.[DateID],C.[TimeID],C.[LocationID],C.[VehicleTypeID],C.[WeatherID],
				C.[InjuredPerson],C.[KilledPerson],C.[PedestriansInjured],C.[PedestriansKilled],
				C.[CyclistInjured],C.[CyclistKilled],C.[MotoristInjured],C.[MotoristKilled]	
	INTO #INsertCollision
	FROM #Collisions C
	LEFT JOIN dbo.FactCollisions  FC ON FC. [CrashDateID] 			= C.[DateID]
										AND FC.[CrashTimeID]		= C.[TimeID]
										AND FC.[LocationID]			= C.[LocationID]
										AND FC.[VehicleTypeID]		= C.[VehicleTypeID]
										AND FC.[WeatherID]			= C.[WeatherID]
										AND FC.[InjuredPerson]		= C.[InjuredPerson]		
										AND FC.[KilledPerson]		= C.[KilledPerson]		
										AND FC.[PedestriansInjured]	= C.[PedestriansInjured]	
										AND FC.[PedestriansKilled]	= C.[PedestriansKilled]	
										AND FC.[CyclistInjured]		= C.[CyclistInjured]		
										AND FC.[CyclistKilled]		= C.[CyclistKilled]		
										AND FC.[MotoristInjured]	= C.[MotoristInjured]	
										AND FC.[MotoristKilled]		= C.[MotoristKilled]		

	WHERE FC.[CrashDateID] IS NULL
	
	CREATE COLUMNSTORE INDEX CollisionCus ON #Collisions([DateID],[TimeID],[LocationID],[VehicleTypeID],[WeatherID],
				[InjuredPerson],[KilledPerson],[PedestriansInjured],[PedestriansKilled],
				[CyclistInjured],[CyclistKilled],[MotoristInjured],[MotoristKilled]	)
	CREATE CLUSTERED INDEX Cltr ON  #Collisions(UNID)

	--INSERT in batch of 50000 FactCollision
	
	--SELECT COUNT(*) FROM #Collisions
	DECLARE @i INT = 0;
    DECLARE @batchSize INT = 10000;
    DECLARE @totalCount INT;
	SELECT  @totalCount = COUNT(1)FROM #Collisions

	WHILE (@i < @totalCount)
	BEGIN 
		Print 'Batch Starts'
		
		INSERT INTO [dbo].[FactCollisions]([CrashDateID], [CrashTimeID], [LocationID], [VehicleTypeID], [WeatherID]
											, [InjuredPerson], [KilledPerson], [PedestriansInjured]
											, [PedestriansKilled], [CyclistInjured]
											, [CyclistKilled], [MotoristInjured], [MotoristKilled])
		SELECT	 
				C.[DateID],C.[TimeID],C.[LocationID],C.[VehicleTypeID],C.[WeatherID],
				C.[InjuredPerson],C.[KilledPerson],C.[PedestriansInjured],C.[PedestriansKilled],
				C.[CyclistInjured],C.[CyclistKilled],C.[MotoristInjured],C.[MotoristKilled]	
		FROM #INsertCollision C
		ORDER BY UNID
		OFFSET @i ROWS
		FETCH NEXT @batchSize ROWS ONLY
							
        SET @i = @i + @batchSize;
		--Print'Batch End '
		--PRINT @i PRINT @batchSize

	END --End of While loop

END --End of procedure 
