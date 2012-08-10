//
//  ViewCellSettingSwitch.m
//  iBreath160
//
//  Created by Roger Reeder on 1/27/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

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
