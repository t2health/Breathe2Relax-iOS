//
//  ObjectDataAccess.h
//  iBreathe130
//
//  Created by Roger Reeder on 9/7/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//
/*
 *
 * Breathe2Relax
 *
 * Copyright © 2009-2012 United States Government as represented by
 * the Chief Information Officer of the National Center for Telehealth
 * and Technology. All Rights Reserved.
 *
 * Copyright © 2009-2012 Contributors. All Rights Reserved.
 *
 * THIS OPEN SOURCE AGREEMENT ("AGREEMENT") DEFINES THE RIGHTS OF USE,
 * REPRODUCTION, DISTRIBUTION, MODIFICATION AND REDISTRIBUTION OF CERTAIN
 * COMPUTER SOFTWARE ORIGINALLY RELEASED BY THE UNITED STATES GOVERNMENT
 * AS REPRESENTED BY THE GOVERNMENT AGENCY LISTED BELOW ("GOVERNMENT AGENCY").
 * THE UNITED STATES GOVERNMENT, AS REPRESENTED BY GOVERNMENT AGENCY, IS AN
 * INTENDED THIRD-PARTY BENEFICIARY OF ALL SUBSEQUENT DISTRIBUTIONS OR
 * REDISTRIBUTIONS OF THE SUBJECT SOFTWARE. ANYONE WHO USES, REPRODUCES,
 * DISTRIBUTES, MODIFIES OR REDISTRIBUTES THE SUBJECT SOFTWARE, AS DEFINED
 * HEREIN, OR ANY PART THEREOF, IS, BY THAT ACTION, ACCEPTING IN FULL THE
 * RESPONSIBILITIES AND OBLIGATIONS CONTAINED IN THIS AGREEMENT.
 *
 * Government Agency: The National Center for Telehealth and Technology
 * Government Agency Original Software Designation: Breathe2Relax001
 * Government Agency Original Software Title: Breathe2Relax
 * User Registration Requested. Please send email
 * with your contact information to: robert.kayl2@us.army.mil
 * Government Agency Point of Contact for Original Software: robert.kayl2@us.army.mil
 *
 */
#import <Foundation/Foundation.h>

NSString	*urlPath;
sqlite3		*pDb;

@interface ObjectDataAccess : NSObject <NSXMLParserDelegate ,UIAlertViewDelegate> {
	int	sessionID;
	NSString *currentDate;
	
	NSMutableString	*currentElementValue;
	NSMutableString *currentNodeContent;
	NSXMLParser *parser;
	NSDateFormatter *dfDefault;
	NSDateFormatter *dfDay;
	
}
@property (nonatomic) int sessionID;

-(BOOL)initData;
-(void)closeData;
-(void)genData;
-(void)importData;

- (NSDate *)dateFromSQLField:(NSDictionary *)record withDateField:(NSString *)dateField;

- (NSArray *)getNoteListByDate:(BOOL)descending;
- (NSArray *)getNoteListByMonth;
- (NSArray *)getNoteListByDay:(NSDate *)noteDate;
- (NSDate *)getFirstSessionDate;
- (NSDate *)getLastSessionDate;
- (NSArray *)getDataForDate:(NSDate *)filterDate;
- (NSArray *)getDataForSession:(int)seekSessionID;
- (NSArray *)getNoteForDate:(NSDate *)filterDate;
- (NSArray *)getNoteForID:(int)seekNoteID;
- (NSArray *)getTipForDate:(int)julianDate;
- (int)getMaxSessionID;

-(NSArray *)resultsOfQuery:(NSString *)query;
-(BOOL)doesTableExist:(NSString *)tableName;
-(int)recordCount:(NSString *)tableName;
-(NSString *)cleanSQL:(NSString *)text;

-(BOOL)initResults;
-(int) insertResult:(int)typeID withScaleID:(int)scaleID withValue:(float)value withTimestamp:(NSDate *)timeStamp;

-(BOOL)initScales;

-(BOOL)initSessions;
-(BOOL) isAlreadySession:(NSDate *)timeStamp;
-(int) insertSession:(NSDate *)timeStamp;

-(BOOL)initNotes;
-(int) insertNote:(NSString *)note withDate:(NSDate *)date;
-(void) saveNote:(int)noteID withNote:(NSString *)note;
-(void) deleteNote:(int)noteID;


-(BOOL) initSettings;
-(NSString *)getSettingValue:(NSString *)settingName andDefaultValue:(NSString *)defaultValue;
-(int) saveSetting:(NSString *)settingName andValue:(NSString *)settingValue;

-(BOOL)initTips;
-(int) insertTip:(int)tipNumber andTip:(NSString *)tip;

-(void)loadXMLByFile:(NSString *)fileString;

-(BOOL) clearNotes;
-(BOOL) clearResults;
-(BOOL) clearSessions;
-(BOOL) clearSettings;
-(void) resetData;

@end
