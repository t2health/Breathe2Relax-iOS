//
//  ViewCellSettingMusic.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/11/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

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
