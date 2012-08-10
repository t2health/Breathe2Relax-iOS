//
//  ViewSlider.m
//  iBreathe100
//
//  Created by Roger Reeder on 7/21/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewSlider.h"


@implementation ViewSlider
@synthesize slider, lblLeftSlider, lblRightSlider, ivLeftSlider, ivRightSlider, ivGhost;

- (id)initWithFrame:(CGRect)frame l:(NSString *)leftLabelText r:(NSString *)rightLabelText s:(int)fontSize w:(CGFloat)labelWidth {
	if ((self = [super initWithFrame:frame])) {
		oldValue = 50.0f;
		CGFloat labelHeight = frame.size.height * 0.5f;
		CGFloat capWidth = 7.0f;
		CGFloat sliderWidth = frame.size.width - (2.0f * capWidth);
		CGFloat capHeight = 25.0f;
		CGFloat capGap = 2.0f;
		CGFloat ghostWidth = 33.0f;
		CGFloat ghostHeight = 65.0f;
		CGFloat ghostSliderWidth = sliderWidth - ghostWidth;
		NSString *t = [NSString stringWithFormat:@"%@", leftLabelText];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f , 0.0f, labelWidth, labelHeight)];
		UIFont *fLabel = [UIFont fontWithName:@"Helvetica" size:fontSize];
		label.font = fLabel;
		[label setTextAlignment: UITextAlignmentCenter];
		[label setLineBreakMode:UILineBreakModeClip];
		label.text = t;
		[label setTextColor:[UIColor whiteColor]];
		[label setShadowColor:[UIColor blackColor]];
		[label setShadowOffset:CGSizeMake(1.0f, 1.0f)];
		[label setBackgroundColor:[UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.0f]];
		[label setAlpha:1.0f];
		[self addSubview:label];
		self.lblLeftSlider = label;
		[label release];
		
		t = [NSString stringWithFormat:@"%@", rightLabelText];
		label = [[UILabel alloc]  initWithFrame:CGRectMake( frame.size.width - labelWidth, 0.0f, labelWidth, labelHeight)];
		label.font = fLabel;
		[label setTextAlignment: UITextAlignmentCenter];
		[label setLineBreakMode:UILineBreakModeClip];
		label.text = t;
		[label setTextColor:[UIColor whiteColor]];
		[label setShadowColor:[UIColor blackColor]];
		[label setShadowOffset:CGSizeMake(1.0f, 1.0f)];
		[label setBackgroundColor:[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.0f]];
		[label setAlpha:1.0f];
		[self addSubview:label];
		self.lblRightSlider = label;
		[label release];
		
		
		// Ghost Image
		UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sliderknoborange.png"]];
		[iv setFrame:CGRectMake(0.0f, 0.0f, ghostWidth, ghostHeight)];
		[iv setCenter:CGPointMake(capWidth + (ghostWidth * 0.5f) + (ghostSliderWidth / 100.0f) * oldValue, frame.size.height * 0.5f)];
		iv.alpha = 0.6f;
		[self addSubview:iv];
		self.ivGhost = iv;
		[iv release];
		
		//Left Cap on Slider
		iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftend.png"]];
		[iv setFrame:CGRectMake(((frame.size.width - sliderWidth) * 0.5f) - capWidth + capGap, (frame.size.height - capHeight) * 0.5f, capWidth, capHeight)];
		[self addSubview:iv];
		self.ivLeftSlider = iv;
		[iv release];
		
		//Right Cap on Slider
		iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightend.png"]];
		[iv setFrame:CGRectMake(((frame.size.width - sliderWidth) * 0.5f) + sliderWidth - capGap, (frame.size.height - capHeight) * 0.5f, capWidth, capHeight)];
		[self addSubview:iv];
		self.ivRightSlider = iv;
		[iv release];
		
		UISlider *s = [[UISlider alloc] initWithFrame:CGRectMake(capWidth, 0.0f, frame.size.width - (capWidth * 2.0f), frame.size.height)] ;
		s.maximumValue = 100;
		s.minimumValue = 0;
		s.value = 50;
		[s setThumbImage:[UIImage imageNamed:@"sliderknob.png"] forState:UIControlStateNormal];
		[s setThumbImage:[UIImage imageNamed:@"sliderknob.png"] forState:UIControlStateHighlighted];
		[s setMaximumTrackImage:[UIImage imageNamed:@"sliderbar.png"] forState:UIControlStateNormal];
		[s setMinimumTrackImage:[UIImage imageNamed:@"sliderbar.png"] forState:UIControlStateNormal];
		[self addSubview:s];
		self.slider = s;
		[s release];
	}
	[self updateLayout:frame s:fontSize w:labelWidth];
	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)updateLayout:(CGRect)frame s:(int)fontSize w:(CGFloat)labelWidth {
	lblWidth = labelWidth;
	CGFloat capWidth = 7.0f;
	CGFloat ghostWidth = 33.0f;
	CGFloat sliderWidth = frame.size.width - lblWidth + ghostWidth;
	CGFloat capHeight = 25.0f;
	CGFloat capGap = 2.0f;
	CGFloat labelHeight = frame.size.height * 0.5f;
	CGFloat ghostSliderWidth = sliderWidth - ghostWidth;
    
	[self setFrame:frame];
	
    [self.lblLeftSlider setFrame:CGRectMake(0.0f, 0.0f, labelWidth, labelHeight)];
	self.lblLeftSlider.font	= [lblLeftSlider.font fontWithSize:(CGFloat)fontSize];
	
    [self.lblRightSlider setFrame:CGRectMake(frame.size.width - labelWidth, 0.0f, labelWidth, labelHeight)];
	self.lblRightSlider.font = [self.lblRightSlider.font fontWithSize:(CGFloat)fontSize];
	
	[self.ivLeftSlider setFrame:CGRectMake(((frame.size.width - sliderWidth) * 0.5f) - capWidth + capGap, (frame.size.height - capHeight) * 0.5f, capWidth, capHeight)];
	[self.ivRightSlider setFrame:CGRectMake(((frame.size.width - sliderWidth) * 0.5f) + sliderWidth - capGap , (frame.size.height - capHeight) * 0.5f, capWidth, capHeight)];
	
	[self.ivGhost setCenter:CGPointMake((frame.size.width - sliderWidth) * 0.5f + (ghostWidth * 0.5f) + (ghostSliderWidth / 100.0f) * oldValue, frame.size.height * 0.5f)];
	
	[self.slider setFrame:CGRectMake((frame.size.width - sliderWidth) * 0.5f, 0.0f, sliderWidth, frame.size.height)];
}

//TODO: Replace getters and setters with @synthisize
- (void) setOldValue:(float)value {
	oldValue = value;
	CGFloat ghostWidth = 33.0f;
	CGFloat ghostSliderWidth = slider.frame.size.width - ghostWidth;
	[self.ivGhost setCenter:CGPointMake((self.frame.size.width * 0.5f) - (ghostSliderWidth * 0.5f) + (ghostSliderWidth / 100.0f) * oldValue, self.ivGhost.center.y)];
}
- (float) getOldValue {
	return oldValue;
}

@end
