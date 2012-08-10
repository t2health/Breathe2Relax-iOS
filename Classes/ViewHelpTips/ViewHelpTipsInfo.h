//
//  ViewHelpTipsInfo.h
//  iBreathe140
//
//  Created by Roger Reeder on 9/24/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewCheckboxController.h"

@interface ViewHelpTipsInfo : UIView {
	UIView *vBackground;
	UIImageView *ivBoxB;
	UIImageView *ivBoxBL;
	UIImageView *ivBoxBR;
	UIImageView *ivBoxC;
	UIImageView *ivBoxCL;
	UIImageView *ivBoxML;
	UIImageView *ivBoxMR;
	UIImageView *ivBoxT;
	UIImageView *ivBoxTL;
	UIImageView *ivBoxTR;
	
	UIView *vContainer;
	UIView *vDialog;
	
	UIImageView *ivTop;
	UIImageView *ivMiddle;
	UIImageView *ivBottom;
	UILabel *lblTitle;
	
	UIWebView *wvInfo;
	
	UIButton *bClose;
	NSString *sUrl;
	NSString *sText;
	NSString *sTitle;
	UIImageView *ivShaderB;
	ViewCheckboxController *checkShowAgain;
    enAppPosition appPosition;
    NSString *playFile;
    NSString *tipString;
}	
@property (nonatomic, retain) NSString *playFile;
@property (nonatomic, retain) NSString *sURL;
@property (nonatomic, retain) NSString *sText;
@property (nonatomic, retain) NSString *sTitle;
@property (nonatomic, retain) ViewCheckboxController *checkShowAgain;
@property (nonatomic) enAppPosition appPosition;
@property (nonatomic, retain) NSString *tipString;

- (id)initWithFrame:(CGRect)frame withToggle:(BOOL)toggle;
- (void)initDisplay:(bool)toggle;
- (void)updateLayout:(CGRect)frame;
- (void)animClose;
- (void)animShow;
- (void)showInfo:(NSString *)titleOfPart tipText:(NSString *)tipToShow;
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;

- (void)reloadString;
@end
