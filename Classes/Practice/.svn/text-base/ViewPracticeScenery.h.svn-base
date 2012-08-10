//
//  ViewPracticeScenery.h
//  iBreathe100
//
//  Created by Roger Reeder on 7/28/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

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
