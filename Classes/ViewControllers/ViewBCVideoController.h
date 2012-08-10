//
//  ViewVideoController.h
//  BrightcoveTest
//
//  Created by Roger Reeder on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCMoviePlayerController.h"

#import "BCVideo.h"

@interface ViewBCVideoController : UIViewController {
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UILabel *lblLoading;
    BCMoviePlayerController *bcPlayer;
    BCVideo *video;
    long long videoID;
    NSString *videoDescription;
}
@property (nonatomic, retain) BCMoviePlayerController *bcPlayer;
@property (nonatomic, retain) BCVideo *video;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) long long videoID;
@property (nonatomic, retain) NSString *videoDescription;
@property (nonatomic, retain) 	IBOutlet UILabel *lblLoading;

- (void)updateLayout:(CGRect)frame;

- (void)replay:(id)sender;
- (void)animateRotation: (UIInterfaceOrientation) interfaceOrientation 
               duration: (NSTimeInterval )duration;

- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
- (void)fadeOutPlayer;
- (void)fadeInPlayer;

@end

