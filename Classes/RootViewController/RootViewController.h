//
//  RootViewController.h
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/2/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

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
