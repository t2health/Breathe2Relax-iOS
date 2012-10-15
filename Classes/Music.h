//
//  Music.h
//  Breathe2Relax
//
//  Created by Roger Reeder on 3/28/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
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
#import <Foundation/Foundation.h>


@interface Music : NSObject {
	NSString	*title;
	NSString	*description;
	NSString	*bundleName;
	NSString	*album;
	NSString	*artist;
    NSString    *credit;
}
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *bundleName;
@property(nonatomic, copy) NSString *album;
@property(nonatomic, copy) NSString *artist;
@property(nonatomic, copy) NSString *credit;

- (id)initWithName:(NSString *)t 
            artist:(NSString *)art
		bundleName:(NSString *)bundle
	         album:(NSString *)alb 
       description:(NSString *)desc
            credit:(NSString *)cred;
@end
