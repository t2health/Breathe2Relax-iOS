//
//  ViewSettingBreath.h
//  iBreath160
//
//  Created by Roger Reeder on 1/26/11.
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
