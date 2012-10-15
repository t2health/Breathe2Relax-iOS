//
//  ViewLearnController.h
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/3/11.
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
#import "ViewHelpTipsInfo.h"


@interface ViewLearnController : UIViewController {
    UIButton *bLearn1;
    UILabel *lblLearn1;
    UIButton *bLearn2;
    UILabel *lblLearn2;
    UIButton *bLearn3;
    UILabel *lblLearn3;
    UISegmentedControl *sWatchLearn;
    UILabel *lblNetworkStatus;
    UIView *vContainer;
    ViewHelpTipsInfo *helpTips;
    
}
@property (nonatomic, retain) IBOutlet UIView *vContainer;
@property (nonatomic, retain) IBOutlet UIButton *bLearn1;
@property (nonatomic, retain) IBOutlet UILabel *lblLearn1;
@property (nonatomic, retain) IBOutlet UIButton *bLearn2;
@property (nonatomic, retain) IBOutlet UILabel *lblLearn2;
@property (nonatomic, retain) IBOutlet UIButton *bLearn3;
@property (nonatomic, retain) IBOutlet UILabel *lblLearn3;
@property (nonatomic, retain) IBOutlet UISegmentedControl *sWatchLearn;
@property (nonatomic, retain) IBOutlet UILabel *lblNetworkStatus;

- (IBAction)button1_click:(id)sender;
- (IBAction)button2_click:(id)sender;
- (IBAction)button3_click:(id)sender;
- (IBAction)toggle_change:(id)sender;

- (void)refreshControls;
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
- (void)fadeOutLearn;
- (void)fadeInLearn;
- (void)fadeRenewLearn;
- (void)showVideo:(NSString *)title video:(NSString *)video;
- (void)showBCVideo:(NSString *)title videoName:(NSString *)videoName;
@end
