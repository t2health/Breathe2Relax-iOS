//
//  ViewCellSettingLine.m
//  Breathe
//
//  Created by Roger Reeder on 1/30/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewCellSettingLine.h"


@implementation ViewCellSettingLine

@synthesize primaryLabel, secondaryLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		primaryLabel = [[UILabel alloc]init];
		primaryLabel.textAlignment = UITextAlignmentLeft;
		primaryLabel.font = [UIFont systemFontOfSize:19];
		primaryLabel.backgroundColor = [UIColor clearColor];
		
		secondaryLabel = [[UILabel alloc]init];
		secondaryLabel.textAlignment = UITextAlignmentLeft;
		secondaryLabel.font = [UIFont systemFontOfSize:11];
		secondaryLabel.backgroundColor = [UIColor clearColor];
		
		
		[self.contentView addSubview:primaryLabel];
		[self.contentView addSubview:secondaryLabel];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGFloat padV,padH,padI,w,h,plh,slh,boundsX;
	CGRect contentRect = self.contentView.bounds;
	padH = 10.0f;
	padV = 5.0f;
	padI = 2.0f;
	w = contentRect.size.width;
	h = contentRect.size.height;
	plh = (h - (padV * 2.0f)) * 0.65f;
	slh = h - (padV * 2.0f) - plh;
	boundsX = contentRect.origin.x;
	primaryLabel.font = [primaryLabel.font fontWithSize:(plh)*0.8f];
	primaryLabel.frame = CGRectMake(boundsX+padH,padV, w - (padH * 2.0f), plh);
	secondaryLabel.font = [secondaryLabel.font fontWithSize:(slh)*0.8f];
	secondaryLabel.frame = CGRectMake(boundsX+padH+padI,h-slh-padV,w-(padH * 2.0f)-padI,slh);
}

- (void)dealloc {
    [super dealloc];
}


@end
