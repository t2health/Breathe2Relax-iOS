//
//  ViewCellSettingMusic.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/11/11.
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
#import "ViewCellSettingMusic.h"


@implementation ViewCellSettingMusic
@synthesize primaryLabel;
@synthesize secondaryLabel;
@synthesize creditLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		self.primaryLabel = [[UILabel alloc]init];
		self.primaryLabel.textAlignment = UITextAlignmentLeft;
		self.primaryLabel.font = [UIFont systemFontOfSize:8];
        self.primaryLabel.textColor = [UIColor blackColor];
		self.primaryLabel.backgroundColor = [UIColor clearColor];
		
		self.secondaryLabel = [[UILabel alloc]init];
		self.secondaryLabel.textAlignment = UITextAlignmentLeft;
		self.secondaryLabel.font = [UIFont systemFontOfSize:8];
		self.secondaryLabel.backgroundColor = [UIColor clearColor];
        self.secondaryLabel.numberOfLines = 0;
        self.secondaryLabel.textColor = [UIColor blackColor];
        self.secondaryLabel.lineBreakMode = UILineBreakModeWordWrap;
		
		self.creditLabel = [[UILabel alloc]init];
		self.creditLabel.textAlignment = UITextAlignmentLeft;
		self.creditLabel.font = [UIFont systemFontOfSize:8];
        self.creditLabel.textColor = [UIColor blackColor];
		self.creditLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)layoutSubviews {
	
	[super layoutSubviews];
	CGFloat padV,padH,padI,w,h,plh,slh,clh,boundsX;
	CGRect contentRect = self.contentView.bounds;
	padH = 5.0f;
	padV = 1.0f;
	padI = 2.0f;
	w = contentRect.size.width;
	h = contentRect.size.height;
	plh = (h - (padV * 3.0f)) * 0.45f;
	slh = ((h - (padV * 3.0f)) - plh) * 0.75f;
	clh = (h - (padV * 3.0f)) - plh - slh;
	boundsX = contentRect.origin.x;
    CGRect pRect = CGRectMake(boundsX+padH ,padV, w - (padH * 2.0f) - padI, plh);
    CGRect sRect = CGRectMake(boundsX+padH+padI , h-slh-padV, w-(padH * 2.0f) - (padI * 2.0f),slh);
    CGRect cRect = CGRectMake(boundsX+padH+padI , h-slh-(padV*2.0f)-clh, w-(padH * 2.0f) - (padI * 2.0f),clh);
	//self.primaryLabel.font = [primaryLabel.font fontWithSize:plh*0.8f];
	self.primaryLabel.frame = pRect;
	//self.secondaryLabel.font = [secondaryLabel.font fontWithSize:(slh)*0.8f];
	self.secondaryLabel.frame = sRect;
	//self.creditLabel.font = [secondaryLabel.font fontWithSize:(slh)*0.8f];
	self.creditLabel.frame = cRect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
