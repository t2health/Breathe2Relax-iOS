//
//  ViewBubbleBar.m
//  iBreathe130
//
//  Created by Roger Reeder on 8/31/10.
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
#import "ViewBubbleBar.h"

@implementation ViewBubbleBar
@synthesize startDate;

- (id)initWithFrame:(CGRect)frame 
	   andStartDate:(NSString *)date
	   andMaxPoints:(int)points
  andNumberOfLabels:(int)nlabels {
	if ((self = [super initWithFrame:frame])) {
		NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
		[df setDateFormat:@"yyyy-MM-dd"];
		
		self.startDate = [df dateFromString:date];
		maxPoints = points;
		numberOfLabels = nlabels;
		lastBar = -1;
		[self initDisplay:frame];
    }
    return self;
}

- (void)initDisplay:(CGRect)rect {
    // Drawing code
 	
	
	plotWidth = rect.size.width/(CGFloat)(numberOfLabels - 1);
	
	
	NSString *tDay;
	NSString *tMonth;
	NSString *tYear;
	NSString *tTitle;
	
	CGFloat x,y,w,h;
	y = 0.0f;
	h = rect.size.height;
	w = h * 1.2f;
	
	NSDateFormatter *dfDisplay = [[[NSDateFormatter alloc] init] autorelease];
	[dfDisplay setDateFormat:@"EEE MM/dd/yyyy"];
	for (int i= 0; i<numberOfLabels; i++) {
		NSDate *newDate =[startDate dateByAddingTimeInterval:(DAYINSEC * i)];
		NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
		NSDateComponents *dayComponents = [gregorian components:NSYearCalendarUnit+NSMonthCalendarUnit+NSDayCalendarUnit+NSWeekdayCalendarUnit fromDate:newDate];
		tTitle = [NSString stringWithFormat:@"%d",[dayComponents day]];
		tDay = [self weekdayString:[dayComponents weekday]];
		tMonth = [self monthString:[dayComponents month]];
		tYear = [NSString stringWithFormat:@"%d", [dayComponents year]];

		x = (CGFloat)i * plotWidth - (w * 0.5f);
		
		ViewXLabel *v = [[ViewXLabel alloc] initWithFrame:CGRectMake(x, y, w, h) 
														  andTitle:tTitle 
															andDay:tDay 
														  andMonth:tMonth
														   andYear:tYear];
		v.backgroundColor = [UIColor clearColor];
		if (i >= (numberOfLabels/2 + 1)) {
			[self insertSubview:v belowSubview:labels[i-1]];
		}else {
			[self addSubview:v];
		}
		labels[i] = v;
		[v release];
	}
}
	
- (void)updateBubble:(CGFloat)offset withWhichBar:(int)whichBar {
	CGPoint newPt;
	CGFloat newAlpha = 1.0f;
	CGPoint bubbleCenter =CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
	CGFloat calcWidth = (self.frame.size.width + plotWidth) * 0.5f;
	int labelOffset = numberOfLabels/2;
	int thisDay = 0;

	NSDateFormatter *dfDisplay = [[[NSDateFormatter alloc] init] autorelease];
	[dfDisplay setDateFormat:@"EEE MM/dd/yyyy"];
	for (int i = 0; i < numberOfLabels; i++) {
		NSDate *newDate =[startDate dateByAddingTimeInterval:(DAYINSEC * (whichBar + i - labelOffset))];
		if (lastBar != whichBar) {
			NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
			NSDateComponents *dayComponents = [gregorian components:NSYearCalendarUnit+NSMonthCalendarUnit+NSDayCalendarUnit+NSWeekdayCalendarUnit fromDate:newDate];
			labels[i].titleText.text = [NSString stringWithFormat:@"%d",[dayComponents day]];
			labels[i].dayText.text = [self weekdayString:[dayComponents weekday]];
			labels[i].monthText.text = [self monthString:[dayComponents month]];
			labels[i].yearText.text = [NSString stringWithFormat:@"%d", [dayComponents year]];
		}

		newAlpha = (calcWidth - fabs((plotWidth * 0.5f) + labels[i].center.x - calcWidth + offset)) / calcWidth;
		newAlpha = newAlpha - 0.75f;
		if (newAlpha < 0.0f) {
			newAlpha = (newAlpha + 0.75f) * 0.33f;
		}else {
			newAlpha = 0.25f + newAlpha * 4.0f;
		}
		thisDay = i + whichBar - labelOffset;
		if (thisDay < 0  || thisDay > maxPoints - 1  ) {
			labels[i].hidden = YES;
		}else {
			labels[i].hidden = NO;
		}
		newPt = CGPointMake(labels[i].center.x, bubbleCenter.y - (bubbleCenter.y * (newAlpha * 1.5f)));
		[labels[i] scaleLabel:self andCenter:newPt andAlpha:newAlpha];
	}
	lastBar = whichBar;
}

- (void)dealloc {
	//TODO: Is this necessary?
	for (int i = 0; i < numberOfLabels; i++) {
		[labels[i] removeFromSuperview];
	}
    [super dealloc];
}

- (NSString *)monthString:(int)monthValue {
	NSString *returnString = @"";
	switch (monthValue) {
		case 1:
			returnString = @"Jan";
			break;
		case 2:
			returnString = @"Feb";
			break;
		case 3:
			returnString = @"Mar";
			break;
		case 4:
			returnString = @"Apr";
			break;
		case 5:
			returnString = @"May";
			break;
		case 6:
			returnString = @"Jun";
			break;
		case 7:
			returnString = @"Jul";
			break;
		case 8:
			returnString = @"Aug";
			break;
		case 9:
			returnString = @"Sep";
			break;
		case 10:
			returnString = @"Oct";
			break;
		case 11:
			returnString = @"Nov";
			break;
		case 12:
			returnString = @"Dec";
			break;
		default:
			break;
	}
	return returnString;
}

- (NSString *)weekdayString:(int)weekdayValue {
	NSString *returnString = @"";
	switch (weekdayValue) {
		case 1:
			returnString = @"Sun";
			break;
		case 2:
			returnString = @"Mon";
			break;
		case 3:
			returnString = @"Tue";
			break;
		case 4:
			returnString = @"Wed";
			break;
		case 5:
			returnString = @"Thu";
			break;
		case 6:
			returnString = @"Fri";
			break;
		case 7:
			returnString = @"Sat";
			break;
		default:
			break;
	}
	return returnString;
}


@end
