//
//  ViewLearnController.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/3/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewLearnController.h"
#import "B2RAppDelegate.h"
#import "ViewVideoController.h"
#import "ViewBCVideoController.h"
#import "ViewBodyScannerController.h"
#import "ViewReaderController.h"

#import "Analytics.h"

@implementation ViewLearnController

@synthesize vContainer;
@synthesize bLearn1;
@synthesize lblLearn1;
@synthesize bLearn2;
@synthesize lblLearn2;
@synthesize bLearn3;
@synthesize lblLearn3;
@synthesize sWatchLearn;
@synthesize lblNetworkStatus;

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
}
- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"LEARN VIEW"];
    [self refreshControls];
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.firstTime showGuideForPosition:enAppPositionLearn]) {
		helpTips = [appDelegate showInfo:[appDelegate.firstTime getGuideTitleForPosition:enAppPositionLearn] 
                     withInfo:[appDelegate.firstTime getGuideDetailForPosition:enAppPositionLearn] 
                containerView:self.view appPosition:enAppPositionLearn];
    } else if (helpTips) {
        [helpTips updateLayout:self.view.frame];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self fadeOutLearn];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (helpTips) {
        [helpTips updateLayout:self.view.frame];
    }
    [self fadeInLearn];
}

- (IBAction)button1_click:(id)sender {
    NSInteger val = [self.sWatchLearn selectedSegmentIndex];
    if (val == 0) {
        ViewReaderController *vcReader = [ViewReaderController alloc];
        vcReader.view.alpha = 0.0;
        vcReader.title = @"Biology of Stress";
        CGRect r = self.view.frame;
        [vcReader updateLayout:r];
        vcReader.pixelsPerFrame = 1.0f;
        vcReader.animationInterval = 1.0f / 15.0f;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            vcReader.pixelsPerFrame = 1.0f;
            vcReader.animationInterval = 1.0f / 15.0f;
        }
        
        [self.navigationController pushViewController:vcReader animated:YES];
        [vcReader loadHTML:@"learn"];
        [vcReader fadeInReader];
        [vcReader release];
            //Read Biology of Stess
    } else {
        B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.useYouTube) {
            [self showVideo:@"How to Breathe" video:@"demo"];
        } else {
            [self showBCVideo:@"How to Breathe" videoName:@"demo"];
        }
    }
}
- (IBAction)button2_click:(id)sender {
    NSInteger val = [self.sWatchLearn selectedSegmentIndex];
    if (val == 0) {
        ViewReaderController *vcReader = [ViewReaderController alloc] ;
        vcReader.view.alpha = 0.0;
        vcReader.title = @"Diaphragmatic Breathing";
        CGRect r = self.view.frame;
        [vcReader updateLayout:r];
        vcReader.pixelsPerFrame = 1.0f;
        vcReader.animationInterval = 1.0f / 15.0f;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            vcReader.pixelsPerFrame = 1.0f;
            vcReader.animationInterval = 1.0f / 15.0f;
        }
        
        [self.navigationController pushViewController:vcReader animated:YES];
        [vcReader loadHTML:@"watch"];
        [vcReader fadeInReader];
        [vcReader release];
    } else {
        B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.useYouTube) {
            [self showVideo:@"Biology Of Stress" video:@"biologyOfBreathing"];
        } else {
            [self showBCVideo:@"Biology Of Stress" videoName:@"biologyOfBreathing"];
        }
    }
}

- (IBAction)button3_click:(id)sender {
    NSInteger val = [self.sWatchLearn selectedSegmentIndex];
    if (val == 0) {
        ViewBodyScannerController *anotherController = [ViewBodyScannerController alloc];
        anotherController.view.alpha = 0.0;
        CGRect r = self.view.frame;
        //r.size.height = r.size.height - self.navigationController.navigationBar.frame.size.height;
        [anotherController initDisplay];
        [anotherController updateLayout:r];
        anotherController.title = @"Body Scanner";
        [self.navigationController pushViewController:anotherController animated:YES];
        [anotherController fadeInView];
        [anotherController startScanner];
        [anotherController startScrolling];
        [anotherController release];
    } else {
        B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.useYouTube) {
            [self showVideo:@"Body's Reaction to Stress" video:@"bodyReactionToStress"];
        } else {
            [self showBCVideo:@"Body's Reaction to Stress" videoName:@"bodyReactionToStress"];
        }
    }
}

- (IBAction)toggle_change:(id)sender {
    [self fadeRenewLearn];
}

- (void)showBCVideo:(NSString *)title videoName:(NSString *)videoName {
    NSString *controllerBundle = @"ViewBCVideoController";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        controllerBundle = @"ViewBCVideoController";
    }
    
    ViewBCVideoController *anotherController = [[ViewBCVideoController alloc] initWithNibName:controllerBundle bundle:nil];
    anotherController.title = @"Watch Demonstration";
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    long long videoID = [[appDelegate getAppSetting:@"Brightcove" withKey:videoName] longLongValue];
    anotherController.videoDescription = videoName;
    anotherController.videoID = videoID;
    [self.navigationController pushViewController:anotherController animated:YES];
    [anotherController release];
    
}

- (void)showVideo:(NSString *)title video:(NSString *)video {
    
    NSString *controllerBundle = @"ViewVideoController";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        controllerBundle = @"ViewVideoController";
    }
    ViewVideoController *anotherController = [[ViewVideoController alloc] initWithNibName:controllerBundle bundle:nil];
    anotherController.title = title;
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *videoURL = [appDelegate getAppSetting:@"URLs" withKey:video];
    anotherController.moviePath = videoURL;
    anotherController.movieDescription = video;
    [self.navigationController pushViewController:anotherController animated:YES];
    [anotherController release];
    
}

- (void)refreshControls{
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL hasInternet = NO;
    NSInteger val = [self.sWatchLearn selectedSegmentIndex];
    switch (val) {
        case 0:
            [self.bLearn1 setTitle:@"Read" forState:UIControlStateNormal];
            [self.bLearn2 setTitle:@"Read" forState:UIControlStateNormal];
            [self.bLearn3 setTitle:@"View" forState:UIControlStateNormal];
            self.lblLearn1.text = @"Biology of Stress";
            self.lblLearn2.text = @"Diaphragmatic Breathing";
            self.lblLearn3.text = @"Effects of Stress on the Body";
            self.bLearn1.enabled = YES;
            self.bLearn2.enabled = YES;
            self.bLearn3.enabled = YES;
            self.lblNetworkStatus.hidden = YES;
            break;
        case 1:
            switch (appDelegate.networkStatus) {
                case NotReachable:
                    hasInternet = NO;
                    self.lblNetworkStatus.text = @"No Internet Connection";
                    break;
                default:
                    if (appDelegate.connectionRequired) {
                        self.lblNetworkStatus.text = @"Network Available Waiting For Connection";
                    } else {
                        hasInternet = YES;
                    }
                    break;
            }
            
            self.bLearn1.enabled = hasInternet;
            self.bLearn2.enabled = hasInternet;
            self.bLearn3.enabled = hasInternet;
            [self.bLearn1 setTitle:@"Watch" forState:UIControlStateNormal];
            [self.bLearn2 setTitle:@"Watch" forState:UIControlStateNormal];
            [self.bLearn3 setTitle:@"Watch" forState:UIControlStateNormal];
            self.lblLearn1.text = @"How to breathe";
            self.lblLearn2.text = @"Biology of breathing";
            self.lblLearn3.text = @"Body's reaction to stress";
            self.lblNetworkStatus.hidden = hasInternet;
            if (!hasInternet) {
                [self performSelector:@selector(refreshControls) withObject:nil afterDelay:5.0];
            }
            //[self performSelector:@selector(doPush:) withObject:ar afterDelay:0.05];
        default:
            break;
    }
    if (self.vContainer.alpha < 0.1f) {
        [self fadeInLearn];
    }
}

#pragma mark -
#pragma mark Controller Animation Cycle
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if ((animationID == @"fadeInLearn")/* && finished*/) {  
		
	}
	if ((animationID == @"fadeRenewLearn")/* && finished*/) {  
		[self refreshControls];
	}
}	

- (void)fadeOutLearn {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutLearn" context:nil];
	[UIView setAnimationDuration:0.25f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.vContainer.alpha = 0.0f;
	[UIView commitAnimations];
}
- (void)fadeRenewLearn {		//Animate Fade Out
	[UIView beginAnimations:@"fadeRenewLearn" context:nil];
	[UIView setAnimationDuration:0.25f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.vContainer.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)fadeInLearn {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInLearn" context:nil];
	[UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.vContainer.alpha = 1.0f;
	[UIView commitAnimations];
}

@end
