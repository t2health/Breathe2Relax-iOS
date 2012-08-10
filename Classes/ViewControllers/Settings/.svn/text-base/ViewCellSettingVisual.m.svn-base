//
//  ViewCellSettingVisual.m
//  iBreath160
//
//  Created by Roger Reeder on 1/28/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

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
