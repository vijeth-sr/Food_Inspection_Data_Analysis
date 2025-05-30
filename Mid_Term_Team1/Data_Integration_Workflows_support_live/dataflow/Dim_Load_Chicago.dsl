source(output(
		RESULTS as string,
		DI_CREATEDATE as timestamp,
		DI_WORKFLOWFILENAME as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	query: 'SELECT DISTINCT\nResults,\n CURRENT_TIMESTAMP AS DI_CreateDate,\n \'Chicago_FoodInspection_Workflow\' AS DI_WorkflowFileName\nFROM MIDTERM_TEAM1.CHICAGOSTAGE.CHICAGO_FOOD_INSPECTIONS where Results is not null',
	format: 'query') ~> StagingResults
source(output(
		INSPECTION_TYPE as string,
		DI_CREATEDATE as timestamp,
		DI_WORKFLOWFILENAME as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	query: 'SELECT DISTINCT\nINSPECTION_TYPE,\n CURRENT_TIMESTAMP AS DI_CreateDate,\n \'Chicago_FoodInspection_Workflow\' AS DI_WorkflowFileName\nFROM MIDTERM_TEAM1.CHICAGOSTAGE.CHICAGO_FOOD_INSPECTIONS where INSPECTION_TYPE is not null',
	format: 'query') ~> StagingInspectionType
source(output(
		RISK as string,
		DI_CREATEDATE as timestamp,
		DI_WORKFLOWFILENAME as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	query: 'SELECT DISTINCT RISK,\n CURRENT_TIMESTAMP AS DI_CreateDate,\n \'Chicago_FoodInspection_Workflow\' AS DI_WorkflowFileName\nFROM MIDTERM_TEAM1.CHICAGOSTAGE.CHICAGO_FOOD_INSPECTIONS where RISK is not null',
	format: 'query') ~> StagingRisk
source(output(
		RESTAURANT_NAME as string,
		FACILITY_TYPE as string,
		ADDRESS as string,
		CITY as string,
		STATE as string,
		ZIP as string,
		LATITUDE as string,
		LONGITUDE as string,
		LOCATION as string,
		DI_CREATEDATE as timestamp,
		DI_WORKFLOWFILENAME as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	query: 'SELECT DISTINCT \nDBA_NAME AS Restaurant_Name,\nFacility_Type,\nAddress,\n\'CHICAGO\' as City,\n\'IL\' as State,\nZip_Code as Zip,\nLatitude,\nLongitude,\nLocation,\nCURRENT_TIMESTAMP AS DI_CreateDate,\n\'Chicago_FoodInspection_Workflow\' AS DI_WorkflowFileName\nFROM MIDTERM_TEAM1.CHICAGOSTAGE.CHICAGO_FOOD_INSPECTIONS where DBA_NAME  is not null',
	format: 'query') ~> StagingRestaurants
source(output(
		VIOLATIONCODE as decimal(38,0),
		VIOLATIONDESCRIPTION as string,
		DI_CREATEDATE as timestamp,
		DI_WORKFLOWFILENAME as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	query: 'SELECT DISTINCT \n    COALESCE(VIOLATION_ID, 0) AS ViolationCode,\n    COALESCE(VIOLATION_DESCRIPTION, \'NA\') AS ViolationDescription,\nCURRENT_TIMESTAMP AS DI_CreateDate,\n\'Chicago_FoodInspection_Workflow\' AS DI_WorkflowFileName\nFROM MIDTERM_TEAM1.CHICAGOSTAGE.CHICAGO_FOOD_INSPECTIONS\nWHERE \n    (VIOLATION_DESCRIPTION IS NOT NULL AND TRIM(VIOLATION_DESCRIPTION) != \'\') \n    OR VIOLATION_ID = 0',
	format: 'query') ~> StagingViolations
StagingResults sink(allowSchemaDrift: true,
	validateSchema: false,
	deletable:false,
	insertable:true,
	updateable:false,
	upsertable:false,
	truncate:true,
	format: 'table',
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	saveOrder: 1,
	stageInsert: true,
	mapColumn(
		RESULTS,
		DI_CREATEDATE,
		DI_WORKFLOWFILENAME
	)) ~> DimResults
StagingInspectionType sink(allowSchemaDrift: true,
	validateSchema: false,
	deletable:false,
	insertable:true,
	updateable:false,
	upsertable:false,
	truncate:true,
	format: 'table',
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	saveOrder: 2,
	stageInsert: true,
	mapColumn(
		INSPECTIONTYPE = INSPECTION_TYPE,
		DI_CREATEDATE,
		DI_WORKFLOWFILENAME
	)) ~> DimInspectionType
StagingRisk sink(allowSchemaDrift: true,
	validateSchema: false,
	deletable:false,
	insertable:true,
	updateable:false,
	upsertable:false,
	truncate:true,
	format: 'table',
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	saveOrder: 3,
	stageInsert: true,
	mapColumn(
		RISK,
		DI_CREATEDATE,
		DI_WORKFLOWFILENAME
	)) ~> DimRisk
StagingRestaurants sink(allowSchemaDrift: true,
	validateSchema: false,
	deletable:false,
	insertable:true,
	updateable:false,
	upsertable:false,
	truncate:true,
	format: 'table',
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	saveOrder: 4,
	stageInsert: true,
	mapColumn(
		RESTAURANT_NAME,
		FACILITY_TYPE,
		ADDRESS,
		CITY,
		STATE,
		ZIP,
		LATITUDE,
		LONGITUDE,
		LOCATION,
		DI_CREATEDATE,
		DI_WORKFLOWFILENAME
	)) ~> DimRestaurant
StagingViolations sink(allowSchemaDrift: true,
	validateSchema: false,
	deletable:false,
	insertable:true,
	updateable:false,
	upsertable:false,
	truncate:true,
	format: 'table',
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	saveOrder: 5,
	stageInsert: true,
	mapColumn(
		VIOLATIONCODE,
		VIOLATIONDESCRIPTION,
		DI_CREATEDATE,
		DI_WORKFLOWFILENAME
	)) ~> DimViolations