//
//  B2RAppDelegate.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/2/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
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
#import "B2RAppDelegate.h"

#import "Visual.h"
#import "Reachability.h"


@implementation B2RAppDelegate

@synthesize window=_window;
@synthesize navigationController=_navigationController;

@synthesize visuals;
@synthesize playerSettings;
@synthesize firstTime;
@synthesize music;
@synthesize datalayer;
@synthesize audioPlayer;
@synthesize networkStatus;
@synthesize connectionRequired;
@synthesize preVASValue;
@synthesize bcServices;
@synthesize useYouTube;

void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    
    NSString *reachablityURL = [self getAppSetting:@"URLs" withKey: @"reachablityCheckBC"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    
    hostReach = [[Reachability reachabilityWithHostName: reachablityURL] retain];
	[hostReach startNotifier];
	
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
    
    wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	[wifiReach startNotifier];
    
	self.datalayer = [[[ObjectDataAccess alloc] init] retain];
	[self.datalayer initData];

    
	self.visuals = [self getVisuals];
    self.music = [self getMusic];
	[self getFirstTime];
	[self getSettings];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
#ifdef DEBUG
    NSString *analyticsKey = [self getAppSetting:@"Analytics" withKey:@"debugKey"];
#else
    NSString *analyticsKey = [self getAppSetting:@"Analytics" withKey:@"appKey"];
#endif
    [Analytics init:analyticsKey isEnabled:playerSettings.analytics];

    
    if (!self.playerSettings.trackOn) {
        self.firstTime.skipVAS = YES;
    }
    [self initAudioPlayer];

    if ([self.window respondsToSelector:@selector(setRootViewController:)]) {
        self.window.rootViewController = self.navigationController;
    } else {
        [self.window addSubview:self.navigationController.view];
    }

    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [hostReach release];
    [wifiReach release];
    [internetReach release];
    
    [self closeAudioPlayer];
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (void)closeAudioPlayer{
	if (audioPlayer != nil) {
		for (int i = 0; i <= enSCAmbient; i++) {
			[audioPlayer stop:i];
		}
	}
	[audioPlayer release];
}

#pragma mark -
#pragma mark Settings Functions
- (void)getSettings {
    // In Case they have old database
    int BreathSpan = [[self.datalayer getSettingValue:@"breathSpan" andDefaultValue:[NSString stringWithFormat:@"%d",DEFAULTBREATHLENGTH]] intValue];

	PlayerSettings *p =	[[PlayerSettings alloc] initWithName:[[self.datalayer getSettingValue:@"visual" andDefaultValue:@"0"] intValue] 
                                                   voiceType:[[self.datalayer getSettingValue:@"voiceType" andDefaultValue:@"0"] intValue]
                                                      cycles:[[self.datalayer getSettingValue:@"cycles" andDefaultValue:@"16"] intValue] 
                                               visualPrompts:[[self.datalayer getSettingValue:@"visualPrompts" andDefaultValue:@"-1"] boolValue] 
                                                   showGauge:[[self.datalayer getSettingValue:@"showGauge" andDefaultValue:@"-1"] boolValue] 
                                              ambientMusicOn:[[self.datalayer getSettingValue:@"ambientMusicOn" andDefaultValue:@"-1"] boolValue] 
                                                ambientMusic:[[self.datalayer getSettingValue:@"ambientMusic" andDefaultValue:@"-1"] intValue]	
                                           audioInstructions:[[self.datalayer getSettingValue:@"audioInstructions" andDefaultValue:@"-1"] boolValue] 
                                                audioPrompts:[[self.datalayer getSettingValue:@"audioPrompts" andDefaultValue:@"-1"] boolValue] 
                                                breathSpanIn:[[self.datalayer getSettingValue:@"breathSpanIn" andDefaultValue:[NSString stringWithFormat:@"%d",BreathSpan]] intValue] 
                                               breathSpanOut:[[self.datalayer getSettingValue:@"breathSpanOut" andDefaultValue:[NSString stringWithFormat:@"%d",BreathSpan]] intValue] 
                                               breathPauseIn:[[self.datalayer getSettingValue:@"breathPauseIn" andDefaultValue:[NSString stringWithFormat:@"%d",DEFAULTPAUSELENGTH]] intValue] 
                                              breathPauseOut:[[self.datalayer getSettingValue:@"breathPauseOut" andDefaultValue:[NSString stringWithFormat:@"%d",DEFAULTPAUSELENGTH]] intValue] 
                                                     trackOn:[[self.datalayer getSettingValue:@"trackOn" andDefaultValue:@"-1"] boolValue] 
                                                   analytics:[[self.datalayer getSettingValue:@"analytics" andDefaultValue:@"-1"] boolValue]];
    
	self.playerSettings = p;
	[p release];
}


- (void)saveSettings {
	[self.datalayer saveSetting:@"visual" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.visual]];
	[self.datalayer saveSetting:@"voiceType" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.voiceType]];
	[self.datalayer saveSetting:@"cycles" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.cycles]];
	[self.datalayer saveSetting:@"visualPrompts" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.visualPrompts]];
	[self.datalayer saveSetting:@"showGauge" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.showGauge]];
	[self.datalayer saveSetting:@"ambientMusic" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.ambientMusic]];
	[self.datalayer saveSetting:@"ambientMusicOn" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.ambientMusicOn]];
	[self.datalayer saveSetting:@"audioInstructions" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.audioInstructions]];
	[self.datalayer saveSetting:@"audioPrompts" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.audioPrompts]];
	[self.datalayer saveSetting:@"breathSpanIn" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.breathSpanIn]];
	[self.datalayer saveSetting:@"breathSpanOut" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.breathSpanOut]];
	[self.datalayer saveSetting:@"breathPauseIn" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.breathPauseIn]];
	[self.datalayer saveSetting:@"breathPauseOut" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.breathPauseOut]];
	[self.datalayer saveSetting:@"trackOn" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.trackOn]];
    [self.datalayer saveSetting:@"analytics" andValue:[NSString stringWithFormat:@"%d",self.playerSettings.analytics]];
}


- (void)savePracticeSettings:(PlayerSettings *)settings {
	self.playerSettings.visualPrompts = settings.visualPrompts;
	self.playerSettings.showGauge = settings.showGauge;
	self.playerSettings.visual = settings.visual;
	self.playerSettings.breathSpanIn = settings.breathSpanIn;
	self.playerSettings.breathSpanOut = settings.breathSpanOut;
	self.playerSettings.breathPauseIn = settings.breathPauseIn;
	self.playerSettings.breathPauseOut = settings.breathPauseOut;
	self.playerSettings.voiceType = settings.voiceType;
	self.playerSettings.cycles = settings.cycles;
	self.playerSettings.audioPrompts = settings.audioPrompts;
	self.playerSettings.audioInstructions = settings.audioInstructions;
	self.playerSettings.ambientMusicOn = settings.ambientMusicOn;
    self.playerSettings.ambientMusic = settings.ambientMusic;
    
    if (self.playerSettings.analytics != settings.analytics) {
        if (settings.analytics) {
            [Analytics setEnabled:settings.analytics];
            [Analytics logEvent:@"ANALYTICS ENABLED"];
        } else {
            [Analytics logEvent:@"ANALYTICS DISABLED"];
            [Analytics setEnabled:settings.analytics];
        }
    }
    self.playerSettings.analytics = settings.analytics;
    
    if (self.playerSettings.trackOn != settings.trackOn) {
        if (settings.trackOn) {
            [Analytics logEvent:@"VAS TRACKING ENABLED"];
        } else {
            [Analytics logEvent:@"VAS TRACKING DISABLED"];
        }
    }
	self.playerSettings.trackOn = settings.trackOn;
	
    [self saveSettings];
}



- (void)getFirstTime {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL resetHelpPrompts = [defaults boolForKey:@"resetHelpPrompts"];
	
	FirstTime *fT = [[FirstTime alloc] init:[[self.datalayer getSettingValue:@"firstTime" andDefaultValue:@"-1"] boolValue]];
    fT.shownPersonalize = NO;
	if (resetHelpPrompts) {
        [fT resetAllGuides];
		[defaults setBool:FALSE forKey:@"resetHelpPrompts"];
	}
	self.firstTime = fT;
}

-(NSArray *)getMusic {
    NSMutableArray *ma = [[[NSMutableArray alloc] init] autorelease];
	NSDictionary *ps = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"music" ofType:@"plist"]] 
                                                        mutabilityOption:NSPropertyListImmutable 
                                                                  format:nil errorDescription:nil];
	NSArray *musArray = [NSArray arrayWithArray:[ps objectForKey:@"Music"]];
    
	for (NSDictionary *mus in musArray) {
        [ma addObject:[[[Music alloc] initWithName:[mus objectForKey:@"musicTitle"] 
                                            artist:[mus objectForKey:@"artist"] 
                                        bundleName:[mus objectForKey:@"bundleName"] 
                                             album:[mus objectForKey:@"album"] 
                                       description:[mus objectForKey:@"description"]
                                            credit:[mus objectForKey:@"credit"]] autorelease]];
	}
	return [NSArray arrayWithArray:ma];
}

- (NSArray *)getVisuals {
	NSMutableArray *va = [[[NSMutableArray alloc] init] autorelease] ;
	NSDictionary *ps = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"visuals" ofType:@"plist"]] 
                                                        mutabilityOption:NSPropertyListImmutable 
                                                                  format:nil errorDescription:nil];
	NSArray *visArray = [NSArray arrayWithArray:[ps objectForKey:@"Visuals"]];
    
	for (NSDictionary *vis in visArray) {
		[va addObject:[[[Visual alloc] initWithName:[vis objectForKey:@"name"] 
										description:[vis objectForKey:@"description"] 
										 bundleName:[vis objectForKey:@"bundleName"] 
											postFix:[vis objectForKey:@"postFix"] 
									 numberOfFrames:[(NSNumber *)[vis objectForKey:@"numberOfFrames"] intValue] 
										overlayFile:[vis objectForKey:@"overlayFile"] 
									 backgroundFile:[vis objectForKey:@"backgroundFile"] 
										  thumbName:[vis objectForKey:@"thumbName"] 
										staticImage:[[vis objectForKey:@"staticImage"] boolValue]] autorelease]];
	}
	return [NSArray arrayWithArray:va];
}



#pragma mark -
#pragma mark Flurry Functions
-(void) flurryPageView:(NSString *)PageViewed {
	[Analytics logEvent:PageViewed];
	[Analytics countPageView];
}

-(void) flurryStartBreathing:(NSString *)startType{
	Visual *vis = (Visual *)[self.visuals objectAtIndex:self.playerSettings.visual];
	NSDictionary *myParams = [NSDictionary dictionaryWithObjectsAndKeys:startType,@"Start Type",
							  @"Incomplete", @"End Type",
							  [NSString stringWithFormat:@"%d",self.playerSettings.cycles],@"Planned Cycles",
							  [NSString stringWithFormat:@"%d",0],@"Cycles Completed",
							  [NSString stringWithFormat:@"%4.1f",(CGFloat)self.playerSettings.breathSpanIn/1000.0f],@"Starting Inhale Length",
							  [NSString stringWithFormat:@"%4.1f",(CGFloat)self.playerSettings.breathSpanIn/1000.0f],@"Ending Exhale Length",
							  [NSString stringWithFormat:@"%@",(self.playerSettings.showGauge ? @"Tube" : @"None")],@"Breathe Metronome",
							  [NSString stringWithFormat:@"%@",vis.name],@"Visual",nil];
	[Analytics logEvent:@"Practice Breathing" withParameters:myParams timed:YES];
}

-(void) flurryEndBreathing:(NSString *)endType{
	if (cycle > self.playerSettings.cycles) {
		cycle--;
	}
	NSDictionary *myParams = [NSDictionary dictionaryWithObjectsAndKeys:endType,@"End Type",
							  [NSString stringWithFormat:@"%d",cycle],@"Cycles Completed",
							  [NSString stringWithFormat:@"%4.1f",(CGFloat)self.playerSettings.breathSpanIn/1000.0f],@"Ending Inhale Length",
                              [NSString stringWithFormat:@"%4.1f",(CGFloat)self.playerSettings.breathSpanOut/1000.0f],@"Ending Exhale Length",nil];
	[Analytics endTimedEvent:@"Practice Breathing" withParameters:myParams];
}

-(void) flurrySubmitVAS:(NSDictionary *)parameters {
	[Analytics logEvent:@"VAS Pre and Post Percent Change" withParameters:parameters];
}

#pragma mark -
#pragma mark Utilities
-(NSString *)getAppSetting:(NSString *)group withKey:(NSString *)key {
    NSDictionary *ps = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"app" ofType:@"plist"]] 
                                                        mutabilityOption:NSPropertyListImmutable 
                                                                  format:nil errorDescription:nil];
    NSDictionary *grp = (NSDictionary *)[ps objectForKey:group];
    return (NSString *)[grp objectForKey:key];
}
-(int)MaxOfFontForLabel:(UILabel *)lbl andWidth:(CGFloat)width andHeight:(CGFloat)height
{
	UIFont *font = [UIFont fontWithName:@"Helvetica" size:28];
	NSString *t = [lbl text];
	
	if(t == @"") 
	{
		return 55;
	}
	int i;
	for(i = 36; i > 11; i=i-1)
	{
		font = [font fontWithSize:i];
		CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
		CGSize labelSize = [t sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		if(labelSize.height <= height )
			break;
	}
	return i;
}
-(void) SizeFontToFitLabel:(UILabel *)lbl andWidth:(CGFloat)width andHeight:(CGFloat)height
{
	UIFont *font = [UIFont fontWithName:@"Helvetica" size:28];
	NSString *t = [lbl text];
	if(t == @"") return;
	int i;
	for(i = 36; i > 11; i=i-1)
	{
		font = [font fontWithSize:i];
		CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
		CGSize labelSize = [t sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		if(labelSize.height <= height )
			break;
	}
	lbl.font = font;
}

- (CGFloat)getImageAspect:(UIImage *)img {
	CGFloat h = img.size.height;
	CGFloat w = img.size.width;
    
	return h/w; 
}


#pragma mark -
#pragma mark Checking Internet Connection
-(BOOL)checkInternet{
    NSString *reachablityURL = [self getAppSetting:@"URLs" withKey:@"reachablityCheckBC"];
	Reachability *r = [Reachability reachabilityWithHostName:reachablityURL];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if(internetStatus == ReachableViaWiFi || internetStatus == ReachableViaWWAN) {
		internet = YES;
	}else {
		internet = NO;
	}
	return internet;
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach {
    if(curReach == hostReach) {
        self.networkStatus = [curReach currentReachabilityStatus];
        self.connectionRequired= [curReach connectionRequired];
        if (self.networkStatus == NotReachable) {
            self.connectionRequired = NO;
        }
    }
    if (!self.bcServices) {
        BOOL hasInternet = NO;
        switch (self.networkStatus) {
            case NotReachable:
                hasInternet = NO;
                break;
            default:
                if (!self.connectionRequired) {
                    hasInternet = YES;
                }
                break;
        }
        [self checkBCConnection];
        if (self.useYouTube) {
            self.connectionRequired = YES;
            self.networkStatus = NotReachable;
            NSString *reachablityURL = [self getAppSetting:@"URLs" withKey:@"reachablityCheckYT"];
            [hostReach stopNotifier];
            [hostReach release];
            hostReach = [[Reachability reachabilityWithHostName: reachablityURL] retain];
            [hostReach startNotifier];
        }
    }
}


- (void) doPush:(id)sender{
    NSMutableArray *ar = (NSMutableArray *)sender;
    UINavigationController *n = [ar objectAtIndex:0];
    UIViewController *vc = [ar objectAtIndex:1];
    BOOL animated = [(NSNumber *)[ar objectAtIndex:2] boolValue];
    [n pushViewController:vc animated:animated];
} 

-(void)doPopPush:(UINavigationController *)navCtrler popCtrler:(UIViewController *)popCtrler pushCtrler:(UIViewController *)pushCtrler animated:(BOOL)animated {
    [navCtrler popToViewController:popCtrler animated:NO];
    NSMutableArray *ar = [[NSMutableArray alloc] init];
    [ar addObject:navCtrler];
    [ar addObject:pushCtrler];
    [ar addObject:[NSNumber numberWithBool:animated]]; 
    [self performSelector:@selector(doPush:) withObject:ar afterDelay:0.05];
}

#pragma mark - Audio Functions

- (void)initAudioPlayer{
	if (self.audioPlayer == nil) {
		AudioController *ac = [[[AudioController alloc] init] retain];
		self.audioPlayer = ac;
		[ac release];
	}
}

#pragma mark - Information Functions
- (ViewHelpTipsInfo *)showInfo:(NSString *)infoTitle 
                      withInfo:(NSString *)infoDetail 
                 containerView:(UIView *)containerView 
                   appPosition:(enAppPosition)appPosition {
	CGFloat x = containerView.frame.origin.x;
	CGFloat y = containerView.frame.origin.y;
	CGFloat w = containerView.frame.size.width;
	CGFloat h = containerView.frame.size.height;
	CGRect r = CGRectMake(x, y, w, h);
	ViewHelpTipsInfo *iH = [[ViewHelpTipsInfo alloc] initWithFrame:r withToggle:YES];
    NSString *fileToPlay = nil;
    if (appPosition) {
        iH.appPosition = appPosition;
        switch (appPosition) {
            case enAppPositionVASPre:
                fileToPlay = @"f_PreVas";
                break;
            case enAppPositionBreathe:
                fileToPlay = @"f_PreStart";
                break;
            default:
                break;
        }
    }
	iH.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
	[containerView addSubview:iH];
    [iH updateLayout:r];
    if (fileToPlay) {
        iH.playFile = fileToPlay;
    }
	[iH showInfo:infoTitle tipText:infoDetail];
    [iH release];
    //[Analytics logEvent:[NSString stringWithFormat:@"GUIDE VIEW %@", infoTitle]];

	return iH;
}

#pragma mark - Event Count Functions
- (int)eventCount:(NSString *)eventName {
    NSString *eName = [NSString stringWithFormat:@"evnt%@",eventName];
    int result = [[self.datalayer getSettingValue:eName andDefaultValue:@"0"] intValue];
    return result;
}
- (int)incrementEventCount:(NSString *)eventName {
    NSString *eName = [NSString stringWithFormat:@"evnt%@",eventName];
    int result = [[self.datalayer getSettingValue:eName andDefaultValue:@"0"] intValue] + 1;
    [self.datalayer saveSetting:eName andValue:[NSString stringWithFormat:@"%d",result]];
    return result;
}
- (void)setEventCount:(NSString *)eventName eventCount:(int)value {
    NSString *eName = [NSString stringWithFormat:@"evnt%@",eventName];
    [self.datalayer saveSetting:eName andValue:[NSString stringWithFormat:@"%d",value]];
}
- (BOOL)finishedPersonalize {
    if ([self eventCount:@"SetupScenes"] == 0) {
        return NO;
    }
    if ([self eventCount:@"SetupMusic"] == 0) {
        return NO;
    }
    if ([self eventCount:@"SetupInhale"] == 0) {
        return NO;
    }
    if ([self eventCount:@"SetupExhale"] == 0) {
        return NO;
    }
    return YES;
}

- (void)checkBCConnection {
    // init Brightcove Media API
    NSString *apiKey = [self getAppSetting:@"Brightcove" withKey:@"apikey"];
    BCMediaAPI *bcServ = [[[BCMediaAPI alloc] initWithReadToken:apiKey] retain];
    [bcServ setMediaDeliveryType:BCMediaDeliveryTypeHTTP];
    long long videoID = [[self getAppSetting:@"Brightcove" withKey:@"demo"] longLongValue];
    NSError *err;
    BCVideo *vid = (BCVideo *)[bcServ findVideoById:videoID error:&err];
    if (!vid) {
        useYouTube = YES;
        NSString *errStr = [bcServ getErrorsAsString:err];
        NSLog(@"%@",errStr);
        NSLog(@"Using YouTube");
    } else {
        useYouTube = NO;
    }
    vid = nil;
    bcServices = bcServ;
    [bcServ release];
}
@end
