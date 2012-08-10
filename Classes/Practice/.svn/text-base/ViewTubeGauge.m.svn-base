//
//  ViewTubeGauge.m
//  iBreathe110
//
//  Created by Roger Reeder on 7/30/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewTubeGauge.h"
#import "RootViewController.h"

@implementation ViewTubeGauge
@synthesize tubeAlpha, liquidAlpha, liquidLevel, parentController;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		tubeAlpha = 1.0f;
		liquidAlpha = 1.0f;
		liquidLevel = 1.0f;
		scaleValue = frame.size.width / 80.0f;
		CGFloat x,y,w,h;
		
		x = 0.0f;
		y = frame.size.height - 21.0f * scaleValue;
		w = frame.size.width;
		h = 21.0f * scaleValue;
		
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
		[iv setImage:[UIImage imageNamed:@"t4.png"]];
		iv.alpha = tubeAlpha;
		tubeBack = iv;
		[self addSubview:tubeBack];
		[iv release];
		
		
		y = frame.size.height * 0.5f - (25.0f * scaleValue) * 0.5f;
		h = 25.0f * scaleValue;
		iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
		[iv setImage:[UIImage imageNamed:@"l1.png"]];
		iv.alpha = liquidAlpha;
		liquidTop = iv;
		[self addSubview:liquidTop];
		[iv release];
		
		iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height * 0.5f + (25.0f * scaleValue) * 0.5f, frame.size.width, frame.size.height - frame.size.height * 0.5f - 25.0f * scaleValue * 0.5f - 10.0f * scaleValue)];
		[iv setImage:[UIImage imageNamed:@"l2.png"]];
		iv.alpha = liquidAlpha;
		liquidMid = iv;
		[self addSubview:liquidMid];
		[iv release];
		
		iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 10.0f * scaleValue, frame.size.width, 10.0f * scaleValue)];
		[iv setImage:[UIImage imageNamed:@"l3.png"]];
		iv.alpha = liquidAlpha;
		liquidBottom = iv;
		[self addSubview:liquidBottom];
		[iv release];
		
		iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height * 0.5f - (25.0f * scaleValue) * 0.5f, frame.size.width, 25.0f * scaleValue)];
		[iv setImage:[UIImage imageNamed:@"t5.png"]];
		iv.alpha = tubeAlpha;
		tubeLiquidHighlight = iv;
		[self addSubview:tubeLiquidHighlight];
		[iv release];
		
		
		
		iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 26.0f * scaleValue)];
		[iv setImage:[UIImage imageNamed:@"t1.png"]];
		iv.alpha = tubeAlpha;
		tubeTop = iv;
		[self addSubview:tubeTop];
		[iv release];
		
		iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26.0f * scaleValue, frame.size.width, frame.size.height - (26.0f * scaleValue) - (10.0f * scaleValue))];
		[iv setImage:[UIImage imageNamed:@"t2.png"]];
		iv.alpha = tubeAlpha;
		tubeMid = iv;
		[self addSubview:tubeMid];
		[iv release];
		
		iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 10.0f * scaleValue, frame.size.width, 10.0f * scaleValue)];
		[iv setImage:[UIImage imageNamed:@"t3.png"]];
		iv.alpha = tubeAlpha;
		tubeBottom = iv;
		[self addSubview:tubeBottom];
		[iv release];
		//[self updateLayout:frame];
		
    }
    return self;
}

- (void)dealloc {
	//release components?
    [super dealloc];
}

- (void) updateLayout:(CGRect)frame {
	scaleValue = frame.size.width / 80.0f;
	[self setFrame:frame];
	CGFloat x,y,w,h;
	x = 0.0f;
	y = frame.size.height - 21.0f * scaleValue;
	w = frame.size.width;
	h = 21.0f * scaleValue;
	[tubeBack setFrame:CGRectMake(x, y, w, h)];
	
	y = frame.size.height * 0.5f - (25.0f * scaleValue) * 0.5f;
	h = 25.0f * scaleValue;
	[liquidTop setFrame:CGRectMake(x, y, w, h)];
	
	y = frame.size.height - 10.0f * scaleValue;
	h =10.0f * scaleValue;
	[liquidBottom setFrame:CGRectMake(x, y, w, h)];
	
	y = frame.size.height * 0.5f - (25.0f * scaleValue) * 0.5f;
	h = 25.0f * scaleValue;
	[tubeLiquidHighlight setFrame:CGRectMake(x, y, w, h)];
	
	y = 0.0f;
	h = 26.0f * scaleValue;
	[tubeTop setFrame:CGRectMake(x, y, w, h)];
	
	y = 26.0f * scaleValue;
	h = frame.size.height - (26.0f * scaleValue) - (10.0f * scaleValue);
	[tubeMid setFrame:CGRectMake(x, y, w, h)];
	
	y = frame.size.height - 10.0f * scaleValue;
	h = 10.0f * scaleValue;
	[tubeBottom setFrame:CGRectMake(x, y, w, h)];
	CGFloat prevLevel = liquidLevel;
	liquidLevel = 0.0f;
	[self setLiquidLevel:prevLevel];

}
-(void) setLiquidLevel:(CGFloat)levelValue {
	if (liquidLevel != levelValue) {
		// Redraw Levels...
		liquidLevel = levelValue;
		[self updateLiquidLevel];
	}
}

-(void) setTubeAlpha:(CGFloat)alphaValue {
	if (tubeAlpha != alphaValue) {
		// setTubeAlphas
		tubeAlpha = alphaValue;
		[self updateTubeAlpha:tubeAlpha];
	}
}

-(void) setLiquidAlpha:(CGFloat)alphaValue {
	if (liquidAlpha != alphaValue) {
		// setLiquidAlphas
		liquidAlpha = alphaValue;
		[self updateLiquidAlpha:liquidAlpha];
	}
}

-(void) updateLiquidLevel {
	CGPoint p = [tubeLiquidHighlight center];
	CGRect r = [self frame];
	CGFloat lvl = 1.0f  - liquidLevel;
	if (lvl < 0.0f) {
		lvl = 0.0f;
	}
	if (lvl > 1.0f) {
		lvl = 1.0f;
	}
	CGPoint newPoint = CGPointMake(p.x, 25.0 * scaleValue * 0.5f + (r.size.height - (30.0f * scaleValue)) * lvl);
	[tubeLiquidHighlight setCenter:newPoint];
	[liquidTop setCenter:newPoint];
	[liquidMid setFrame:CGRectMake(0, newPoint.y + (25.0f * scaleValue) * 0.5f , r.size.width, r.size.height - (newPoint.y + (25.0f * scaleValue) * 0.5f) - 10.0f * scaleValue)];
}

-(void) updateLiquidAlpha:(CGFloat)newAlpha {
	liquidTop.alpha = newAlpha;
	liquidMid.alpha = newAlpha;
	liquidBottom.alpha = newAlpha;
}

-(void) updateTubeAlpha:(CGFloat)newAlpha {
	tubeLiquidHighlight.alpha = newAlpha;
	tubeTop.alpha = newAlpha;
	tubeMid.alpha = newAlpha;
	tubeBottom.alpha = newAlpha;
	tubeBack.alpha = newAlpha;
}

#pragma mark -
#pragma mark Controller Animation Cycle
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if ((animationID == @"fadeOutViewTubeGauge")/* && finished*/) {  
		//[self animShowLogo];
	}
	if ((animationID == @"fadeInViewTubeGauge")/* && finished*/) {  
		//[self animShowT2Logo];
	}
}	

- (void)fadeOutView {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutViewTubeGauge" context:nil];
	[UIView setAnimationDuration:0.25f];
	if (parentController != nil) {
		[UIView setAnimationDelegate:parentController];
	} else {
		[UIView setAnimationDelegate:self];
	}
	
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)fadeInView:(id)delegate {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInViewTubeGauge" context:nil];
	[UIView setAnimationDuration:0.25f];
	if (delegate) {
		[UIView setAnimationDelegate:delegate];
	} else {
		[UIView setAnimationDelegate:self];
	}
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.alpha = 1.0f;
	[UIView commitAnimations];
}

- (void)animShowView {		//Animate Fade Out
}

@end
