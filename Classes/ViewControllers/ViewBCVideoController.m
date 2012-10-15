//
//  ViewBCVideoController.m
//  t
//
//  Created by Roger Reeder on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
#import "ViewBCVideoController.h"
#import "B2RAppDelegate.h"
#import "Reachability.h"
#import "BCMoviePlayerController.h"

#import "Analytics.h"

@implementation ViewBCVideoController
@synthesize bcPlayer;
@synthesize video;
@synthesize activityIndicator;
@synthesize lblLoading;
@synthesize videoID;
@synthesize videoDescription;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self 
                  name:MPMoviePlayerPlaybackStateDidChangeNotification 
                object:bcPlayer];
    [nc removeObserver:self 
                  name:MPMoviePlayerLoadStateDidChangeNotification 
                object:bcPlayer]; 
    [nc removeObserver:self 
                  name:MPMoviePlayerWillEnterFullscreenNotification
                object:bcPlayer]; 
    [nc removeObserver:self 
                  name:MPMoviePlayerDidExitFullscreenNotification
                object:bcPlayer]; 
    [nc removeObserver:self 
                  name:MPMoviePlayerPlaybackDidFinishNotification
                object:bcPlayer]; 
    
    [self.activityIndicator release];
    [self.bcPlayer release];
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
 
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    self.bcPlayer = [[BCMoviePlayerController alloc] init];
    [self.bcPlayer setUseApplicationAudioSession:NO];
    self.bcPlayer.view.hidden = YES;
    self.bcPlayer.controlStyle = MPMovieControlStyleDefault;
    [self.bcPlayer.view setFrame:self.view.bounds];
    [self.view addSubview:self.bcPlayer.view];
    self.bcPlayer.fullscreen = NO;
    self.bcPlayer.controlStyle = MPMovieControlStyleDefault;
    
    if (appDelegate.networkStatus == ReachableViaWiFi) {
        [bcPlayer searchForRenditionsBetweenLowBitRate:[NSNumber numberWithInt:800000] 
                                        andHighBitRate:[NSNumber numberWithInt:2000000]];
        NSLog(@"Trying to pull via WiFi");
    } else {
        NSLog(@"Trying to pull via 3G");
        [bcPlayer searchForRenditionsBetweenLowBitRate:[NSNumber numberWithInt:200000] 
                                        andHighBitRate:[NSNumber numberWithInt:500000]];
    }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self 
           selector:@selector(playbackStateDidChange:) 
               name:MPMoviePlayerPlaybackStateDidChangeNotification 
             object:bcPlayer];
    [nc addObserver:self 
           selector:@selector(loadStateDidChange:) 
               name:MPMoviePlayerLoadStateDidChangeNotification
             object:bcPlayer];
    [nc addObserver:self 
           selector:@selector(willEnterFullscreen:) 
               name:MPMoviePlayerWillEnterFullscreenNotification
             object:bcPlayer];
    [nc addObserver:self 
           selector:@selector(didExitFullscreen:) 
               name:MPMoviePlayerDidExitFullscreenNotification
             object:bcPlayer];
    [nc addObserver:self 
           selector:@selector(playbackDidFinish:) 
               name:MPMoviePlayerPlaybackDidFinishNotification
             object:bcPlayer];

}


- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:[NSString stringWithFormat:@"MOVIE %@ VIEW", self.videoDescription]];
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    NSError *err;
    if (self.videoID) {

        BCVideo *vid = (BCVideo *)[appDelegate.bcServices findVideoById:self.videoID error:&err];
        if (vid) {
            [self.bcPlayer setContentURL:vid];
            [self.bcPlayer prepareToPlay];
            [self.bcPlayer play];
            if (![self.activityIndicator isAnimating]) {
                [self.activityIndicator startAnimating];
            }
        } else {
            NSString *errStr = [appDelegate.bcServices getErrorsAsString:err];
            NSLog(@"%@",errStr);
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (self.bcPlayer) {
        [self.bcPlayer stop];
        [self.bcPlayer release];
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self fadeOutPlayer];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.bcPlayer.view.frame = self.view.frame;
    [self fadeInPlayer];
}

#pragma mark -
#pragma mark Controller Animation Cycle
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if ((animationID == @"fadeOutPlayer")/* && finished*/) {  
	
    }
	if ((animationID == @"fadeInPlayer")/* && finished*/) {

	}
}	

- (void)fadeOutPlayer {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutPlayer" context:nil];
	[UIView setAnimationDuration:0.25f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)fadeInPlayer {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInPlayer" context:nil];
	[UIView setAnimationDuration:0.25f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 1.0f;
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark Video Utilities
-(void)replay:(id)sender {
    if (self.bcPlayer) {
        [self.bcPlayer play];
    }
}


- (void)updateLayout:(CGRect)frame {
	[self.view setFrame:frame];
	if (self.lblLoading) {
		[self.lblLoading setCenter:CGPointMake(frame.size.width/2.0f, self.lblLoading.center.y)];
	}
	if (self.activityIndicator) {
		[self.activityIndicator setCenter:CGPointMake(frame.size.width/2.0f, frame.size.height/2.0f)];
	}
}

- (void)animateRotation:(UIInterfaceOrientation)interfaceOrientation 
               duration:(NSTimeInterval)duration {
/*    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || 
        interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        CGRect portraitRect = CGRectMake(0.0f, 0.0f, 768.0f, 432.0f);
        [[self view] setFrame:portraitRect];
        [[bcPlayer view] setFrame:portraitRect];
        if (![bcPlayer isFullscreen]) {
            [[bcPlayer backgroundView] setFrame:portraitRect];
        //    [[bcPlayer backgroundView] setBackgroundColor:portraitBackground];
        }
        
        [activityIndicator setCenter:CGPointMake(384.0f,160.0f)];
    } else {
        CGRect landscapeRect = CGRectMake(0.0f, 0.0f, 1024.0f, 348.0f);        
        [[self view] setFrame:landscapeRect];        
        [[bcPlayer view] setFrame:CGRectMake(205.0f, 0.0f, 619.0f, 348.0f)];
        if (![bcPlayer isFullscreen]) {
            [[bcPlayer backgroundView] setFrame:CGRectMake(-205.0f, 0.0f, 1024.0f, 348.0f)];
        //    [[bcPlayer backgroundView] setBackgroundColor:landscapeBackground];
        }
        [activityIndicator setCenter:CGPointMake(512.0f,110.0f)];
    }
 */
}

#pragma mark - MoviePlayer Notifications

- (void)playbackStateDidChange:(NSNotification *)notification {
    MPMoviePlaybackState playbackState = [self.bcPlayer playbackState];
//    MPMoviePlaybackStateStopped,
//    MPMoviePlaybackStatePlaying,
//    MPMoviePlaybackStatePaused,
//    MPMoviePlaybackStateInterrupted,
//    MPMoviePlaybackStateSeekingForward,
//    MPMoviePlaybackStateSeekingBackward
    NSString *lblText = @"";
    NSString *logText = @"";
    switch (playbackState) {
        case MPMoviePlaybackStateStopped:
            lblText = @"Buffering ...";
            logText = @"Stopped";
            break;
        case MPMoviePlaybackStatePlaying:
            lblText = @"Buffering ...";
            logText = @"Playing";
            break;
        case MPMoviePlaybackStatePaused:
            lblText = @"Paused";
            logText = @"Paused";break;
        case MPMoviePlaybackStateInterrupted:
            lblText = @"Interrupted";
            logText = @"Interrupted";break;
        case MPMoviePlaybackStateSeekingForward:
            lblText = @"Seeking Forward";
            logText = @"Seeking Forward";break;
        case MPMoviePlaybackStateSeekingBackward:
            lblText = @"Seeking Backward";
            logText = @"Seeking Backward";break;
        default:
            break;
    }
    self.lblLoading.text = [NSString stringWithFormat:@"%@",lblText];
    NSLog(@"%@",logText);
    if ([self.bcPlayer playbackState] == MPMoviePlaybackStateStopped) {
        if ([self.bcPlayer isFullscreen]) {
            [self.bcPlayer setFullscreen:NO animated:YES];
        }
    }
}

- (void)loadStateDidChange:(NSNotification *)notification {
    NSLog(@"loadStateDidChange %d", [self.bcPlayer loadState]);
//    MPMovieLoadStateUnknown        = 0,
//    MPMovieLoadStatePlayable       = 1 << 0,
//    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
//    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    if ([self.bcPlayer loadState] == (MPMovieLoadStatePlaythroughOK | MPMovieLoadStatePlayable) || [self.bcPlayer loadState] == MPMovieLoadStatePlayable) {
        if ([self.activityIndicator isAnimating]) {
            [self.activityIndicator stopAnimating];
        }
        self.bcPlayer.view.hidden = NO;
        [self.bcPlayer setFullscreen:YES animated:YES];
        NSLog(@"Now Showing");
    }
}

- (void)willEnterFullscreen:(NSNotification *)notification {
    NSLog(@"willEnterFullscreen");
    [[self.bcPlayer backgroundView] setBackgroundColor:[UIColor blackColor]];
}

- (void)playbackDidFinish:(NSNotification *)notification {
    NSLog(@"playbackDidFinish");
    if (self.bcPlayer.view.hidden != YES) {
		self.bcPlayer.view.hidden = YES;
		[self.bcPlayer.view removeFromSuperview];
	}
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didExitFullscreen:(NSNotification *)notification {
    NSLog(@"didExitFullscreen");
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    if (interfaceOrientation == UIInterfaceOrientationPortrait || 
        interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
    } else {
    }
	self.bcPlayer.view.hidden = YES;
	[self.bcPlayer.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
