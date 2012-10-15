//
//  ViewChartController.h
//  iBreathe
//
//  Created by Roger Reeder on 7/7/10.
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