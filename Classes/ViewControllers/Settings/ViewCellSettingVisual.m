//
//  ViewCellSettingVisual.m
//  iBreath160
//
//  Created by Roger Reeder on 1/28/11.
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
#import "ViewCellSettingVisual.h"


@implementation ViewCellSettingVisual
@synthesize primaryLabel, secondaryLabel, myImageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		primaryLabel = [[UILabel alloc]init];
		primaryLabel.textAlignment = UITextAlignmentLeft;
		primaryLabel.font = [UIFont systemFontOfSize:24];
		primaryLabel.backgroundColor = [UIColor clearColor];
		
		secondaryLabel = [[UILabel alloc]init];
		secondaryLabel.textAlignment = UITextAlignmentLeft;
		secondaryLabel.font = [UIFont systemFontOfSize:12];
		secondaryLabel.backgroundColor = [UIColor clearColor];
		
		myImageView = [[UIImageView alloc]init];
		myImageView.clipsToBounds = YES;
		[self.contentView addSubview:primaryLabel];
		[self.contentView addSubview:secondaryLabel];
		[self.contentView addSubview:myImageView];
    }
    return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	CGFloat padV,padH,padI,w,h,plh,slh,boundsX,imgH,imgW;
	CGRect contentRect = self.contentView.bounds;
	padH = 10.0f;
	padV = 5.0f;
	padI = 2.0f;
	w = contentRect.size.width;
	h = contentRect.size.height;
	plh = (h - (padV * 2.0f)) * 0.65f;
	slh = h - (padV * 2.0f) - plh;
	boundsX = contentRect.origin.x;
	imgH = h - (padV * 2.0f);
	imgW = imgH	* 1.2f;
	myImageView.frame = CGRectMake(boundsX + padH, padV, imgW, imgH);
	primaryLabel.font = [primaryLabel.font fontWithSize:(plh)*0.8f];
	primaryLabel.frame = CGRectMake(boundsX+padH+imgW+padI ,padV, w - imgW - (padH * 2.0f) - padI, plh);
	secondaryLabel.font = [secondaryLabel.font fontWithSize:(slh)*0.8f];
	secondaryLabel.frame = CGRectMake(boundsX+padH+imgW+(padI*2.0f) , h-slh-padV, w-imgW-(padH * 2.0f) - (padI * 2.0f),slh);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	
}


- (void)dealloc {
    [super dealloc];
}


@end
