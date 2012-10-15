//
//  ViewChartBack.m
//  iBreathe130
//
//  Created by Roger Reeder on 9/16/10.
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
#import "ViewChartBack.h"


@implementation ViewChartBack
@synthesize backgroundImage, firstDate, plotWidth, maxPoints;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:self.firstDate];
	NSInteger weekday = [weekdayComponents weekday];
	/***********************************************************************************************
	 Purpose of Weekend offset is to so that we put down the background image so that the weekends match up
	 
	 weekday 1 = Sunday  so   if we start on tuesday (3) and the counter will be 0 then the weekend offset will be
	 
	 
	 0 (tue) is 0 + 2 = 2 % 7 = 2
	 1 (wed) is 1 + 2 = 3 % 7 = 3
	 2 (thu) is 2 + 2 = 4 % 7 = 4
	 3 (fri) is 3 + 2 = 5 % 7 = 5
	 4 (sat) is 4 + 2 = 6 % 7 = 6 (weekend)
	 5 (sun) is 5 + 2 = 7 % 7 = 0 (weekend)
	 6 (mon) is 6 + 2 = 8 % 7 = 1	
	 
	 for (i = 0; i < maxPoints; i = i + 7
	 int weekendOffset =  [weekday intValue];
	 ***********************************************************************************************/
	int weekendOffset = weekday - 1;
	[gregorian release];
	CGRect r;
	for (int i = 0; i < maxPoints + 7; i=i+7) {
		r = CGRectMake((CGFloat)(i - weekendOffset)  * plotWidth - (plotWidth * 0.5), 0.0f, plotWidth * 7.0f, rect.size.height);
		[backgroundImage drawInRect:r];
	}
	
	CGContextSetLineDash(c, 0.0f, nil, 0);
	CGContextSetRGBStrokeColor(c, 0.6f, 0.6f, 1.0f, 1.0f);
	CGContextSetLineCap(c, kCGLineCapRound);
	CGContextSetLineJoin(c, kCGLineJoinRound);
	CGContextSetLineWidth(c, 5.0f);//(CGFloat)k);
	CGContextMoveToPoint(c, 2.0f, 3.0f);
	CGContextAddLineToPoint(c, rect.size.width - 2.0f, 3.0f);
	CGContextStrokePath(c);
	CGContextSetRGBStrokeColor(c, 0.6f, 0.6f, 1.0f, 1.0f);
	CGContextMoveToPoint(c, rect.size.width - 2.0f, 3.0f);
	CGContextAddLineToPoint(c, rect.size.width - 2.0f, rect.size.height - 2.0f);
	CGContextStrokePath(c);
	CGContextSetRGBStrokeColor(c, 0.6f, 0.6f, 1.0f, 1.0f);
	CGContextMoveToPoint(c, rect.size.width - 2.0f, rect.size.height - 2.0f);
	CGContextAddLineToPoint(c, 2.0f, rect.size.height - 2.0f);
	CGContextStrokePath(c);
	CGContextSetRGBStrokeColor(c, 0.6f, 0.6f, 1.0f, 1.0f);
	CGContextMoveToPoint(c, 2.0f, rect.size.height - 2.0f);
	CGContextAddLineToPoint(c, 2.0f, 3.0f);
	CGContextStrokePath(c);
	
	
}

- (void)dealloc {
    [super dealloc];
}


@end
