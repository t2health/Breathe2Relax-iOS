//
//  ViewTubeGauge.h
//  iBreathe110
//
//  Created by Roger Reeder on 7/30/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RootViewController;
@interface ViewTubeGauge : UIView {

	UIImageView *tubeTop;
	UIImageView *tubeMid;
	UIImageView *tubeBottom;
	UIImageView *tubeBack;
	UIImageView *tubeLiquidHighlight;
	
	UIImageView *liquidTop;
	UIImageView *liquidMid;
	UIImageView *liquidBottom;
	
	CGFloat tubeAlpha;
	CGFloat liquidAlpha;
	CGFloat liquidLevel;
	CGFloat scaleValue;
	RootViewController *parentController;
	
}
@property (nonatomic, retain) RootViewController *parentController;

@property (nonatomic) CGFloat tubeAlpha;
@property (nonatomic) CGFloat liquidAlpha;
@property (nonatomic) CGFloat liquidLevel;

-(void) updateLayout:(CGRect)frame;
-(void) updateLiquidLevel;
-(void) updateLiquidAlpha:(CGFloat)newAlpha;
-(void) updateTubeAlpha:(CGFloat)newAlpha;
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
- (void)fadeOutView;
- (void)fadeInView:(id)delegate;
- (void)animShowView;

@end
