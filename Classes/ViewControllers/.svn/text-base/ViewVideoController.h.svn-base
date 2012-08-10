//
//  ViewVideoController.h
//  BrightcoveTest
//
//  Created by Roger Reeder on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
