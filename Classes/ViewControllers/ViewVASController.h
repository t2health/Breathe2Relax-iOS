//
//  ViewVASController.h
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/4/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewSlider.h"
#import "ViewCheckboxController.h"
#import "ViewHelpTipsInfo.h"

@interface ViewVASController : UIViewController {
    IBOutlet UIImageView *ivBackground;
    IBOutlet UIView *vSlider;
    IBOutlet UIButton *bNext;
    IBOutlet UIButton *bSkip;
    IBOutlet UILabel *lblInfo;
    IBOutlet UILabel *lblTitle;
    ViewCheckboxController *checkboxController;
    IBOutlet UIView *vCheckbox;
    ViewSlider *vsStress;
    int vasState;
    UIDeviceOrientation orientation;
    ViewHelpTipsInfo *helpTips;
    BOOL showTheGuide;
    
}
@property (nonatomic) int vasState;
@property (nonatomic, retain) ViewSlider *vsStress;
@property (nonatomic, retain) IBOutlet UIImageView *ivBackground;
@property (nonatomic, retain) IBOutlet UIView *vSlider;
@property (nonatomic, retain) IBOutlet UIButton *bNext;
@property (nonatomic, retain) IBOutlet UIButton *bSkip;
@property (nonatomic, retain) IBOutlet UILabel *lblInfo;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) ViewCheckboxController *checkboxController;
@property (nonatomic, retain) IBOutlet UIView *vCheckbox;

- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
- (void)fadeOutVAS;
- (void)fadeInVAS;

- (void)showGuide;

- (IBAction)bNext_Click:(id)sender;
- (IBAction)bSkip_Click:(id)sender;
- (void)skipToBreatheController;
- (void)showBreatheController;
- (void)updateVASSlider;
@end
