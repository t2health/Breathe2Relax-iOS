//
//  ViewPracticeScenery.h
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
#import <UIKit/UIKit.h>
#import "Visual.h"

@interface ViewPracticeScenery : UIView {
	NSInteger maxFrameCountIn;
    NSInteger maxFrameCountOut;
	NSInteger frameCount;
	BOOL bFirstImage;
	
	// transitional slide show images
	UIView *vMain;
	UIImageView *ivBackground;
	UIImageView *ivZoomOut;
	UIImageView *ivZoomIn;
	UIImageView *ivImage03;
	UIImageView *ivOverlay;
	UILabel *lInfoOverlay;
	UILabel *lSubInfoOverlay;
	
	CGRect imageInMinRect;
	CGRect imageInMaxRect;
	CGRect imageOutMinRect;
	CGRect imageOutMaxRect;
	CGRect image3MinRect;
	CGRect image3MaxRect;

	CGFloat imageAlphaDelta;
	NSString *visualToShow;
	
	BOOL breathIn;
	BOOL bStatic;
	int showLength;
	int showSubLength;
	Visual *visual;
	NSMutableArray *sceneNames;
	int keyFadeIn;
	int keyFadeOutIn;
    int keyFadeOutOut;
    int maxCycles;
    BOOL zoomInOnTop;
	
    id parentDelegate;
}
@property (nonatomic, retain) id parentDelegate;

@property(nonatomic,retain) UILabel *lInfoOverlay;
@property(nonatomic,retain) UILabel *lSubInfoOverlay;
@property(nonatomic) BOOL bStatic;
@property(nonatomic,retain) UIImageView *ivBackground;
@property(nonatomic,retain) UIImageView *ivZoomIn;
@property(nonatomic,retain) UIImageView *ivZoomOut;
@property(nonatomic,retain) UIImageView *ivImage03;
@property(nonatomic,retain) UIImageView *ivOverlay;

- (void)updateLayout:(CGRect)frame;

- (void)startSplashSlideShow:(int)inhaleLength exhaleLength:(int)exhaleLength fadeLength:(int)fadeL cycles:(int)cycles;
- (void)stopSplashSlideShow;
-(void)updateScreen:(int)framePosition displayLengthIn:(int)displayLengthIn displayLengthOut:(int)displayLengthOut cycle:(int)cycle zoomIn:(BOOL)zoomIn;
- (void)showInfoOverlay:(NSString *)text;
- (void)showSubInfoOverlay:(NSString *)text;
- (id)initWithFrame:(CGRect)frame visual:(Visual *)vis;

- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
- (void)fadeOutView;
- (void)fadeInView:(id)delegate;
- (void)fadeOutInfo;
- (void)fadeInInfo;
- (void)fadeOutSubInfo;
- (void)fadeInSubInfo;
- (void)animShowView;

- (CGPoint)interpolatePoint:(CGPoint)point1 point2:(CGPoint)point2 modifier:(CGFloat)modifier;
- (CGSize)interpolateSize:(CGSize)size1 size2:(CGSize)size2 modifier:(CGFloat)modifier;
- (CGRect)interpolateRect:(CGRect)rect1 rect2:(CGRect)rect2 modifier:(CGFloat)modifier;

- (CGRect)minSizeRect:(CGFloat)imgAspect;
- (CGRect)maxSizeRect:(CGRect) imageMin;
@end
