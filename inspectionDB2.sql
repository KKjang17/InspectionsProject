CREATE DATABASE InspectionDB;

CREATE TABLE Location(
	LocationID int NOT NULL PRIMARY KEY,
	Borough varchar(20),
	BuildingNumber nvarchar(55),
	Street nvarchar(100),
	Zipcode nvarchar(15),
	Latitude float,
	Longitude float
);

CREATE TABLE Restaurant(
	RestaurantID int NOT NULL PRIMARY KEY,
	LocationID int NOT NULL FOREIGN KEY REFERENCES Location(LocationID),
	RestaurantName nvarchar(100),
	CuisineDescription nvarchar(50)
);

CREATE TABLE Inspection(
	InspectionID int NOT NULL PRIMARY KEY,
	RestaurantID int NOT NULL FOREIGN KEY REFERENCES Restaurant(RestaurantID),
	Score int,
	Grade varchar(5),
	InspectionDate date,
	ActionType nvarchar(150),
	InspectionType varchar(100)
);

CREATE TABLE Violation(
	ViolationID int NOT NULL PRIMARY KEY,
	ViolationCode varchar(10),
	ViolationDescription nvarchar(355)
);

--Creating the last table
CREATE TABLE InspectionDetails(
	InspectionID int NOT NULL,
	ViolationID int NOT NULL,
	CriticalFlag varchar(20),
	PRIMARY KEY (InspectionID, ViolationID)
);

ALTER TABLE InspectionDetails
ADD FOREIGN KEY (InspectionID) REFERENCES Inspection(InspectionID);

ALTER TABLE InspectionDetails
ADD FOREIGN KEY (ViolationID) REFERENCES Violation(ViolationID);

--Transfering the rest of the data.
BULK INSERT	Location
FROM 'C:\Users\Kayden\CSV\LocationTable.csv'
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);

BULK INSERT	Violation
FROM 'C:\Users\Kayden\CSV\ViolationTable.csv'
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);

BULK INSERT	Restaurant
FROM 'C:\Users\Kayden\CSV\RestaurantTable.csv'
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);

BULK INSERT	Inspection
FROM 'C:\Users\Kayden\CSV\InspectionTable.csv'
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);

BULK INSERT	InspectionDetails
FROM 'C:\Users\Kayden\CSV\InspecDetailsTable.csv'
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
);

SELECT
	RestaurantName,
	CuisineDescription,
	Location.Borough,
	Inspection.Score,
	Inspection.Grade,
	Inspection.InspectionDate,
	Inspection.InspectionType,
	Location.Latitude,
	Location.Longitude
FROM Restaurant
Join Inspection 
on Restaurant.RestaurantID = Inspection.RestaurantID
Join Location 
on Restaurant.LocationID = Location.LocationID;