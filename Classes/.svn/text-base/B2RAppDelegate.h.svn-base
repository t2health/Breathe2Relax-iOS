//
//  B2RAppDelegate.h
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/2/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Analytics.h"

#import "ObjectDataAccess.h"
#import "PlayerSettings.h"
#import "FirstTime.h"
#import "Music.h"
#import "AudioController.h"
#import "Reachability.h"
#import "ViewHelpTipsInfo.h"
#import "BCMediaAPI.h"

#define MINBREATHLENGTH 2500
#define MAXBREATHLENGTH 16000
#define REFBREATHLENGTH 9000
#define DEFAULTBREATHLENGTH 7200
#define DEFAULTPAUSELENGTH 1000
#define TUBEWIDTHRATIO 0.15f
#define SOUNDGAP 0.1f

@interface B2RAppDelegate : NSObject <UIApplicationDelegate> {
    NSArray *visuals;
    PlayerSettings *playerSettings;
	FirstTime *firstTime;
    NSArray *music;
    int cycle;
	ObjectDataAccess *datalayer;
    AudioController *audioPlayer;
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
    NetworkStatus networkStatus;
    BOOL connectionRequired;
    float preVASValue;
	BCMediaAPI *bcServices;
    BOOL useYouTube;
    
}
@property (nonatomic) BOOL useYouTube;
@property (nonatomic) float preVASValue;
@property (nonatomic) BOOL connectionRequired;
@property (nonatomic) NetworkStatus networkStatus;
@property (nonatomic, retain) AudioController *audioPlayer;
@property (nonatomic, retain) ObjectDataAccess *datalayer;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) NSArray *visuals;
@property (nonatomic, retain) PlayerSettings *playerSettings;
@property(nonatomic, retain) FirstTime *firstTime;
@property (nonatomic, retain) NSArray *music;

@property (nonatomic, readonly) BCMediaAPI *bcServices;

-(void) flurryPageView:(NSString *)PageViewed;
-(void) flurryStartBreathing:(NSString *)startType;
-(void) flurryEndBreathing:(NSString *)endType;
-(void) flurrySubmitVAS:(NSDictionary *)parameters;

-(void)getSettings;
-(NSArray *)getMusic;
-(NSArray *)getVisuals;
-(void)getFirstTime;
-(void)saveSettings;
-(void)savePracticeSettings:(PlayerSettings *)settings;
-(BOOL)checkInternet;
-(void)reachabilityChanged:(NSNotification* )note;
-(void)updateInterfaceWithReachability:(Reachability*)curReach;

-(NSString *)getAppSetting:(NSString *)group withKey:(NSString *)key;
-(void)SizeFontToFitLabel:(UILabel *)lbl andWidth:(CGFloat)width andHeight:(CGFloat)height;
-(int)MaxOfFontForLabel:(UILabel *)lbl andWidth:(CGFloat)width andHeight:(CGFloat)height;
-(CGFloat)getImageAspect:(UIImage *)img;

-(void) doPush:(id)sender;
-(void)doPopPush:(UINavigationController *)navCtrler popCtrler:(UIViewController *)popCtrler pushCtrler:(UIViewController *)pushCtrler animated:(BOOL)animated;

- (void)initAudioPlayer;
- (void)closeAudioPlayer;

- (ViewHelpTipsInfo *)showInfo:(NSString *)infoTitle withInfo:(NSString *)infoDetail containerView:(UIView *)containerView appPosition:(enAppPosition)appPosition;

- (int)eventCount:(NSString *)eventName;
- (int)incrementEventCount:(NSString *)eventName;
- (void)setEventCount:(NSString *)eventName eventCount:(int)value;
- (BOOL)finishedPersonalize;

- (void)checkBCConnection;
@end
