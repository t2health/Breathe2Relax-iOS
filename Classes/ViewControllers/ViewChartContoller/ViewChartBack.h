
//
//  ViewChartBack.h
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
#import <UIKit/UIKit.h>


@interface ViewChartBack : UIView {
	UIImage *backgroundImage;  //Name of image to use in repeating fashion for background
	NSDate *firstDate;
	CGFloat plotWidth;
	int maxPoints;
}
@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) NSDate *firstDate;
@property (nonatomic) CGFloat plotWidth;
@property (nonatomic) int maxPoints;

@end
