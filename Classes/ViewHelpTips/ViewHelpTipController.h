//
//  ViewHelpTipController.h
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/6/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewCheckboxController.h"
@interface ViewHelpTipController : UIViewController {
    ViewCheckboxController *chkBox;
    IBOutlet UIView *vChkBox;
}
@property (nonatomic, retain) IBOutlet UIView *vChkBox;
@property (nonatomic, retain) ViewCheckboxController *chkBox;

- (IBAction)bClose_Click:(id)sender;
@end
