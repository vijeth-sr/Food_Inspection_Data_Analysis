-- Drop table Dim_InspectionResults;
CREATE TABLE Dim_InspectionResults (
    ResultsSK INT AUTOINCREMENT(1,1) PRIMARY KEY,
    Results VARCHAR(255),
    DI_CreateDate DATETIME,
    DI_WorkflowFileName STRING
);
-- Drop table Dim_InspectionType ;
CREATE TABLE Dim_InspectionType (
    InspectionTypeSK INT AUTOINCREMENT(1,1) PRIMARY KEY,
    InspectionType VARCHAR(255),
    DI_CreateDate DATETIME,
    DI_WorkflowFileName STRING
);
-- Drop table Dim_RiskCategory ;
CREATE TABLE Dim_RiskCategory (
    RiskSK INT AUTOINCREMENT(1,1) PRIMARY KEY,
    Risk VARCHAR(255),
    DI_CreateDate DATETIME,
    DI_WorkflowFileName STRING
);
-- Drop table Dim_Restaurants ;
CREATE TABLE Dim_Restaurants (
    RestaurantSK INT AUTOINCREMENT(1,1) PRIMARY KEY,
    Restaurant_Name VARCHAR(255),
    Facility_Type VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(50),
    State CHAR(10),
    Zip INT,
    Latitude CHAR(18),
    Longitude CHAR(18),
    Location CHAR(40),
    DI_CreateDate DATETIME,
    DI_WorkflowFileName STRING
);

-- Drop table Dim_ViolationCodes ;
CREATE TABLE Dim_ViolationCodes (
    ViolationSK INT AUTOINCREMENT(1,1) PRIMARY KEY,
    ViolationCode INT,
    ViolationDescription VARCHAR(1000),
     DI_CreateDate DATETIME,
    DI_WorkflowFileName STRING
  
);
Drop table FCT_Inspections_Violations ;

CREATE TABLE FCT_Inspections_Violations (
    InspectionID INT,                                    -- Foreign key linking to FCT_FoodInspections
    ViolationSK INT,                                     -- Foreign key referencing Dim_ViolationCodes(ViolationSK)
    ViolationDetail VARCHAR(8000) NULL,                       -- Detailed description of the violation
    ViolationMemo VARCHAR(8000) NULL,                         -- Additional comments or memo
    ViolationPoints Varchar(100) NULL,                            -- Points related to the violation (set as INT, adjust if necessary)
    DI_CreateDate DATETIME,                              -- Creation timestamp for ETL audit
    DI_WorkflowFileName STRING,                          -- Workflow file name for ETL audit
    PRIMARY KEY (InspectionID, ViolationSK),             -- Composite primary key
    FOREIGN KEY (ViolationSK) REFERENCES Dim_ViolationCodes(ViolationSK)  -- Foreign key constraint
);



Select * from FCT_FoodInspections ;

CREATE TABLE FCT_FoodInspections (
    FCTInspectionID INT AUTOINCREMENT(1,1) PRIMARY KEY,
    InspectionID  INT,
    InspectionDate DATE NULL,
    DateSK INT,
    RestaurantSK INT NULL,
    InspectionTypeSK INT NULL,
    ResultsSK INT NULL,
    RiskSK INT NULL,
    Inspection_Score INT NULL,
    DI_CreateDate DATETIME,
    DI_WorkflowFileName STRING
);

CREATE TABLE DIM_Date (
    DateSK INT PRIMARY KEY,
    full_date DATE,
    day_name VARCHAR(10),
    day_number INT,
    month_number INT,
    year_number INT
);
