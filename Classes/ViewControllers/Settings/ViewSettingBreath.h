//
//  ViewSettingBreath.h
//  iBreath160
//
//  Created by Roger Reeder on 1/26/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerSettings.h"

@interface ViewSettingBreath : UIViewController {
	IBOutlet UIButton *bBreathe;
	IBOutlet UILabel *lTime;
	IBOutlet UILabel *lLastTime;
	IBOutlet UILabel *lMoveTime;
	IBOutlet UIImageView *imgBall;
	IBOutlet UILabel *lInstructions;

	IBOutlet UIView *vDialog;
	IBOutlet UILabel *lDialogMessage;
	IBOutlet UIButton *bSave;
	IBOutlet UIButton *bCancel;
	int breathInflate;
	int breathDeflate;
	int tempBreath;
	NSTimer *timer;
	BOOL bInhale;
	CGPoint ballCenter;
	CGFloat ballWidth;
	int inhaleTimes[5];
	int breathes;
	int shortestBreath;
	int longestBreath;
    PlayerSettings *settings;
    BOOL inhaling;
}

@property(nonatomic, retain) PlayerSettings *settings;

@property(nonatomic, retain) IBOutlet UIButton *bBreathe;
@property(nonatomic, retain) IBOutlet UILabel *lTime;
@property(nonatomic, retain) IBOutlet UILabel *lLastTime;
@property(nonatomic, retain) IBOutlet UILabel *lMoveTime;
@property(nonatomic, retain) IBOutlet UILabel *lInstructions;
@property(nonatomic, retain) IBOutlet UIView *vDialog;
@property(nonatomic, retain) IBOutlet UILabel *lDialogMessage;
@property(nonatomic, retain) IBOutlet UIButton *bSave;
@property(nonatomic, retain) IBOutlet UIButton *bCancel;
@property(nonatomic) int breathInflate;
@property(nonatomic) BOOL inhaling;
@property(nonatomic, retain) IBOutlet UIImageView *imgBall;

- (void)bBreathe_TouchUp:(id)sender;
- (void)bBreathe_Down:(id)sender;

- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
- (void)slideUpTime;
- (void)fadeOutInstructions;
- (void)fadeInInstructions;

- (void)countUp;

- (void)contractBall;
- (void)expandBall;
@end
