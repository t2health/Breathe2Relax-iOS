//
//  ViewBreatheController.h
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/4/11.
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
#import <UIKit/UIKit.h>
#import "ViewPracticeScenery.h"
#import "ViewTubeGauge.h"
#import "AudioController.h"
#import "ViewHelpTipsInfo.h"

typedef enum {
	enPracticeStateStopped = 0,
	enPracticeStatePaused,
	enPracticeStateRunning
} enPracticeState;

typedef enum {
    enSpeedNone = 0,
    enSpeedUp,
    enSpeedDown
} enSpeedState;

@interface ViewBreatheController : UIViewController {
	NSTimer *timer;
	NSTimeInterval timeInterval;
	CGFloat animationInterval;
	int breathPosition;
	BOOL breathInhaling;
	int audioPart;
	int cycle;
    int newBreathSpanIn;
    int newBreathSpanOut;
	int startPos[enSCAmbient+1];  //Set start time for all cycles and channels.
	BOOL hasPlayed[enSCAmbient+1];
	int inhaleTracks;
	int exhaleTracks;
	float fVASValues[4];
    
    IBOutlet UIImageView *ivBackground;
    
    IBOutlet UIButton *bMiddle;
    IBOutlet UIButton *bLeft;
    IBOutlet UIButton *bRight;
    
    IBOutlet UILabel *lStart;
    
    IBOutlet UIView *vPractice;
    
    ViewPracticeScenery *vPracticeScenery;
	ViewTubeGauge *vTubeGauge;
    
    UIDeviceOrientation orientation;
    
    enPracticeState practiceState; // 0 - Stopped, 1 - Running
    enSpeedState speedState;
    ViewHelpTipsInfo *helpTips;
}
@property (nonatomic, retain) IBOutlet UIImageView *ivBackground;
@property (nonatomic, retain) IBOutlet UIButton *bMiddle;
@property (nonatomic, retain) IBOutlet UILabel *lStart;
@property (nonatomic, retain) IBOutlet UIButton *bLeft;
@property (nonatomic, retain) IBOutlet UIButton *bRight;
@property (nonatomic, retain) IBOutlet UIView *vPractice;
@property (nonatomic, retain) ViewPracticeScenery *vPracticeScenery;
@property (nonatomic, retain) ViewTubeGauge *vTubeGauge;


- (void)bBack: (id) sender;
- (void)bDone: (id) sender;

- (void)startPractice:(int)startCycle;
- (void)startAnimatedPractice;
- (void)adjustSpeed:(BOOL)faster;
- (void)stopPractice;
- (void)initPracticeScenery:(NSString *) overlayFile;
- (void)closePracticeScenery;

- (void)initTubeGauge;
- (void)closeTubeGauge;

- (void)updatePractice:(NSTimer *)theTimer;

- (void)loadPlayer:(int)cycleToPlay;
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;

- (IBAction)bLeft_Click:(id)sender;
- (IBAction)bMiddle_Click:(id)sender;
- (IBAction)bRight_Click:(id)sender;
- (IBAction)bButton_Up:(id)sender;
- (void)bCancel_Click:(id)sender;

- (void)proceed;

- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
- (void)fadeOutLabel;
- (void)fadeInLabel;

- (void)refreshButtons;
@end
