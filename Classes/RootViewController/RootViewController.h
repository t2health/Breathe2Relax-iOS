//
//  RootViewController.h
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
#import <UIKit/UIKit.h>
//#import "ViewHelpTips.h"
#import "ViewHelpTipsInfo.h"

@interface RootViewController : UIViewController {
    
    IBOutlet UIButton *bBreathe;
    IBOutlet UIButton *bShowMe;
    IBOutlet UIButton *bSetup;
    IBOutlet UIButton *bResults;
    IBOutlet UIButton *bLearn;
    IBOutlet UIButton *bAbout;
    IBOutlet UIButton *bTips;
    IBOutlet UIButton *bPersonalize;
   
	ViewHelpTipsInfo *vHelpTipsInfo;
}
@property (nonatomic, retain) ViewHelpTipsInfo *vHelpTipsInfo;

@property (nonatomic, retain) IBOutlet UIButton *bTips;
@property (nonatomic, retain) IBOutlet UIButton *bBreathe;
@property (nonatomic, retain) IBOutlet UIButton *bShowMe;
@property (nonatomic, retain) IBOutlet UIButton *bSetup;
@property (nonatomic, retain) IBOutlet UIButton *bResults;
@property (nonatomic, retain) IBOutlet UIButton *bLearn;
@property (nonatomic, retain) IBOutlet UIButton *bAbout;
@property (nonatomic, retain) IBOutlet UIButton *bPersonalize;

- (IBAction)bBreathe_Click:(id)sender;
- (IBAction)bShowMe_Click:(id)sender;
- (IBAction)bSetup_Click:(id)sender;
- (IBAction)bResults_Click:(id)sender;
- (IBAction)bLearn_Click:(id)sender;
- (IBAction)bAbout_Click:(id)sender;
- (IBAction)bT2Logo_Click:(id)sender;

- (IBAction)btip_Click:(id)sender;
- (IBAction)bPersonalize_Click:(id)sender;

- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
- (void)fadeOutRoot;
- (void)fadeInRoot;
- (void)moveBreathe;
- (void)showHealthTips;
@end
