--use VehicleandWeather;
--CREATE SCHEMA stg;
--STG Tables

CREATE TABLE stg.WeatherStaging 
(
    name	VARCHAR(512),
    datetime	VARCHAR(512),
    tempmax	DECIMAL(10,2),
    tempmin	DECIMAL(10,2),
    humidity	INT,
    windspeed	DECIMAL(10,2),
    visibility	INT,
    description	VARCHAR(512)
);

CREATE TABLE stg.VehicleCollisionStaging 
(
    CRASHDATE	VARCHAR(512),
    CRASHTIME	VARCHAR(512),
    BOROUGH	VARCHAR(512),
    ZIPCODE	INT,
    ONSTREETNAME	VARCHAR(512),
    CROSSSTREETNAME	VARCHAR(512),
    OFFSTREETNAME	VARCHAR(512),
    NUMBEROFPERSONSINJURED	INT,
	NUMBEROFPERSONSKILLED	INT,
	NUMBEROFPEDESTRIANSINJURED	INT,
	NUMBEROFPEDESTRIANSKILLED	INT,
	NUMBEROFCYCLISTINJURED	INT,
	NUMBEROFCYCLISTKILLED	INT,
	NUMBEROFMOTORISTINJURED	INT,
	NUMBEROFMOTORISTKILLED	INT,
	CONTRIBUTINGFACTORVEHICLE1	VARCHAR(512),
	VEHICLETYPECODE1	VARCHAR(512)
);
--Dimension

CREATE TABLE dbo.DimWeather (
    weatherID INT IDENTITY(1,1) PRIMARY KEY,
    MaxTemperature NUMERIC(10,2) NOT NULL,
    MinTemperature NUMERIC(10,2) NOT NULL,
    humidity NUMERIC(10,2) NOT NULL,
    windspeed NUMERIC(10,2) NOT NULL,
    visibility NUMERIC(10,2) NOT NULL,
    [description] VARCHAR(255) NOT NULL
);

CREATE TABLE DimLocation (
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
    borough VARCHAR(50) NOT NULL,
    zipcode VARCHAR(10) NOT NULL,
    onstreetname VARCHAR(100) NOT NULL,
    offstreetname VARCHAR(100) NOT NULL,
    crossstreetname VARCHAR(100) NOT NULL
);


CREATE TABLE dimVehicleType (
    VehicleTypeID INT IDENTITY(1,1) PRIMARY KEY,
    VehicleType VARCHAR(50) NOT NULL,
    ContributingFactortype VARCHAR(50) NOT NULL
)

CREATE TABLE dbo.FactCollisions (
    CollisionID INT IDENTITY(1,1) PRIMARY KEY,
    CrashDateID INT NOT NULL,
    CrashTimeID INT NOT NULL,
    LocationID INT NOT NULL,
    VehicleTypeID INT NOT NULL,
    WeatherID INT NOT NULL,
    InjuredPerson SMALLINT NOT NULL,
    KilledPerson SMALLINT NOT NULL,
    PedestriansInjured SMALLINT NOT NULL,
    PedestriansKilled SMALLINT NOT NULL,
    CyclistInjured SMALLINT NOT NULL,
    CyclistKilled SMALLINT NOT NULL,
    MotoristInjured SMALLINT NOT NULL,
    MotoristKilled SMALLINT NOT NULL,
    FOREIGN KEY (CrashDateID) REFERENCES dimCrashDate(DateID),
    FOREIGN KEY (CrashTimeID) REFERENCES dimCrashTime([TimeID]),
    FOREIGN KEY (LocationID) REFERENCES dimLocation(LocationID),
    FOREIGN KEY (VehicleTypeID) REFERENCES dimVehicleType(VehicleTypeID),
    FOREIGN KEY (WeatherID) REFERENCES DimWeather(weatherID)
);















