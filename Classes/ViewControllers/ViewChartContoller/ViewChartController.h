//
//  ViewChartController.h
//  iBreathe
//
//  Created by Roger Reeder on 7/7/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewChart.h"
#import "ViewChartBack.h"
#import "ViewXChart.h"
#import "ViewBubbleBar.h"
#import "ViewVertBar.h"

@interface ViewChartController : UIViewController <UIScrollViewDelegate> {
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