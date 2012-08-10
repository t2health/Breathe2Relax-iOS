//
//  ObjectDataAccess.m
//  iBreathe130
//
//  Created by Roger Reeder on 9/7/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import "ObjectDataAccess.h"

@implementation ObjectDataAccess
@synthesize sessionID; 

#pragma mark -
#pragma mark Initialization
-(BOOL) initData {

	dfDay = [[NSDateFormatter alloc] init] ;
	[dfDay setDateFormat:@"yyyy-MM-dd"];

	dfDefault = [[NSDateFormatter alloc] init] ;
	[dfDefault setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

	sessionID = 0;
	int returnCode;
	NSString *databaseName = @"iBreathe.db";
	
	NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *docDir = [arrayPaths objectAtIndex:0];
	
	NSString *sDBfile = [NSString stringWithFormat:@"%@/%@", docDir, databaseName];
	const char *cDatabaseName = [sDBfile UTF8String];
	
	// OPEN DATABASE...
	returnCode = sqlite3_open(cDatabaseName, &pDb);
	if (returnCode != SQLITE_OK)
	{
		fprintf(stderr, "Error in creating the database  Error: %s", sqlite3_errmsg(pDb));
		sqlite3_close(pDb);
		return NO;
	}
	//  GOOD pDb
	// Init in this order
	[self initSessions];
	[self initScales];
	[self initResults];
	[self initNotes];
	[self initTips];
	[self initSettings];
	/**** GENERATE RANDOM DATA FOR TESTING ****
    TODO: Disable Random Data Generator
	 ******************************************/
	if ([self recordCount:@"tblResults"] == 0) {
		[self genData];
	}
	if ([self recordCount:@"tblTips"] == 0) {
		[self importData];
	}
	return YES;
}

-(void)closeData {
	sqlite3_close(pDb);
}

-(void)genData {
	RANDOM_SEED();
	int max = RANDOM_INT(5, 30); //5 - 30 days back.
	//int max = 3;
	NSDate *startDate =[dfDay dateFromString:[dfDay stringFromDate:[NSDate date]]];
	startDate = [startDate dateByAddingTimeInterval:-(DAYINSEC * max)];
	CGFloat lastValues[4];
	
	for (int i = 0 ; i < 4; i++) {// starting point....
		lastValues[i] = (CGFloat)(RANDOM_INT(1,25)+RANDOM_INT(1,25)+RANDOM_INT(1,25)+RANDOM_INT(1,25));
	}
	for (int i = 0; i < max; i++) {  // Each session
		//Dictionary of label and array of series points
		NSDate *newDate = [startDate dateByAddingTimeInterval:(DAYINSEC * i)];
		//NSString *timestamp = [NSString stringWithFormat:@"%@", [df stringFromDate:newDate]];
		
		if (RANDOM_INT(1,100) > 75) {
			[self insertNote:@"Note Entry to test journal entries" withDate:[newDate dateByAddingTimeInterval:RANDOM_INT(60,240)]];
		}
		
		if (RANDOM_INT(1,100) > 25 || i == max - 1) {
			sessionID = [self insertSession:newDate];
			for (int j = 0; j < 2; j++) { //Pre and Post Results
				for (int k = 1; k <=1; k++) {  // Four Result Entries
					CGFloat highValue = lastValues[k-1];
					CGFloat lowValue = highValue;
					if (j==0) {
						highValue += 20.0f;
						lowValue -= 3.0f;
					}else {
						highValue += 7.0f;
						lowValue -= 7.0f;
					}
					if (lowValue< 2.0f) {
						lowValue = 2.0f;
					}
					if (highValue > 100.0f) {
						highValue = 100.0f;
					}
					CGFloat v =  (CGFloat)RANDOM_INT((int)(lowValue/2.0f),(int)(highValue/2.0f))+(CGFloat)RANDOM_INT((int)(lowValue/2.0f),(int)(highValue/2.0f));
					[self insertResult:j withScaleID:k withValue:v withTimestamp:newDate];
				}
			}
		}
	}
}
- (void)importData {
	[self loadXMLByFile:@"iBreathTips.xml"];
}

- (NSDate *)dateFromSQLField:(NSDictionary *)record withDateField:(NSString *)dateField {
	NSString *tDay = [NSString stringWithFormat:@"%@", (NSString *)[record valueForKey:dateField]];
	NSDate *returnDate = [dfDefault dateFromString:tDay];
	return returnDate;
}

- (NSDate *)getFirstSessionDate {
	NSString *sql = @"SELECT MIN(datetime(timestamp,'localtime')) firstTimestamp FROM tblSessions";
	NSArray *recordset = [self resultsOfQuery:sql];
	NSDate *date;
	if ([recordset count] > 0) {
		NSMutableDictionary *record = (NSMutableDictionary *)[recordset objectAtIndex:0];
		date = [self dateFromSQLField:record withDateField:@"firstTimestamp"];
	} else {
		date = [NSDate date];
	}
	return [dfDay dateFromString:[dfDay stringFromDate:date]];
}
- (NSDate *)getLastSessionDate {
	NSDate *date;
	NSString *sql = @"SELECT MAX(datetime(timestamp,'localtime')) lastTimestamp FROM tblSessions";
	NSArray *recordset = [self resultsOfQuery:sql];
	if ([recordset count] > 0) {
		NSMutableDictionary *record = (NSMutableDictionary *)[recordset objectAtIndex:0] ;
		date = [self dateFromSQLField:record withDateField:@"lastTimestamp"];
	} else {
		date = [NSDate date];
	}
	return [dfDay dateFromString:[dfDay stringFromDate:date]];
}
- (NSArray *)getNoteListByDate:(BOOL)descending {
	NSString *sql = [NSString stringWithFormat:@"SELECT strftime('%%Y-%%m-%%d',tN.fldDate, 'localtime') fldDay, COUNT(fldNoteID) fldNumberOfNotes FROM tblNotes tN  GROUP BY strftime('%%Y-%%m-%%d',tN.fldDate, 'localtime') ORDER BY fldDate %@",descending ? @"DESC" : @"ASC"];
	return [self resultsOfQuery:sql];
}
- (NSArray *)getNoteListByMonth {
	NSString *sql = @"SELECT fldNoteID, strftime('%Y-%m',tN.fldDate, 'localtime') fldMonth FROM tblNotes tN ORDER BY fldDate DESC;";
	NSArray *recordset = [self resultsOfQuery:sql];
	NSString *lastMonth, *thisMonth;
	NSMutableArray *results = [[[NSMutableArray alloc] init] autorelease];
	NSMutableArray *items = nil;
	for (int i = 0; i < [recordset count]; i++) {
		if (i == 0) {
			lastMonth = [NSString stringWithFormat:@"%@",(NSString *)[[recordset objectAtIndex:i] objectForKey:@"fldMonth"]];
			items = [[NSMutableArray alloc] init];
		}
		thisMonth = [NSString stringWithFormat:@"%@",(NSString *)[[recordset objectAtIndex:i] objectForKey:@"fldMonth"]];
		if (![thisMonth isEqualToString:lastMonth]) {
			lastMonth = thisMonth;
			[results addObject:[NSArray arrayWithArray:items]];
			[items release];
			items = [[NSMutableArray alloc] init];
		}
		[items addObject:[[recordset objectAtIndex:i] objectForKey:@"fldNoteID"]];
	}
	if (items != nil) {
		[results addObject:[NSArray arrayWithArray:items]];
		[items release];
	}
	return [NSArray arrayWithArray:results];
}
- (NSArray *)getNoteListByDay:(NSDate *)noteDate {
	NSString *sql = [NSString stringWithFormat:@"SELECT fldNoteID, strftime('%%Y-%%m-%%d',tN.fldDate, 'localtime') fldDay FROM tblNotes tN WHERE strftime('%%Y-%%m-%%d',tn.fldDate, 'localtime') = '%@' ORDER BY fldDate DESC;",[dfDay stringFromDate:noteDate]];
	NSArray *recordset = [self resultsOfQuery:sql];
	NSString *lastDay, *thisDay;
	NSMutableArray *results = [[[NSMutableArray alloc] init] autorelease];
	NSMutableArray *items = nil;
	for (int i = 0; i < [recordset count]; i++) {
		if (i == 0) {
			lastDay = [NSString stringWithFormat:@"%@",(NSString *)[[recordset objectAtIndex:i] objectForKey:@"fldDay"]];
			items = [[NSMutableArray alloc] init];
		}
		thisDay = [NSString stringWithFormat:@"%@",(NSString *)[[recordset objectAtIndex:i] objectForKey:@"fldDay"]];
		if (![thisDay isEqualToString:lastDay]) {
			lastDay = thisDay;
			[results addObject:[NSArray arrayWithArray:items]];
			[items release];
			items = [[NSMutableArray alloc] init];
		}
		[items addObject:[[recordset objectAtIndex:i] objectForKey:@"fldNoteID"]];
	}
	if (items != nil) {
		[results addObject: [NSArray arrayWithArray:items]];
		[items release];
	}
	return [NSArray arrayWithArray:results];
}
- (NSArray *)getDataForDate:(NSDate *)filterDate {
	NSString *sql = [NSString stringWithFormat:@"SELECT tSL.fldMinLabel, tSL.fldMaxLabel, datetime(tS.timestamp, 'localtime') firstTimestamp, AVG(tR.fldValue) fldValue, MIN(tS.fldSessionID) fldSessionID \
					 FROM tblSessions tS \
					 JOIN tblResults tR ON tS.fldSessionID = tR.fldSessionID \
					 JOIN tblScales tSL ON tR.fldScaleID = tSL.fldScaleID \
					 WHERE strftime('%%Y-%%m-%%d', tS.timestamp, 'localtime')  = '%@' \
					 GROUP BY  tSL.fldMinLabel, tSL.fldMaxLabel, strftime('%%Y-%%m-%%d', tS.timestamp, 'localtime') \
					 ORDER BY tSL.fldWeight, tR.fldTypeID",[dfDay stringFromDate:filterDate]];
	NSLog(@"%@",sql);
	return [self resultsOfQuery:sql];
}


- (NSArray *)getDataForSession:(int)seekSessionID {//date format 'yyyy-mm-dd'
	NSString *sql = [NSString stringWithFormat:@"SELECT tS.fldSessionID, tR.fldResultID, tSL.fldWeight, tSL.fldMinLabel, tSL.fldMaxLabel, tR.fldValue, datetime(tS.timestamp,'localtime') firstTimestamp \
					 FROM tblSessions tS \
					 JOIN tblResults tR ON tS.fldSessionID = tR.fldSessionID \
					 JOIN tblScales tSL ON tR.fldScaleID = tSL.fldScaleID \
					 WHERE tS.fldSessionID = %d \
					 ORDER BY tSL.fldWeight, tR.fldTypeID",seekSessionID];
	return [self resultsOfQuery:sql];
}

- (NSArray *)getNoteForDate:(NSDate *)filterDate {//date format 'yyyy-mm-dd'
	NSString *sql = [NSString stringWithFormat:@"SELECT tN.fldNoteID, tN.fldNote, datetime(tN.fldDate,'localtime') fldDate\
					 FROM tblNotes tN\
					 WHERE strftime('%%Y-%%m-%%d',tN.fldDate, 'localtime') == '%@'",[dfDay stringFromDate:filterDate]];
	return [self resultsOfQuery:sql];
}

- (NSArray *)getNoteForID:(int)seekNoteID {
	NSString *sql = [NSString stringWithFormat:@"SELECT tN.fldNoteID, tN.fldNote, strftime('%%m/%%d/%%Y',tN.fldDate, 'localtime') fldDisplayDate, datetime(tN.fldDate,'localtime') fldDate\
					 FROM tblNotes tN\
					 WHERE tN.fldNoteID = %d",seekNoteID];
	return [self resultsOfQuery:sql];
}

- (NSArray *)getTipForDate:(int)julianDate {
	int numberOfTips = [self recordCount:@"tblTips"];
	NSString *sql = [NSString stringWithFormat:@"SELECT fldTip FROM tblTips WHERE fldTipNumber = %d", (julianDate % numberOfTips) + 1];
	return [self resultsOfQuery:sql];
}



- (int)getMaxSessionID {
	int result = 0;
	NSString *sql = @"SELECT MAX(tS.fldSessionID) fldSessionID FROM tblSessions tS ";
	
	NSArray *records =	[self resultsOfQuery:sql];
	if ([records count] > 0) {
		NSDictionary *record = [records objectAtIndex:0];
		result = [(NSNumber *)[record valueForKey:@"fldSessionID"] intValue];
	}
	return result;
}

#pragma mark -
#pragma mark Settings Functions
-(BOOL)initSettings {
	BOOL results = NO;
	if ([self doesTableExist:@"tblSettings"]) {
		results = YES;
	}else {
		int returnCode;
		char *errorMsg= "";
		char *sqlStatement = "CREATE TABLE IF NOT EXISTS tblSettings (fldSettingID INTEGER PRIMARY KEY AUTOINCREMENT, \
		fldSettingName VARCHAR(25), \
		fldSettingValue TEXT, \
		timestamp DATE NOT NULL DEFAULT CURRENT_TIMESTAMP);";
		
		returnCode = sqlite3_exec(pDb, sqlStatement, NULL, NULL, &errorMsg);
		if (returnCode != SQLITE_OK)
		{
			fprintf(stderr, "Error in creating the table.  Error: %s", errorMsg);
			sqlite3_free(errorMsg);
		}else {
			results = YES;
		}
	}
	return results;
}
-(BOOL) clearSettings {
	BOOL results = NO;
	if ([self doesTableExist:@"tblSettings"]) {
		int returnCode;
		char *errorMsg= "";
		char *sqlStatement = "DELETE FROM tblSettings;";
		
		returnCode = sqlite3_exec(pDb, sqlStatement, NULL, NULL, &errorMsg);
		if (returnCode != SQLITE_OK)
		{
			fprintf(stderr, "Error in truncating the table.  Error: %s", errorMsg);
			sqlite3_free(errorMsg);
		}else {
			results = YES;
		}
	}
	return results;
    
}


-(int) saveSetting:(NSString *)settingName andValue:(NSString *)settingValue {
	char *errorMsg = "";
	int returnCode;
	sqlite_int64 resultID;
	NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM tblSettings WHERE fldSettingName = '%@'; INSERT INTO tblSettings (fldSettingName, fldSettingValue) VALUES('%@','%@');", [self cleanSQL:settingName], [self cleanSQL:settingName], [self cleanSQL:settingValue]];
	
	returnCode = sqlite3_exec(pDb, [insertSQL UTF8String] , NULL, NULL, &errorMsg);
	
	if (returnCode != SQLITE_OK)
	{
		fprintf(stderr, "Error in inserting into the tblSettings table.  Error: %s", errorMsg);
	}
	resultID = sqlite3_last_insert_rowid(pDb);
	return (int)resultID;
}

- (NSString *)getSettingValue:(NSString *)settingName andDefaultValue:(NSString *)defaultValue {
	NSString *settingValue = [NSString stringWithFormat:@"%@",defaultValue];
	NSString *selectSQL = [NSString stringWithFormat:@"SELECT fldSettingValue FROM tblSettings WHERE fldSettingName = '%@'",[self cleanSQL:settingName]];
	NSArray *recordset = [self resultsOfQuery:selectSQL];
	if ([recordset count] > 0) {
		NSDictionary *record = [recordset objectAtIndex:0];
		settingValue = (NSString *)[record objectForKey:@"fldSettingValue"];
	} else {
		[self saveSetting:settingName andValue:defaultValue];
	}
	return settingValue;
}

#pragma mark -
#pragma mark Help Tips Functions
-(BOOL)initTips {
	BOOL results = NO;
	if ([self doesTableExist:@"tblTips"]) {
		results = YES;
	}else {
		int returnCode;
		char *errorMsg= "";
		char *sqlStatement = "CREATE TABLE IF NOT EXISTS tblTips  (fldTipID INTEGER PRIMARY KEY AUTOINCREMENT, \
		fldTipNumber INTEGER, \
		fldTip TEXT, \
		fldDate DATE, \
		timestamp DATE NOT NULL DEFAULT CURRENT_TIMESTAMP);";
		
		returnCode = sqlite3_exec(pDb, sqlStatement, NULL, NULL, &errorMsg);
		if (returnCode != SQLITE_OK)
		{
			fprintf(stderr, "Error in creating the table.  Error: %s", errorMsg);
			sqlite3_free(errorMsg);
		}else {
			results = YES;
		}
	}
	return results;
}
-(int) insertTip:(int)tipNumber andTip:(NSString *)tip {
	char *errorMsg = "";
	int returnCode;
	sqlite_int64 resultID;
	NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO tblTips (fldTipNumber, fldTip) VALUES(%d,'%@');",tipNumber, [self cleanSQL:tip]];
	
	returnCode = sqlite3_exec(pDb, [insertSQL UTF8String] , NULL, NULL, &errorMsg);
	
	if (returnCode != SQLITE_OK)
	{
		fprintf(stderr, "Error in inserting into the tblTips table.  Error: %s", errorMsg);
	}
	resultID = sqlite3_last_insert_rowid(pDb);
	return (int)resultID;
}



#pragma mark -
#pragma mark Notes Functions
-(BOOL)initNotes {
	BOOL results = NO;
	if ([self doesTableExist:@"tblNotes"]) {
		results = YES;
	}else {
		int returnCode;
		char *errorMsg= "";
		char *sqlStatement = "CREATE TABLE IF NOT EXISTS tblNotes  (fldNoteID INTEGER PRIMARY KEY AUTOINCREMENT, \
		fldNote TEXT, \
		fldDate DATE NOT NULL DEFAULT CURRENT_TIMESTAMP, \
		timestamp DATE NOT NULL DEFAULT CURRENT_TIMESTAMP);";
		
		returnCode = sqlite3_exec(pDb, sqlStatement, NULL, NULL, &errorMsg);
		if (returnCode != SQLITE_OK)
		{
			fprintf(stderr, "Error in creating the table.  Error: %s", errorMsg);
			sqlite3_free(errorMsg);
		}else {
			results = YES;
		}
	}
	return results;
}
-(BOOL) clearNotes {
	BOOL results = NO;
	if ([self doesTableExist:@"tblNotes"]) {
		int returnCode;
		char *errorMsg= "";
		char *sqlStatement = "DELETE FROM tblNotes;";
		
		returnCode = sqlite3_exec(pDb, sqlStatement, NULL, NULL, &errorMsg);
		if (returnCode != SQLITE_OK)
		{
			fprintf(stderr, "Error in truncating the table.  Error: %s", errorMsg);
			sqlite3_free(errorMsg);
		}else {
			results = YES;
		}
	}
	return results;
    
}

-(int) insertNote:(NSString *)note withDate:(NSDate *)date {
	char *errorMsg = "";
	int returnCode;
	sqlite_int64 resultID;
	NSString *insertSQL;
	if (date != nil) {
		insertSQL = [NSString stringWithFormat:@"INSERT INTO tblNotes (fldNote, fldDate) \
					 VALUES('%@',datetime('%@','utc'));", [self cleanSQL:note], [dfDefault stringFromDate:date]];
	}else {
		insertSQL = [NSString stringWithFormat:@"INSERT INTO tblNotes (fldNote) \
					 VALUES('%@');", [self cleanSQL:note]];
	}
	returnCode = sqlite3_exec(pDb, [insertSQL UTF8String] , NULL, NULL, &errorMsg);
	
	if (returnCode != SQLITE_OK)
	{
		fprintf(stderr, "Error in inserting into the tblNotes table.  Error: %s", errorMsg);
	}
	resultID = sqlite3_last_insert_rowid(pDb);
	return (int)resultID;
}

-(void) saveNote:(int)noteID withNote:(NSString *)note {
	char *errorMsg = "";
	int returnCode;
	
	NSString *updateSQL = [NSString stringWithFormat:@"UPDATE tblNotes SET fldNote = '%@' WHERE fldNoteID = %d;", [self cleanSQL:note], noteID] ;
	returnCode = sqlite3_exec(pDb, [updateSQL UTF8String] , NULL, NULL, &errorMsg);
	if (returnCode != SQLITE_OK)
	{
		fprintf(stderr, "Error in updating the tblNotes table.  Error: %s", errorMsg);
	}
}

-(void) deleteNote:(int)noteID {
	char *errorMsg = "";
	int returnCode;
	
	NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM tblNotes WHERE fldNoteID = %d;", noteID] ;
	returnCode = sqlite3_exec(pDb, [updateSQL UTF8String] , NULL, NULL, &errorMsg);
	if (returnCode != SQLITE_OK)
	{
		fprintf(stderr, "Error in deleteing record from tblNotes table.  Error: %s", errorMsg);
	}
}

#pragma mark -
#pragma mark Results Functions
-(BOOL)initResults {
	BOOL results = NO;
	if ([self doesTableExist:@"tblResults"]) {
		results = YES;
	}else {
		int returnCode;
		char *errorMsg= "";
		char *sqlStatement = "CREATE TABLE IF NOT EXISTS tblResults  (fldResultID INTEGER PRIMARY KEY AUTOINCREMENT, \
		fldSessionID INT NOT NULL DEFAULT 0, \
		fldTypeID INT NOT NULL DEFAULT 0, \
		fldScaleID INT NOT NULL, \
		fldValue FLOAT NOT NULL DEFAULT 0.0, \
		timestamp DATE NOT NULL DEFAULT CURRENT_TIMESTAMP, \
		FOREIGN KEY (fldSessionID) REFERENCES tblSessions(fldSessionID), \
		FOREIGN KEY (fldScaleID) REFERENCES tblScales(fldScaleID));";
		
		returnCode = sqlite3_exec(pDb, sqlStatement, NULL, NULL, &errorMsg);
		if (returnCode != SQLITE_OK) {
			fprintf(stderr, "Error in creating the table.  Error: %s", errorMsg);
			sqlite3_free(errorMsg);
		} else {
			results = YES;
		}
	}
	return results;
}
-(BOOL) clearResults {
	BOOL results = NO;
	if ([self doesTableExist:@"tblResults"]) {
		int returnCode;
		char *errorMsg= "";
		char *sqlStatement = "DELETE FROM tblResults;";
		
		returnCode = sqlite3_exec(pDb, sqlStatement, NULL, NULL, &errorMsg);
		if (returnCode != SQLITE_OK)
		{
			fprintf(stderr, "Error in truncating the table.  Error: %s", errorMsg);
			sqlite3_free(errorMsg);
		}else {
			results = YES;
		}
	}
	return results;
    
}
-(int) insertResult:(int)typeID withScaleID:(int)scaleID withValue:(float)value withTimestamp:(NSDate *)timeStamp {
	char *errorMsg = "";
	int returnCode;
	char *statement;
	sqlite_int64 resultID = 0;
	
	NSString *tDate = [dfDay stringFromDate:[NSDate date]];
	if (timeStamp != nil) {
		tDate = [dfDay stringFromDate:timeStamp];
	}
	
	const char *cTimestamp = [tDate UTF8String];
	statement = sqlite3_mprintf("INSERT INTO tblResults (fldSessionID,fldTypeID,fldScaleID, fldValue, timestamp) \
									VALUES(%d,%d,%d,%6.2f,datetime('%s','utc'));",sessionID,typeID,scaleID,value,cTimestamp);
	returnCode = sqlite3_exec(pDb, statement, NULL, NULL, &errorMsg);
	if (returnCode == SQLITE_OK){
		resultID = sqlite3_last_insert_rowid(pDb);
	} else {
		fprintf(stderr, "Error in inserting into the results table.  Error: %s", errorMsg);
	}
	sqlite3_free(statement);
	return (int)resultID;
}

#pragma mark -
#pragma mark Scales Functions
-(BOOL)initScales {
	
	BOOL results = NO;
	if ([self doesTableExist:@"tblScales"]) {
		results = YES;
	}else {
		int returnCode;
		char *errorMsg= "";
		char *sqlStatement = "CREATE TABLE IF NOT EXISTS tblScales  (fldScaleID INTEGER PRIMARY KEY AUTOINCREMENT, \
		fldWeight INT NOT NULL DEFAULT 0, \
		fldMinLabel VARCHAR(25), \
		fldMaxLabel VARCHAR(25), \
		timestamp DATE NOT NULL DEFAULT CURRENT_TIMESTAMP);";
		
		returnCode = sqlite3_exec(pDb, sqlStatement, NULL, NULL, &errorMsg);
		if (returnCode != SQLITE_OK)
		{
			fprintf(stderr, "Error in creating the table.  Error: %s", errorMsg);
			sqlite3_free(errorMsg);
		}else {
			sqlStatement = "INSERT INTO tblScales(fldWeight, fldMinLabel, fldMaxLabel) VALUES(1,'Stressed', 'Relaxed'); \
			INSERT INTO tblScales(fldWeight, fldMinLabel, fldMaxLabel) VALUES(2, 'Calm', 'Pressured'); \
			INSERT INTO tblScales(fldWeight, fldMinLabel, fldMaxLabel) VALUES(3, 'Content', 'Angry'); \
			INSERT INTO tblScales(fldWeight, fldMinLabel, fldMaxLabel) VALUES(4, 'Focused', 'Distracted');";
			
			returnCode = sqlite3_exec(pDb, sqlStatement, NULL, NULL, &errorMsg);
			
			if (returnCode != SQLITE_OK)
			{
				fprintf(stderr, "Error in inserting into the tblScales table.  Error: %s", errorMsg);
				sqlite3_free(errorMsg);
			}else {
				results = YES;
			}
		}
	}
	return results;
}

#pragma mark -
#pragma mark Sessions Functions
-(BOOL)initSessions {
	BOOL results = NO;
	if ([self doesTableExist:@"tblSessions"]) {
		results = YES;
	}else {
		int returnCode;
		char *errorMsg= "";
		char *sqlStatement = "CREATE TABLE IF NOT EXISTS tblSessions  (fldSessionID INTEGER PRIMARY KEY AUTOINCREMENT, \
		timestamp DATE NOT NULL DEFAULT CURRENT_TIMESTAMP);";
		
		returnCode = sqlite3_exec(pDb, sqlStatement, NULL, NULL, &errorMsg);
		if (returnCode != SQLITE_OK)
		{
			fprintf(stderr, "Error in creating the table.  Error: %s", errorMsg);
			sqlite3_free(errorMsg);
		}else {
			results = YES;
		}
	}
	return results;
}
-(BOOL) clearSessions {
	BOOL results = NO;
	if ([self doesTableExist:@"tblSessions"]) {
		int returnCode;
		char *errorMsg= "";
		char *sqlStatement = "DELETE FROM tblSessions;";
		
		returnCode = sqlite3_exec(pDb, sqlStatement, NULL, NULL, &errorMsg);
		if (returnCode != SQLITE_OK)
		{
			fprintf(stderr, "Error in truncating the table.  Error: %s", errorMsg);
			sqlite3_free(errorMsg);
		}else {
			results = YES;
		}
	}
	return results;
    
}

-(BOOL) isAlreadySession:(NSDate *)timeStamp {
	char *statement;
    BOOL alreadyDone = YES;
	NSString *tDate = [dfDay stringFromDate:[NSDate date]];
	if (timeStamp != nil) {
		tDate = [dfDay stringFromDate:timeStamp];
	}
	const char *cTimestamp = [tDate UTF8String];
	statement = sqlite3_mprintf("SELECT COUNT(fldSessionID) numberOfRecords FROM tblSessions tS WHERE tS.timestamp  = datetime('%s','utc')",cTimestamp);
	struct sqlite3_stmt *stmt;
	int result = 0;
	if (sqlite3_prepare(pDb, statement, strlen(statement), &stmt, NULL) == SQLITE_OK) {
		if (sqlite3_step(stmt) == SQLITE_ROW) {
			result = sqlite3_column_int(stmt, 0);
		}
	}
    if (result == 0) {
        alreadyDone = NO;
    }
    return alreadyDone;
}

-(int) insertSession:(NSDate *)timeStamp {
	char *errorMsg = "";
	int returnCode;
	char *statement;
	sqlite_int64 pSessionID = 0;
	NSString *tDate = [dfDay stringFromDate:[NSDate date]];
	if (timeStamp != nil) {
		tDate = [dfDay stringFromDate:timeStamp];
	}
	const char *cTimestamp = [tDate UTF8String];
	statement = sqlite3_mprintf("INSERT INTO tblSessions (timestamp) VALUES(datetime('%s','utc'))",cTimestamp);
	
	returnCode = sqlite3_exec(pDb, statement, NULL, NULL, &errorMsg);
	if (returnCode != SQLITE_OK) {
		fprintf(stderr, "Error in inserting into the tblSessions table.  Error: %s", errorMsg);
		sqlite3_free(statement);
	}
	pSessionID = sqlite3_last_insert_rowid(pDb);
	sqlite3_free(statement);
	return (int)pSessionID;
}

#pragma mark -
#pragma mark Utilies
- (NSArray *)resultsOfQuery:(NSString *)query
{
	const char *qbuff = [query UTF8String];
	NSMutableArray *lines = [NSMutableArray array];
	struct sqlite3_stmt *stmt;
	int retry = 0;
	int err;
	int i;
    const int MAX_RETRY = 1000;
	
	if (sqlite3_prepare(pDb, qbuff, strlen(qbuff), &stmt, NULL) == SQLITE_OK) {
		while (1) {
			err = sqlite3_step(stmt);
			if (err == SQLITE_ROW) {
				NSMutableDictionary *line = [NSMutableDictionary dictionary];
				int count = sqlite3_data_count(stmt);
				for (i = 0; i <= count; i++) { 
					const char *name = sqlite3_column_name(stmt, i); 
					if (name != NULL) {
						int type = sqlite3_column_type(stmt, i);
						if (type == SQLITE_INTEGER) {
							[line setObject: [NSNumber numberWithInt: sqlite3_column_int(stmt, i)]
									 forKey: [NSString stringWithUTF8String: name]];    
							
						} else if (type == SQLITE_FLOAT) {
							[line setObject: [NSNumber numberWithDouble: sqlite3_column_double(stmt, i)]
									 forKey: [NSString stringWithUTF8String: name]];    
							
						} else if (type == SQLITE_TEXT) {
							[line setObject: [NSString stringWithUTF8String: (const char *)sqlite3_column_text(stmt, i)]
									 forKey: [NSString stringWithUTF8String: name]];    
							
						} else if (type == SQLITE_BLOB) {
							const void *bytes = sqlite3_column_blob(stmt, i);
							int length = sqlite3_column_bytes(stmt, i); 
							[line setObject: [NSData dataWithBytes: bytes length: length]
									 forKey: [NSString stringWithUTF8String: name]];    
						}
					}
				}
				[lines addObject: line];
			} else {
				if (err == SQLITE_DONE) {
					break;
				} else if (err == SQLITE_BUSY) {
					NSAutoreleasePool *arp = [[NSAutoreleasePool alloc] init];
					NSDate *when = [NSDate dateWithTimeIntervalSinceNow: 0.1];
					[NSThread sleepUntilDate: when];
					[arp release];
					if (retry++ >= MAX_RETRY) {
						break;
					}
					
				}
				else {
					break;
				}
			}
		}
		
		sqlite3_finalize(stmt);
		
	} else {
		NSLog(@"error at: %@", query);
		NSLog(@"%s", sqlite3_errmsg(pDb));
	}
	return [NSArray arrayWithArray:lines];
}

-(BOOL)doesTableExist:(NSString *)tableName {
	NSString *qry = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE name='%@'",tableName];
	const char *qbuff = [qry UTF8String];
	struct sqlite3_stmt *stmt;
	BOOL result = NO;
	if (sqlite3_prepare(pDb, qbuff, strlen(qbuff), &stmt, NULL) == SQLITE_OK) {
		if (sqlite3_step(stmt) == SQLITE_ROW) {
			result = YES;
		}
	}
	return result;
}

-(int)recordCount:(NSString *)tableName {
	NSString *qry = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",tableName];
	const char *qbuff = [qry UTF8String];
	struct sqlite3_stmt *stmt;
	int result = 0;
	if (sqlite3_prepare(pDb, qbuff, strlen(qbuff), &stmt, NULL) == SQLITE_OK) {
		if (sqlite3_step(stmt) == SQLITE_ROW) {
			result = sqlite3_column_int(stmt, 0);
		}
	}
	return result;
}

-(NSString *)cleanSQL:(NSString *)text
{
	NSString *nOutString = [text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
	return nOutString;
}

- (void)loadXMLByFile:(NSString *)fileString {
	parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileString]]];
	parser.delegate = self;
	[parser parse];
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	NSString *tipText = @"";
	int tipNumber = 0;
	if([elementName isEqualToString:@"tip"]) {
		for (id key in attributeDict) {
			if ([key isEqualToString:@"number"]) {
				tipNumber = [(NSString *)[attributeDict objectForKey:key] intValue];
			}
			else if ([key isEqualToString:@"text"])	{
				tipText = [attributeDict objectForKey:key];
			}
		}
		[self insertTip:tipNumber andTip:tipText];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	if(!currentElementValue) 
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	return;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
	//	if([elementName isEqualToString:@"tip"])
}

#pragma mark Alert
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    exit(EXIT_SUCCESS);
}

- (void)resetData {
    BOOL reset = NO;
    if ([self clearNotes]) {
        if ([self clearResults]) {
            if ([self clearSessions]) {
                if ([self clearSettings]) {
                    reset = YES;
                }
            }
        }
    }
    NSString *msg = nil;
    if (reset) {
        msg = @"Data successfully reset.\n Reopen application after it closes.";
    } else {
        msg = @"Data reset failed.\n Closing application.";
    }
    
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Reset Data"
                                                 message:msg 
                                                delegate:self 
                                       cancelButtonTitle:@"Ok" 
                                       otherButtonTitles: nil] ;
    
    [av show];
    [av release];
}
@end
