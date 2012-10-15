//
//  RootViewController.m
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
#import "RootViewController.h"

#import "B2RAppDelegate.h"

#import "ViewSettingListController.h"
#import "ViewLearnController.h"
#import "ViewReaderController.h"
#import "ViewVASController.h"
#import "ViewChartController.h"
#import "ViewVideoController.h"
#import "ViewBCVideoController.h"
#import "ViewBreatheController.h"
#import "ViewPersonalizeController.h"
#import "ViewWebSiteController.h"
#import "ViewChartWrapperController.h"

@implementation RootViewController

@synthesize bBreathe;
@synthesize bShowMe;
@synthesize bSetup;
@synthesize bResults;
@synthesize bLearn;
@synthesize bAbout;
@synthesize bTips;
@synthesize vHelpTipsInfo;
@synthesize bPersonalize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    bShowMe.titleLabel.numberOfLines = 2;
    bShowMe.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    bShowMe.titleLabel.textAlignment = UITextAlignmentCenter;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    self.navigationController.navigationBar.hidden = YES;
    [appDelegate.audioPlayer stopAll];

}
- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"HOME VIEW"];
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL finishedPersonalize = [appDelegate finishedPersonalize];
    if ([appDelegate eventCount:@"Personalize"] == 0) {
        [self fadeInRoot];
        UIViewController *anotherController = (UIViewController *)[[ViewPersonalizeController alloc] initWithNibName:@"ViewPersonalizeController" bundle:nil];
        anotherController.title = @"Personalize";
        [self.navigationController pushViewController:anotherController animated:YES];
        [anotherController release];
    } else {
        self.bPersonalize.hidden = finishedPersonalize;
        if ([appDelegate.firstTime showGuideForPosition:enAppPositionRoot]) {
        vHelpTipsInfo = [appDelegate showInfo:[appDelegate.firstTime getGuideTitleForPosition:enAppPositionRoot] 
                                     withInfo:[appDelegate.firstTime getGuideDetailForPosition:enAppPositionRoot] 
                                containerView:self.view appPosition:enAppPositionRoot];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self fadeOutRoot];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [vHelpTipsInfo updateLayout:self.view.frame];
    [self fadeInRoot];
}

- (IBAction)btip_Click:(id)sender {
    [self showHealthTips];
}

- (IBAction)bBreathe_Click:(id)sender{
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL VASisDone = [appDelegate.datalayer isAlreadySession:nil];
    NSString *controllerBundle = @"";
    UIViewController *anotherController = nil;
    if (VASisDone || appDelegate.firstTime.skipVAS) {
        controllerBundle = @"ViewBreatheController-iphone";
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            controllerBundle = @"ViewBreatheController-ipad";
        }
        anotherController = (UIViewController *)[[ViewBreatheController alloc] initWithNibName:controllerBundle bundle:nil];
        anotherController.title = @"Breathe";
        [self.navigationController pushViewController:anotherController animated:YES];
    } else {
        controllerBundle = @"ViewVASController-iphone";
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            controllerBundle = @"ViewVASController-ipad";
        }
        anotherController = (UIViewController *)[[ViewVASController alloc] initWithNibName:controllerBundle bundle:nil];
        anotherController.title = @"Rate Your Stress";
        anotherController.view.alpha = 0.0f;
        [self.navigationController pushViewController:anotherController animated:YES];
        [(ViewVASController *)anotherController fadeInVAS];        
    }
    [anotherController release];
}


- (IBAction)bShowMe_Click:(id)sender{
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *msg = @"";
    BOOL hasInternet = NO;
    switch (appDelegate.networkStatus) {
        case NotReachable:
            hasInternet = NO;
            msg = @"Can't stream video, there's no internet connection, try again later or from another location";
            break;
        default:
            if (appDelegate.connectionRequired) {
                msg = @"Can't stream video, network available but connection not established, try again later or from another location";
            } else {
                hasInternet = YES;
            }
            break;
    }
    if (hasInternet) {
        NSString *controllerBundle;
        if (appDelegate.useYouTube) {
            controllerBundle = @"ViewVideoController";
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                controllerBundle = @"ViewVideoController";
            }
            
            ViewVideoController *anotherController = [[ViewVideoController alloc] initWithNibName:controllerBundle bundle:nil];
            anotherController.title = @"Watch Demonstration";
            B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
            anotherController.moviePath = [appDelegate getAppSetting:@"URLs" withKey:@"demo"];
            anotherController.movieDescription = @"demo";
            [self.navigationController pushViewController:anotherController animated:YES];
            [anotherController release];
        } else {
            controllerBundle = @"ViewBCVideoController";
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                controllerBundle = @"ViewBCVideoController";
            }
            
            ViewBCVideoController *anotherController2 = [[ViewBCVideoController alloc] initWithNibName:controllerBundle bundle:nil];
            anotherController2.title = @"Watch Demonstration";
            B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
            long long videoID = [[appDelegate getAppSetting:@"Brightcove" withKey:@"demo"] longLongValue];
            anotherController2.videoDescription = @"demo";
            anotherController2.videoID = videoID;
            [self.navigationController pushViewController:anotherController2 animated:YES];
            [anotherController2 release];
            
        }
        
    } else {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"How to Video"
                                                     message:msg 
                                                    delegate:self 
                                           cancelButtonTitle:@"Ok" 
                                           otherButtonTitles: nil];
        [av show];
        [av release];
        
    }
    
    
}
- (IBAction)bSetup_Click:(id)sender{
    ViewSettingListController *anotherController = [[ViewSettingListController alloc] initWithNibName:@"ViewSettingListController" bundle:nil];
    anotherController.title = @"Settings";
    [self.navigationController pushViewController:anotherController animated:YES];
    [anotherController release];
}
- (IBAction)bResults_Click:(id)sender{
    ViewChartWrapperController *anotherController = [[ViewChartWrapperController alloc] initWithNibName:@"ViewChartWrapperController" bundle:nil];
    
    
    anotherController.numberOfCharts = 1;
	anotherController.view.alpha = 0.0;
    anotherController.title = @"Results";
    [self.navigationController pushViewController:anotherController animated:YES];
    
	[anotherController updateLayout:self.navigationController.view.frame];
    [anotherController release];

}
- (IBAction)bLearn_Click:(id)sender{
    NSString *controllerBundle = @"ViewLearnController-iphone";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        controllerBundle = @"ViewLearnController-ipad";
    }
    ViewLearnController *anotherController = [[ViewLearnController alloc] initWithNibName:controllerBundle bundle:nil];
    anotherController.title = @"Learn";
    [self.navigationController pushViewController:anotherController animated:YES];
    [anotherController release];
}
- (IBAction)bAbout_Click:(id)sender{
	ViewReaderController *vcReader = [ViewReaderController alloc];
	vcReader.view.alpha = 0.0;
    vcReader.title = @"About";
	CGRect r = self.view.frame;
	[vcReader updateLayout:r];
    vcReader.pixelsPerFrame = 1.0f;
    vcReader.animationInterval = 1.0f / 15.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        vcReader.pixelsPerFrame = 1.0f;
        vcReader.animationInterval = 1.0f / 15.0f;
    }

    [self.navigationController pushViewController:vcReader animated:YES];
	[vcReader loadHTML:@"about"];
	[vcReader fadeInReader];
    [vcReader release];
    
}
- (IBAction)bPersonalize_Click:(id)sender{
    UIViewController *anotherController = (UIViewController *)[[ViewPersonalizeController alloc] initWithNibName:@"ViewPersonalizeController" bundle:nil];
    anotherController.title = @"Personalize";
    [self.navigationController pushViewController:anotherController animated:YES];
    [anotherController release];
}

- (IBAction)bT2Logo_Click:(id)sender {
    //Show url
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *url = [appDelegate getAppSetting:@"URLs" withKey:@"T2"];
    
    ViewWebSiteController *controller = [[ViewWebSiteController alloc] initWithNibName:@"ViewWebSiteController" bundle:nil];
    controller.url = url;
    
    //controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //[self presentModalViewController:controller animated:YES];
    controller.title = @"T2HEALTH.ORG";
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    
}

#pragma mark -
#pragma mark Controller Animation Cycle
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if ((animationID == @"fadeOutRoot")/* && finished*/) {  
	}
	if ((animationID == @"fadeInRoot")/* && finished*/) {
        //[self moveBreathe];
	}
}	

- (void)fadeOutRoot {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutRoot" context:nil];
	[UIView setAnimationDuration:0.25f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)fadeInRoot {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInRoot" context:nil];
	[UIView setAnimationDuration:0.25f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)moveBreathe {

    CGRect newRect = CGRectMake(self.bBreathe.center.x - self.bBreathe.frame.size.width, 
                                 self.bBreathe.frame.origin.y - self.bBreathe.frame.size.height * 2.0f, 
                                 self.bBreathe.frame.size.width * 2.0f, 
                                 self.bBreathe.frame.size.height * 2.0f);
	[UIView beginAnimations:@"moveBreathe" context:nil];
	[UIView setAnimationDuration:2.0f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
    [self.bBreathe setFrame:newRect];
	[UIView commitAnimations];
    
}

#pragma mark -
#pragma mark Health Tips Functions
- (void)showHealthTips {
	//CGRect r = [[UIScreen mainScreen] bounds];
	//[self flurryPageView:@"Help Tips"];
    
	CGFloat x,y,w,h;
	//if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
		x = self.view.frame.origin.x;
		y = self.view.frame.origin.y;
		w = self.view.frame.size.width;
		h = self.view.frame.size.height;
	//}else {
	//	x = self.view.frame.origin.x;
	//	y = 0.0f;
	//	h = (self.view.frame.size.width - self.view.frame.origin.y);
	//	w = self.view.frame.size.height;
	//}
	CGRect r = CGRectMake(x, y, w, h);
	ViewHelpTipsInfo *iH = [[ViewHelpTipsInfo alloc] initWithFrame:r withToggle:NO];
	iH.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
	[self.view addSubview:iH];
    vHelpTipsInfo = iH;
	[iH release];
	
	NSDate *today = [NSDate date];
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"DDD"]; //setting the date formater object
	int julianDate = [[formatter stringFromDate:today] intValue];
	NSString *tip;
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	NSArray *records =	[appDelegate.datalayer getTipForDate:julianDate];
	if ([records count] > 0) {
		NSDictionary *record = [records objectAtIndex:0];
		tip = (NSString *)[record valueForKey:@"fldTip"];
		[vHelpTipsInfo showInfo:@"Wellness Tip" tipText:tip];
	}
    [vHelpTipsInfo updateLayout:self.view.frame];
}


@end
