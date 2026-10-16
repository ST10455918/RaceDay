-- RaceDayDB - PROG6212 Part 1 - Runs clean on SQL Server 2022
IF DB_ID('RaceDayDB') IS NOT NULL DROP DATABASE RaceDayDB;
GO
CREATE DATABASE RaceDayDB;
GO
USE RaceDayDB;
GO

CREATE TABLE AppUser (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Organiser','Participant')),
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Venue (
    VenueId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(150) NOT NULL,
    Address NVARCHAR(300) NOT NULL,
    Latitude DECIMAL(10,7) NULL,
    Longitude DECIMAL(10,7) NULL,
    RouteMapUrl NVARCHAR(500) NULL
);
GO

CREATE TABLE Event (
    EventId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(150) NOT NULL,
    Description NVARCHAR(1000) NULL,
    EventDate DATE NOT NULL,
    VenueId INT NOT NULL FOREIGN KEY REFERENCES Venue(VenueId),
    OrganiserId INT NOT NULL FOREIGN KEY REFERENCES AppUser(UserId),
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Category (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL FOREIGN KEY REFERENCES Event(EventId) ON DELETE CASCADE,
    Name NVARCHAR(50) NOT NULL,
    Distance DECIMAL(5,2) NOT NULL CHECK (Distance > 0),
    EntryFee DECIMAL(10,2) NOT NULL CHECK (EntryFee >= 0),
    MaxCapacity INT NOT NULL CHECK (MaxCapacity > 0),
    CONSTRAINT UQ_Event_Category UNIQUE (EventId, Name)
);
GO

CREATE TABLE Enrolment (
    EnrolmentId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL FOREIGN KEY REFERENCES AppUser(UserId),
    EventId INT NOT NULL FOREIGN KEY REFERENCES Event(EventId),
    CategoryId INT NOT NULL FOREIGN KEY REFERENCES Category(CategoryId),
    EnrolmentDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Registered' CHECK (Status IN ('Registered','Cancelled')),
    CONSTRAINT UQ_User_Event UNIQUE (UserId, EventId)
);
GO

CREATE TABLE Result (
    ResultId INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Enrolment(EnrolmentId) ON DELETE CASCADE,
    FinishTime TIME NOT NULL,
    Position INT NULL CHECK (Position > 0),
    Notes NVARCHAR(500) NULL
);
GO

-- SAMPLE DATA - Meets minimum requirements
INSERT INTO AppUser (Name, Email, PasswordHash, Role) VALUES
('Sarah Organiser','sarah@raceday.co.za','HASHED1','Organiser'),
('David Events','david@raceday.co.za','HASHED2','Organiser'),
('John Runner','john.runner@gmail.com','HASHED3','Participant'),
('Likhaya Oyisi','likhaya@student.com','HASHED4','Participant');

INSERT INTO Venue (Name, Address, Latitude, Longitude, RouteMapUrl) VALUES
('Sea Point Promenade','Beach Rd, Sea Point, Cape Town',-33.9115,18.3866,'https://blob/maps/seapoint.pdf'),
('Green Point Park','Fritz Sonnenberg Rd, Green Point',-33.9056,18.4123,'https://blob/maps/greenpoint.pdf'),
('Company Gardens','Queen Victoria St, Cape Town',-33.9249,18.4241,NULL);

INSERT INTO Event (Name, Description, EventDate, VenueId, OrganiserId) VALUES
('Cape Town 10K Challenge','Annual fast 10K','2026-06-15',1,1),
('Green Point Half Marathon','Scenic half','2026-07-20',2,1),
('City Fun Run Festival','Family fun','2026-08-10',3,2);

INSERT INTO Category (EventId, Name, Distance, EntryFee, MaxCapacity) VALUES
(1,'10km Elite',10.0,250,200),(1,'10km Open',10.0,150,800),
(2,'21km Half',21.1,350,500),(2,'10km Companion',10.0,180,400),
(3,'5km Fun Run',5.0,80,1000),(3,'2.5km Family Walk',2.5,50,600),(3,'1km Kids Dash',1.0,30,300);

INSERT INTO Enrolment (UserId, EventId, CategoryId, Status) VALUES
(3,1,2,'Registered'),(4,1,2,'Registered'),(3,2,3,'Registered'),(4,3,5,'Registered'),(4,2,4,'Registered');

INSERT INTO Result (EnrolmentId, FinishTime, Position, Notes) VALUES
(1,'00:42:15',12,'PB'),(2,'00:45:30',25,'First 10K');
GO