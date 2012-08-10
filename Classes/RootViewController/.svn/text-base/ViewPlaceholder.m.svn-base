//
//  ViewPlaceholder.m
//  iBreathe130
//
//  Created by Roger Reeder on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ViewPlaceholder.h"
#import "RootViewController.h"

// Body logo 311 x 228
#define BODYLOGOASPECT (228.0f/412.0f)


@implementation ViewPlaceholder
@synthesize parentController;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		CGRect r = self.frame;
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, r.size.width, r.size.width * BODYLOGOASPECT)];
		[iv setImage:[UIImage imageNamed:@"placeholder.png"]];
		iv.alpha = 1.0f;
		[self addSubview:iv];
		ivbackground = iv;
		[iv release];
		[self updateLayout:frame];
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}

- (void)updateLayout:(CGRect)frame {
	[self setFrame:frame];
	
	CGFloat x,y,w,h;
	//body first
	if (frame.size.width > frame.size.height) { //landscape
		h = frame.size.height * 0.90f;
		w = h / BODYLOGOASPECT;
	}else {
		w = frame.size.width * 0.90f;
		h = w * BODYLOGOASPECT;
	}
	x = (frame.size.width - w)/2.0f;
	if (frame.size.width > frame.size.height) { //landscape
		y = (frame.size.height - h);
	}else {
		y = (frame.size.height - h)/2.0f;
	}
	[ivbackground setFrame:CGRectMake(x, y, w, h)];
	
}

#pragma mark -
#pragma mark Controller Animation Cycle
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if ((animationID == @"fadeOutView")/* && finished*/) {  
	}
	if ((animationID == @"fadeInView")/* && finished*/) {  
	}
}	

- (void)fadeOutView {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutPlaceholder" context:nil];
	if (parentController) {
		[UIView setAnimationDelegate:parentController];
	}else {
		[UIView setAnimationDelegate:self];
	}
	[UIView setAnimationDuration:0.25f];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)fadeInView {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInView" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.alpha = 1.0f;
	[UIView commitAnimations];
}

- (void)animShowView {		//Animate Fade Out
	ivbackground.alpha = 0.0f;
	self.alpha = 1.0f;
	[UIView beginAnimations:@"animShowView" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	ivbackground.alpha = 1.0f;
	[UIView commitAnimations];
}

@end
