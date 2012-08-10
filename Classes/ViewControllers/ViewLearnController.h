//
//  ViewLearnController.h
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/3/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

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
