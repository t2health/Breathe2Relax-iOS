//
//  ViewChartWrapperController.h
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/27/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewChart.h"
#import "ViewChartBack.h"
#import "ViewXChart.h"
#import "ViewBubbleBar.h"
#import "ViewVertBar.h"
#import "ViewHelpTipsInfo.h"


@interface ViewChartWrapperController : UIViewController  <UIScrollViewDelegate>{
	UIImage *iBackground;
	int groupSeriesBy;
	NSArray *seriesToRender;
	UIScrollView *svChart;
	ViewChart *vChart[4];		//The All Important Charts
	ViewChartBack *vbChart[4];
	ViewXChart *vxChart;	//X axis reference stuff
	ViewBubbleBar *vbbXBar;
	ViewVertBar *vvbVertBar;
	int maxPoints;
	CGFloat plotWidth;
	CGFloat xPad;
	CGFloat yPad;
	UILabel *lChartLabels[4][2];
	CGPoint pChartLabelOffsets[4][2];
	CGPoint pXChartOffset;
	CGPoint pVertBarOffset;
	int currentPoint;
	NSTimer *timer;
	NSTimeInterval timeInterval;
	NSDate *firstDate;
	NSDate *previousDate;
	int sessionID;
	NSArray *dataPoint;
	UIView *vLegend;
	UIButton *bLegend;
    int numberOfCharts;
    ViewHelpTipsInfo *helpTips;
}
@property (nonatomic, retain) NSArray *seriesToRender;
@property (nonatomic, retain) NSDate *firstDate;
@property (nonatomic, retain) NSDate *previousDate;
@property (nonatomic) int numberOfCharts;

- (void) updateLayout:(CGRect)frame;

- (void) initDisplay;

- (void) showGuide;

- (void) startGraphing;

- (void) animationHasFinished:(NSString *)animationID 
					 finished:(BOOL)finished 
					  context:(void *)context;

- (void) fadeOutView;

- (void) fadeInView;

- (void) animShowView;

- (void) legendButton_TouchDown:(id)sender;

- (void) updateBar:(CGPoint)centerFocus 
		withOffset:(CGFloat)offset 
	  withWhichBar:(int)whichBar;

- (void) updateGraph:(NSTimer *)theTimer;
@end
