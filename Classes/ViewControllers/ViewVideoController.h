//
//  ViewVideoController.h
//  BrightcoveTest
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
#import <UIKit/UIKit.h>


@interface ViewVideoController : UIViewController <UIWebViewDelegate> {
    NSString *moviePath;
    NSString *movieDescription;
	UIWebView *wvVideo;
	UIActivityIndicatorView *activityIndicator;
	
	MPMoviePlayerController *moviePlayer;

}
@property (nonatomic, retain) NSString *moviePath;
@property (nonatomic, retain) NSString *movieDescription;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;

- (void)playVideo:(NSString *)videoFileName;
- (void)moviePlayerPlaybackDidFinishNotification:(NSNotification*) aNotification;
- (void)moviePlayerDidExitFullscreenNotification:(NSNotification*) aNotification;

- (void)updateLayout:(CGRect)frame;

- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
- (void)fadeOutView;
- (void)fadeOutBrowser;
- (void)fadeInView;
- (void)fadeInBrowser;
- (NSString *)embedYouTube:(NSString*)objectID url:(NSString*)url frame:(CGRect)frame;
- (void)replay:(id)sender;
@end

@interface ViewVideoController (PrivateMethods)
- (UIButton *)findButtonInView:(UIView *)view;
- (void)windowNowVisible:(NSNotification *)note;
- (void)windowNowHidden:(NSNotification *)note;
- (NSString *)showSubviews:(UIView *)view tabs:(NSString *)tabs;
- (UIView *)findYTMovieViewInView:(UIView *) view;
@end
