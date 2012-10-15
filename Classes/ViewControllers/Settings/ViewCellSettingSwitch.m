//
//  ViewCellSettingSwitch.m
//  iBreath160
//
//  Created by Roger Reeder on 1/27/11.
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
#import "ViewCellSettingSwitch.h"

@implementation ViewCellSettingSwitch
@synthesize primaryLabel, secondaryLabel, toggleSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.

		self.primaryLabel = [[UILabel alloc]init];
		self.primaryLabel.textAlignment = UITextAlignmentLeft;
		self.primaryLabel.font = [UIFont systemFontOfSize:19];
		self.primaryLabel.backgroundColor = [UIColor clearColor];
		
		self.secondaryLabel = [[UILabel alloc]init];
		self.secondaryLabel.textAlignment = UITextAlignmentLeft;
		self.secondaryLabel.font = [UIFont systemFontOfSize:11];
		self.secondaryLabel.backgroundColor = [UIColor clearColor];
        UISwitch *ts = [[UISwitch alloc] init];
		self.toggleSwitch = ts;
        [ts release];
		
		[self.contentView addSubview:self.primaryLabel];
		[self.contentView addSubview:self.secondaryLabel];
		[self.contentView addSubview:self.toggleSwitch];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat padV,padH,padI,w,h,plh,slh,boundsX,togH,togW;
	CGRect contentRect = self.contentView.bounds;
	padH = 10.0f;
	padV = 5.0f;
	padI = 2.0f;
	w = contentRect.size.width;
	h = contentRect.size.height;
	plh = (h - (padV * 2.0f)) * 0.65f;
	slh = h - (padV * 2.0f) - plh;
	boundsX = contentRect.origin.x;
	togW = self.toggleSwitch.frame.size.width;
	togH = self.toggleSwitch.frame.size.height;
	self.toggleSwitch.frame = CGRectMake(boundsX+w-boundsX-togW-padH, (h-togH)/2.0f, togW, togH);
	self.primaryLabel.font = [self.primaryLabel.font fontWithSize:(plh)*0.8f];
	self.primaryLabel.frame = CGRectMake(boundsX+padH,padV, w - (padH * 2.0f)-togW - padI, plh);
	self.secondaryLabel.font = [self.secondaryLabel.font fontWithSize:(slh)*0.8f];
	self.secondaryLabel.frame = CGRectMake(boundsX+padH+padI , h-slh-padV, w-(padH * 2.0f)-togW - (padI * 2.0f),slh);
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}

@end
