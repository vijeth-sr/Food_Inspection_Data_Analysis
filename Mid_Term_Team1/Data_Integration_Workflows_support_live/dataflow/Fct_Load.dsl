source(output(
		RECORD_ID as decimal(38,0),
		INSPECTION_ID as decimal(38,0),
		DBA_NAME as string,
		AKA_NAME as string,
		LICENSE_NUMBER as decimal(38,0),
		FACILITY_TYPE as string,
		RISK as string,
		ADDRESS as string,
		CITY as string,
		STATE as string,
		ZIP_CODE as string,
		INSPECTION_DATE as date,
		INSPECTION_TYPE as string,
		RESULTS as string,
		LATITUDE as string,
		LONGITUDE as string,
		LOCATION as string,
		VIOLATION_ID as decimal(38,0),
		VIOLATION_DESCRIPTION as string,
		COMMENTS as string,
		DI_CREATEDATE as date,
		DI_WORKFLOWFILENAME as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	format: 'table') ~> StagingTable
source(output(
		RESULTSSK as decimal(38,0),
		RESULTS as string,
		DI_CREATEDATE as timestamp,
		DI_WORKFLOWFILENAME as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	format: 'table') ~> DimResults
source(output(
		INSPECTIONTYPESK as decimal(38,0),
		INSPECTIONTYPE as string,
		DI_CREATEDATE as timestamp,
		DI_WORKFLOWFILENAME as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	format: 'table') ~> DimInspections
source(output(
		RISKSK as decimal(38,0),
		RISK as string,
		DI_CREATEDATE as timestamp,
		DI_WORKFLOWFILENAME as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	format: 'table') ~> DimRisk
source(output(
		RESTAURANTSK as decimal(38,0),
		RESTAURANT_NAME as string,
		FACILITY_TYPE as string,
		ADDRESS as string,
		CITY as string,
		STATE as string,
		ZIP as decimal(38,0),
		LATITUDE as string,
		LONGITUDE as string,
		LOCATION as string,
		DI_CREATEDATE as timestamp,
		DI_WORKFLOWFILENAME as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	format: 'table') ~> DimRestaurant
source(output(
		DATESK as decimal(38,0),
		DAY_NAME as string,
		DAY_NUMBER as decimal(38,0),
		MONTH_NUMBER as decimal(38,0),
		YEAR_NUMBER as decimal(38,0),
		FULL_DATE as date
	),
	allowSchemaDrift: true,
	validateSchema: false,
	format: 'table') ~> DimDate
StagingTable, DimResults join(StagingTable@RESULTS == DimResults@RESULTS,
	joinType:'left',
	matchType:'exact',
	ignoreSpaces: false,
	broadcast: 'auto')~> JoinResults
JoinResults, DimInspections join(INSPECTION_TYPE == INSPECTIONTYPE,
	joinType:'left',
	matchType:'exact',
	ignoreSpaces: false,
	broadcast: 'auto')~> JoinInspection
JoinInspection, DimRisk join(StagingTable@RISK == DimRisk@RISK,
	joinType:'left',
	matchType:'exact',
	ignoreSpaces: false,
	broadcast: 'auto')~> JoinRisk
JoinRisk, DimRestaurant join(DBA_NAME == RESTAURANT_NAME
	&& StagingTable@ADDRESS == DimRestaurant@ADDRESS
	&& StagingTable@LATITUDE == DimRestaurant@LATITUDE
	&& StagingTable@LONGITUDE == DimRestaurant@LONGITUDE
	&& StagingTable@FACILITY_TYPE == DimRestaurant@FACILITY_TYPE
	&& StagingTable@CITY == DimRestaurant@CITY
	&& StagingTable@STATE == DimRestaurant@STATE,
	joinType:'left',
	matchType:'exact',
	ignoreSpaces: false,
	broadcast: 'auto')~> JoinRestaurant
JoinRestaurant, DimDate join(INSPECTION_DATE == FULL_DATE,
	joinType:'left',
	matchType:'exact',
	ignoreSpaces: false,
	broadcast: 'auto')~> JoinDate
JoinDate sink(allowSchemaDrift: true,
	validateSchema: false,
	deletable:false,
	insertable:true,
	updateable:false,
	upsertable:false,
	format: 'table',
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	stageInsert: true) ~> LoadToFactTable