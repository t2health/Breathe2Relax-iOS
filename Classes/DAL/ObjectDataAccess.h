//
//  ObjectDataAccess.h
//  iBreathe130
//
//  Created by Roger Reeder on 9/7/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

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
