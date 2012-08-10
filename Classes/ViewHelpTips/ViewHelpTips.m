//
//  ViewHelpTips.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 9/24/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewHelpTips.h"

@implementation ViewHelpTips

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self initDisplay];
    }
    return self;
}

- (void)initDisplay {
	CGRect r = self.frame;
	UIButton *addB =[[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[addB setFrame:CGRectMake(0.0,0.0f, r.size.width, r.size.height)];
	[addB setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"helpTipButton.png"]]  forState:UIControlStateNormal];
	[addB setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"helpTipButton.png"]]  forState:UIControlStateSelected];
	[addB setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"helpTipButton.png"]]  forState:UIControlStateHighlighted];
	addB.tag = 1;
	[addB addTarget:self action:@selector(bHelp_TouchUp:) forControlEvents:UIControlEventTouchDown];
	[self addSubview:addB];
	bHelp = addB;
	[addB release];
}

- (void)dealloc {
    [super dealloc];
}

- (void)updateLayout:(CGRect)frame {
	[self setFrame:frame];
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
	[UIView beginAnimations:@"fadeOutView" context:nil];
	[UIView setAnimationDuration:0.25f];
	[UIView setAnimationDelegate:self];
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
	[UIView beginAnimations:@"animShowView" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	[UIView commitAnimations];
}
@end
