 //
//  ViewPracticeScenery.m
//  iBreathe100
//
//  Created by Roger Reeder on 7/28/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
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
#import "ViewPracticeScenery.h"
#import "B2RAppDelegate.h"

@implementation ViewPracticeScenery

@synthesize parentDelegate;

@synthesize bStatic;
@synthesize lInfoOverlay;
@synthesize lSubInfoOverlay;
@synthesize ivOverlay;
@synthesize ivBackground;
@synthesize ivZoomIn;
@synthesize ivZoomOut;
@synthesize ivImage03;

#define kScenesFramesPerSecond 30
#define kShowInfoLength 45


- (id)initWithFrame:(CGRect)frame visual:(Visual *)vis {
    if ((self = [super initWithFrame:frame])) {
		self.ivZoomIn = nil;
		self.ivZoomOut = nil;
		self.ivImage03 = nil;
		visual = vis;
		breathIn = YES;

        self.userInteractionEnabled = NO;
		self.clipsToBounds = YES;
		//background image
		UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:visual.backgroundFile]];
		[iv setFrame:frame ];
		iv.alpha = 0.5;
		[self addSubview:iv];
		ivBackground = iv;
		[iv release];

        //overlay image
		iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:visual.overlayFile]];
		[iv setFrame:frame ];
		iv.alpha = 0.5;
		[self addSubview:iv];
		ivOverlay = iv;
		[iv release];

		CGFloat x,y,w,h;
		w = frame.size.width*0.8f;
		h = w * 0.2;
		x = (frame.size.width-w)/2.0f;
		y = (frame.size.height-h)/2.0f;
		CGFloat fontSize = h * 0.8f;

        // Informational Label at center of display
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
		lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize * 1.0f];
		lbl.textAlignment = UITextAlignmentCenter;
		lbl.text = @"Information";
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textColor = [UIColor whiteColor];

		// Black Shadow at 50% transparency
		lbl.alpha = 0.0f;
		lbl.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
		lbl.shadowOffset = CGSizeMake(1.0f, 1.0f);
		[self addSubview:lbl];
		lInfoOverlay = lbl;
		[lbl release];
        
        w = frame.size.width*0.8f;
		if (frame.size.width > 480 || frame.size.height > 480) {
			h = 48.0f;
		} else {
			h = 24.0f;
		}
		x = (frame.size.width-w)/2.0f;
		y = frame.size.height-h;
		fontSize = h * 0.8f;
		
        // Informational label at Bottom of Display
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
		lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize * 1.0f];
		lbl.textAlignment = UITextAlignmentCenter;
		lbl.text = @"Sub-Information";
		lbl.backgroundColor = [UIColor clearColor];
		lbl.alpha = 0.0f;
		lbl.textColor = [UIColor whiteColor];
		// Black Shadow at 50% transparency
		lbl.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
		lbl.shadowOffset = CGSizeMake(1.0f, 1.0f);
		[self addSubview:lbl];
		lSubInfoOverlay = lbl;
		[lbl release];
        
		showLength = 0;
		bStatic = NO;
		RANDOM_SEED();
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)showInfoOverlay:(NSString *)text {
	lInfoOverlay.text = text;
	if (showLength == 0) {
		[self fadeInInfo];
	}
	showLength = 1;
}
- (void)showSubInfoOverlay:(NSString *)text {
	lSubInfoOverlay.text = text;
	if (showSubLength == 0) {
		[self fadeInSubInfo];
	}
	showSubLength = 1;
}

-(void)startSplashSlideShow:(int)inhaleLength exhaleLength:(int)exhaleLength fadeLength:(int)fadeL cycles:(int)cycles {
    zoomInOnTop = NO;
	breathIn = NO;
	bFirstImage = NO;
	maxFrameCountIn = inhaleLength;
    maxFrameCountOut = exhaleLength;
	frameCount = 0;
	imageAlphaDelta = (CGFloat)kScenesFramesPerSecond/(CGFloat)fadeL;
	keyFadeIn = fadeL/2;
	keyFadeOutIn = inhaleLength - fadeL/2;
	keyFadeOutOut = exhaleLength - fadeL/2;
	sceneNames = [[NSMutableArray alloc] init];
    maxCycles = cycles;
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    // Setup Scene list
	for (int i = 0; i <= appDelegate.playerSettings.cycles * 2;) {
		NSString *newPic = [NSString stringWithFormat:@"%@%d.%@",visual.bundleName, RANDOM_INT(1,visual.numberOfFrames), visual.postFix];
		if (i==0) {
			[sceneNames addObject:newPic];
			i++;
		} else if (![newPic isEqualToString:(NSString *)[sceneNames objectAtIndex:i-1]]) {
			[sceneNames addObject:newPic];
			i++;
		}
	}
	if (self.hidden) {
		self.hidden = NO;
	}
}

- (CGPoint)interpolatePoint:(CGPoint)point1 point2:(CGPoint)point2 modifier:(CGFloat)modifier {
    CGPoint newPoint = CGPointMake(point1.x + (point2.x - point1.x) * modifier, point1.y + (point2.y - point1.y) * modifier);
    return newPoint;
}

- (CGSize)interpolateSize:(CGSize)size1 size2:(CGSize)size2 modifier:(CGFloat)modifier {
    CGSize newSize = CGSizeMake(size1.width + (size2.width - size1.width) * modifier, size1.height + (size2.height - size1.height) * modifier);
    return newSize;
}

- (CGRect)interpolateRect:(CGRect)rect1 rect2:(CGRect)rect2 modifier:(CGFloat)modifier {
    CGPoint newPoint = [self interpolatePoint:rect1.origin point2:rect2.origin modifier:modifier];
    CGSize newSize = [self interpolateSize:rect1.size size2:rect2.size modifier:modifier];
    CGRect newRect = CGRectMake(newPoint.x, newPoint.y, newSize.width, newSize.height);
    return newRect;
}

- (void)stopSplashSlideShow {
}
//updateScreen:breathPosition displayLengthIn:appDelegate.playerSettings.breathSpanIn displayLengthOut:appDelegate.playerSettings.breathSpanOut cycle:cycle zoom:breathInhaling

-(void)updateScreen:(int)framePosition displayLengthIn:(int)displayLengthIn displayLengthOut:(int)displayLengthOut cycle:(int)cycle zoomIn:(BOOL)zoomIn{
    static int sceneIndexIn = -1;
    static int sceneIndexOut = -1;
    maxFrameCountIn = 9000;
    maxFrameCountOut = 9000;
    // Update Key fade in and out points if they've changed the length of the cycle.
    if(maxFrameCountIn != displayLengthIn) {
        if (maxFrameCountIn < displayLengthIn) {
            maxFrameCountIn = displayLengthIn;
        }
        keyFadeOutIn = displayLengthIn - keyFadeIn;
    }
    if(maxFrameCountOut != displayLengthOut) {
        if (maxFrameCountOut < displayLengthOut) {
             maxFrameCountOut = displayLengthOut;
        }
        keyFadeOutOut = displayLengthOut - keyFadeIn;
    }
    
    int sceneInIndex = 0;
    int sceneOutIndex = 0;
    int imgIndex = cycle * 2 - (zoomIn ? 2 : 1); //Reference Image Index
	if (zoomIn) { //Zooming In
        sceneInIndex = imgIndex;
		if (framePosition > keyFadeOutIn) {
            sceneOutIndex = imgIndex + 1;
		} else {
            sceneOutIndex = (imgIndex - 1 + maxCycles) % maxCycles;
		}
	} else { //Zooming Out
        sceneOutIndex = imgIndex;
		if (framePosition > keyFadeOutOut) {
            sceneInIndex = imgIndex +1;
        } else {
            sceneInIndex = (imgIndex - 1 + maxCycles) % maxCycles;
        }
	}
    
	UIImage *img;
	NSString *imageName = @"";
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    CGFloat imgAspect;
    if (sceneInIndex != sceneIndexIn || !self.ivZoomIn) { //Zoom In Image Changed
        sceneIndexIn = sceneInIndex;
 		imageName = (NSString *)[sceneNames objectAtIndex:sceneIndexIn];
        img = [UIImage imageNamed:imageName];
        if (self.ivZoomIn) {
            self.ivZoomIn.alpha = 0.0f;
            self.ivZoomIn.image = [UIImage imageNamed:imageName];
        } else {
            self.ivZoomIn = [[UIImageView alloc] initWithImage:img];
            self.ivZoomIn.alpha = 0.0f;
            [self insertSubview:self.ivZoomIn belowSubview:self.ivOverlay];
        }
        imgAspect = [appDelegate getImageAspect:self.ivZoomIn.image];
        imageInMinRect = [self minSizeRect:imgAspect];
        imageInMaxRect = [self maxSizeRect:imageInMinRect];
        
    }
    
    if (sceneOutIndex != sceneIndexOut || !self.ivZoomOut) { //Zoom out image changed
        sceneIndexOut = sceneOutIndex;
 		imageName = (NSString *)[sceneNames objectAtIndex:sceneIndexOut];
        img = [UIImage imageNamed:imageName];
        if (self.ivZoomOut) {
            self.ivZoomOut.alpha = 0.0f;
            self.ivZoomOut.image = [UIImage imageNamed:imageName];
         } else {
            self.ivZoomOut = [[UIImageView alloc] initWithImage:img];
            self.ivZoomOut.alpha = 0.0f;
           [self insertSubview:self.ivZoomOut belowSubview:self.ivOverlay];
        }
        imgAspect = [appDelegate getImageAspect:self.ivZoomOut.image];
        imageOutMinRect = [self minSizeRect:imgAspect];
        imageOutMaxRect = [self maxSizeRect:imageOutMinRect];
    }

    // Which is on top and does it need to be moved to top
    BOOL shouldBeOnTop = NO;
    if (framePosition < keyFadeIn) {
        if (zoomIn) {
            shouldBeOnTop = NO;
        } else {
            shouldBeOnTop = YES;
        }
    } else {
        if (zoomIn) {
            shouldBeOnTop = YES;
        } else {
            shouldBeOnTop = NO;
        }
    }
    if (shouldBeOnTop != zoomInOnTop) {
        zoomInOnTop = shouldBeOnTop;
        if (zoomInOnTop) {
            [self insertSubview:self.ivZoomIn aboveSubview:self.ivZoomOut];
        } else {
            [self insertSubview:self.ivZoomOut aboveSubview:self.ivZoomIn];
        }
    }
    
    //Set Alpha
    CGFloat fadeAmount = 0.0f;
	if (zoomIn) {
        if (framePosition < keyFadeIn) {
            fadeAmount = ((CGFloat)framePosition / (CGFloat)keyFadeIn) * 0.5f;
            self.ivZoomOut.alpha = 0.5f - fadeAmount;
            self.ivZoomIn.alpha =  0.5f + fadeAmount;
        } else if (framePosition > keyFadeOutIn) {
            fadeAmount = ((CGFloat)(framePosition - keyFadeOutIn) / (CGFloat)keyFadeIn) * 0.5f;
            self.ivZoomIn.alpha = 1.0f - fadeAmount;
            self.ivZoomOut.alpha = 0.0f + fadeAmount;
        } else {
            self.ivZoomIn.alpha = 1.0f;
            self.ivZoomOut.alpha = 0.0f;
        }
	} else {
        if (framePosition < keyFadeIn) {
            fadeAmount = ((CGFloat)framePosition / (CGFloat)keyFadeIn) * 0.5f;
            self.ivZoomIn.alpha = 0.5f - fadeAmount;
            self.ivZoomOut.alpha =  0.5f + fadeAmount;
        } else if (framePosition > keyFadeOutOut) {
            fadeAmount = ((CGFloat)(framePosition - keyFadeOutOut) / (CGFloat)keyFadeIn) * 0.5f;
            self.ivZoomOut.alpha = 1.0f - fadeAmount;
            self.ivZoomIn.alpha = 0.0f + fadeAmount;
        } else {
            self.ivZoomIn.alpha = 0.0f;
            self.ivZoomOut.alpha = 1.0f;
        }
        
    }
    
    //  Position in Expand and Contract
    int totalLengthIn = maxFrameCountIn + 2 * keyFadeIn;
    int totalLengthOut = maxFrameCountOut + 2 * keyFadeIn;
    CGFloat currentPositionIn = 0.0f;
    CGFloat currentPositionOut = 0.0f;
    if (zoomIn) {
        currentPositionIn = (CGFloat)(framePosition + keyFadeIn)/(CGFloat)totalLengthIn;
        if (framePosition < keyFadeIn) {
            currentPositionOut = (CGFloat)(totalLengthOut - (keyFadeIn - framePosition))/(CGFloat)totalLengthOut;
        }
        if (framePosition > keyFadeOutIn) {
            currentPositionOut = (CGFloat)(framePosition - keyFadeOutIn)/(CGFloat)totalLengthOut;
        }
    } else {
        currentPositionOut = (CGFloat)(framePosition + keyFadeIn)/(CGFloat)totalLengthOut;
        if (framePosition < keyFadeIn) {
            currentPositionIn = (CGFloat)(totalLengthIn - (keyFadeIn - framePosition))/(CGFloat)totalLengthIn;
        }
        if (framePosition > keyFadeOutOut) {
            currentPositionIn = (CGFloat)(framePosition - keyFadeOutOut)/(CGFloat)totalLengthIn;
        }
    }
    self.ivZoomIn.frame = [self interpolateRect:imageInMinRect rect2:imageInMaxRect modifier:currentPositionIn];
    self.ivZoomOut.frame = [self interpolateRect:imageOutMaxRect rect2:imageOutMinRect modifier:currentPositionOut];

	frameCount++;
	if (showLength > 0) {
		showLength++;
		if (showLength > kShowInfoLength) {
			showLength = 0;
			[self fadeOutInfo];
		}
	}
	if (showSubLength > 0) {
		showSubLength++;
		if (showSubLength > kShowInfoLength) {
			showSubLength = 0;
			[self fadeOutSubInfo];
		}
	}
}

- (CGRect)minSizeRect:(CGFloat)imgAspect {
    CGRect viewPort = self.bounds;
    CGRect imageMin = CGRectMake(0.0f, 0.0f, viewPort.size.width * 1.15f, (viewPort.size.width * 1.15f) * imgAspect);
    int offsetX = 0;
    int offsetY = 0;
    if (imageMin.size.height < viewPort.size.height * 1.15f) {
        imageMin.size.height = viewPort.size.height * 1.15f;
        imageMin.size.width = imageMin.size.height / imgAspect;
    }
	
    offsetX = (int)((imageMin.size.width - viewPort.size.width)*0.5f);
    offsetY = (int)((imageMin.size.height - viewPort.size.height)*0.5f);
    imageMin.origin.x = offsetX - RANDOM_INT(offsetX,offsetX*2);
    imageMin.origin.y = offsetY - RANDOM_INT(offsetY,offsetY*2);
    return imageMin;
}

- (CGRect)maxSizeRect:(CGRect) imageMin {
    CGRect viewPort = self.bounds;
    int offsetX = 0;
    int offsetY = 0;
    CGRect imageMax = CGRectMake(0.0f, 0.0f, imageMin.size.width * 1.35f, imageMin.size.height * 1.35f);
    offsetX = (int)((imageMax.size.width - viewPort.size.width) * 0.5f);
    offsetY = (int)((imageMax.size.height - viewPort.size.height) * 0.5f);
    imageMax.origin.x = offsetX - RANDOM_INT(offsetX, offsetX * 2);
    imageMax.origin.y = offsetY - RANDOM_INT(offsetY, offsetY * 2);                                                 
    return imageMax;                
}

- (void)updateLayout:(CGRect)frame {
	[self setFrame:frame];
	[ivOverlay setFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
	CGFloat x,y,w,h;
	w = frame.size.width*0.8f;
	h = w * 0.2;
	x = (frame.size.width-w)/2.0f;
	y = (frame.size.height-h)/2.0f;
	lInfoOverlay.frame = CGRectMake(x, y, w, h);
	w = frame.size.width*0.8f;
	if (frame.size.width > 480 || frame.size.height > 480) {
		h = 48.0f;
	} else {
		h = 24.0f;
	}
	y = frame.size.height-h;
	lSubInfoOverlay.frame = CGRectMake(x, y, w, h);

}

#pragma mark -
#pragma mark Controller Animation Cycle
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    
}	

- (void)fadeOutView {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutViewPracticeScenery" context:nil];
	[UIView setAnimationDuration:1.0f];
    if (self.parentDelegate) {
        [UIView setAnimationDelegate:self.parentDelegate];
    } else {
        [UIView setAnimationDelegate:self];
    }
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)fadeInView:(id)delegate {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInViewPracticeScenery" context:nil];
	[UIView setAnimationDuration:0.5f];
    if (delegate) {
        [UIView setAnimationDelegate:delegate];
    } else {
        [UIView setAnimationDelegate:self];
    }
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.alpha = 1.0f;
	[UIView commitAnimations];
}

- (void)fadeInInfo {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInInfo" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	lInfoOverlay.alpha = 1.0f;
	[UIView commitAnimations];
}
- (void)fadeOutInfo {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInInfo" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	lInfoOverlay.alpha = 0.0f;
	[UIView commitAnimations];
}
- (void)fadeInSubInfo {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInSubInfo" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	lSubInfoOverlay.alpha = 1.0f;
	[UIView commitAnimations];
}
- (void)fadeOutSubInfo {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutSubInfo" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	lSubInfoOverlay.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)animShowView {		//Animate Fade Out
}

@end
