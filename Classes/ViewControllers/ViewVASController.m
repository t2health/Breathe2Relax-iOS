//
//  ViewVASController.m
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
#import "ViewVASController.h"
#import "ViewBreatheController.h"

#import "B2RAppDelegate.h"
#import "ObjectDataAccess.h"
#import "PlayerSettings.h"
#import "Visual.h"

#import "Analytics.h"

@implementation ViewVASController

@synthesize bNext;
@synthesize bSkip;
@synthesize lblTitle;
@synthesize lblInfo;
@synthesize vSlider;
@synthesize vsStress;
@synthesize vasState;
@synthesize ivBackground;
@synthesize checkboxController;
@synthesize vCheckbox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        vasState = 0;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)showGuide {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.vasState == 0 && showTheGuide) {
        showTheGuide = NO;
        helpTips = [appDelegate showInfo:[appDelegate.firstTime getGuideTitleForPosition:enAppPositionVASPre] 
                                withInfo:[appDelegate.firstTime getGuideDetailForPosition:enAppPositionVASPre] 
                           containerView:self.view appPosition:enAppPositionVASPre];
//        [appDelegate.audioPlayer preparePlayer:enSCAmbient andMP3File:@"f_PreVas" andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:nil];
//        [appDelegate.audioPlayer play:enSCAmbient];
    } else {
        self.lblInfo.text = @"";
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    orientation = [[UIDevice currentDevice] orientation];
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSDictionary *ps = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"app" ofType:@"plist"]] 
														mutabilityOption:NSPropertyListImmutable 
																  format:nil 
                                                        errorDescription:nil];
	NSDictionary *comments = (NSDictionary *)[ps objectForKey:@"Comments"];
    NSString *ext = self.vasState == 0 ? @"Pre" : @"Post";
    showTheGuide = [appDelegate.firstTime showGuideForPosition:enAppPositionVASPre];
    self.lblTitle.text = [comments objectForKey:[NSString stringWithFormat:@"%@VASTitle",ext]];
    if (showTheGuide) {
        self.lblInfo.text = [comments objectForKey:[NSString stringWithFormat:@"%@VASInfo",ext]];
    } else {
        self.lblInfo.text = @"";
    }
    
    self.bSkip.hidden = (self.vasState != 0);
    [self.bNext setTitle:[NSString stringWithFormat:@"%@",(self.vasState == 0) ? @"Next" : @"Finish"] forState:UIControlStateNormal];
	
	Visual *vis = (Visual *) [appDelegate.visuals objectAtIndex:appDelegate.playerSettings.visual];
    NSString *bundleName = [NSString stringWithFormat:@"%@%d.%@",vis.bundleName,RANDOM_INT(1, vis.numberOfFrames), vis.postFix];
    self.ivBackground.image = [UIImage imageNamed:bundleName];
    if (!appDelegate.firstTime.skipVAS) {
        ViewCheckboxController *vc = [[ViewCheckboxController alloc] initWithNibName:@"ViewCheckboxController" bundle:nil];
        vc.view.frame = CGRectMake(0.0f, 0.0f, self.vCheckbox.frame.size.width, self.vCheckbox.frame.size.height);
        [self.vCheckbox addSubview:vc.view];
        self.checkboxController = vc;
        [vc release];
    }
    [self updateVASSlider];

}

- (void)viewWillAppear:(BOOL)animated {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if (helpTips) {
        [helpTips updateLayout:self.view.frame];
    }
    [self updateVASSlider];
    [appDelegate.audioPlayer stopAll];

}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:[NSString stringWithFormat:@"VAS %@ VIEW ", self.vasState == 0 ? @"PRE" : @"POST"]];
}
 
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self.checkboxController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL result = NO;
    if ((UIInterfaceOrientationIsLandscape(interfaceOrientation) && UIInterfaceOrientationIsLandscape(orientation)) || (UIInterfaceOrientationIsPortrait(interfaceOrientation) && UIInterfaceOrientationIsPortrait(orientation))) {
        result = YES;
    }
    //return result;
    return YES;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self fadeOutVAS];

}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (helpTips) {
        [helpTips updateLayout:self.view.frame];
    } else {
        self.lblInfo.text = @"";
    }
    
    [self updateVASSlider];
    [self fadeInVAS];
}


#pragma mark -
#pragma mark Controller Animation Cycle
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if ((animationID == @"fadeInVas")/* && finished*/) {
        [self showGuide];
	}
	if ((animationID == @"fadeOutVAS")/* && finished*/) {  
	}
}	

- (void)fadeOutVAS {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutVAS" context:nil];
	[UIView setAnimationDuration:0.25f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)fadeInVAS {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInVas" context:nil];
	[UIView setAnimationDuration:0.25f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 1.0f;
	[UIView commitAnimations];
}

- (IBAction)bNext_Click:(id)sender {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.vasState == 0) {
        appDelegate.preVASValue = self.vsStress.slider.value;
        if (self.checkboxController) {
            if (self.checkboxController.checkboxSelected) {
                appDelegate.playerSettings.trackOn = NO;
                [appDelegate saveSettings];
                appDelegate.firstTime.skipVAS = YES;
            }
        }
        if (appDelegate.firstTime.skipVAS) {
            [self skipToBreatheController];
        } else {
            [self showBreatheController];
        }
    } else {
        int r = [appDelegate.datalayer insertSession:nil];
        appDelegate.datalayer.sessionID = r;
        [appDelegate.datalayer insertResult:0 withScaleID:1 withValue:appDelegate.preVASValue withTimestamp:nil];
        [appDelegate.datalayer insertResult:1 withScaleID:1 withValue:self.vsStress.slider.value withTimestamp:nil];
        BOOL madeChanges = FALSE;
        if (appDelegate.preVASValue != self.vsStress.slider.value) {
            madeChanges = TRUE;
        }
        if (madeChanges) {
            NSDictionary *myParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%4.1f",self.vsStress.slider.value-(100.0f - appDelegate.preVASValue)],@"Relax",nil];
            [appDelegate flurrySubmitVAS:myParams];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)bSkip_Click:(id)sender {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.firstTime.skipVAS = YES;
    [self skipToBreatheController];
}

- (void)skipToBreatheController {
    NSString *controllerBundle = @"ViewBreatheController-iphone";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        controllerBundle = @"ViewBreatheController-ipad";
    }
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    int popCtrlIndex = [self.navigationController.viewControllers count] - 2;
    if (popCtrlIndex >= 0) {
        ViewBreatheController *anotherController = [[ViewBreatheController alloc] initWithNibName:controllerBundle bundle:nil];
        anotherController.title = @"Breathe";
        [appDelegate doPopPush:self.navigationController popCtrler:[self.navigationController.viewControllers objectAtIndex:popCtrlIndex] pushCtrler:anotherController animated:YES];
        [anotherController release];
    }
}

- (void)showBreatheController {
    NSString *controllerBundle = @"ViewBreatheController-iphone";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        controllerBundle = @"ViewBreatheController-ipad";
    }
    ViewBreatheController *anotherController = [[ViewBreatheController alloc] initWithNibName:controllerBundle bundle:nil];
    anotherController.title = @"Breathe";
    [self.navigationController pushViewController:anotherController animated:YES];
    [anotherController release];
}

- (void)updateVASSlider {
    CGRect rect = CGRectMake(0.0f, 0.0f, self.vSlider.frame.size.width, self.vSlider.frame.size.height);
    CGFloat labelHeight = rect.size.height * 0.4f;
    
    CGFloat labelWidth = rect.size.width * 0.5;
    UILabel *lbl= [[[UILabel alloc] initWithFrame:CGRectMake( 0.0f , 0.0f, labelWidth, labelHeight)] autorelease];
    UIFont *fLabel = [UIFont fontWithName:@"Helvetica" size:labelHeight];
    lbl.font = fLabel;
    [lbl setTextAlignment: UITextAlignmentCenter];
    [lbl setLineBreakMode:UILineBreakModeClip];
    lbl.text = @"Stressed";
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    int fontSize = [appDelegate MaxOfFontForLabel:lbl andWidth:labelWidth andHeight:labelHeight];
    if (self.vsStress) {
        [self.vsStress updateLayout:rect s:fontSize w:labelWidth];
    } else {
        ViewSlider *vs = [[ViewSlider alloc] initWithFrame:rect l:@"Relaxed" r:@"Stressed" s:fontSize w:labelWidth];
        vs.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.5f alpha:0.0f];
        [self.vSlider addSubview:vs];
        self.vsStress = vs;
        [vs release];
    }
    
}


@end
