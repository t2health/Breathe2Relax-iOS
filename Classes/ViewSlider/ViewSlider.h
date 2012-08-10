//
//  ViewSlider.h
//  iBreathe100
//
//  Created by Roger Reeder on 7/21/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface ViewSlider : UIView {
	UISlider *slider;
	UILabel *lblLeftSlider;
	UILabel *lblRightSlider;
	UIImageView *ivLeftSlider;
	UIImageView *ivRightSlider;
	UIImageView *ivGhost;
	
	float oldValue;
	CGFloat lblWidth;
}

@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) UILabel *lblLeftSlider;
@property (nonatomic, retain) UILabel *lblRightSlider;
@property (nonatomic, retain) UIImageView *ivLeftSlider;
@property (nonatomic, retain) UIImageView *ivRightSlider;
@property (nonatomic, retain) UIImageView *ivGhost;

- (id)initWithFrame:(CGRect)frame l:(NSString *)leftLabelText r:(NSString *)rightLabelText s:(int)fontSize w:(CGFloat)labelWidth;
- (void)updateLayout:(CGRect)frame s:(int)fontSize w:(CGFloat)labelWidth;

- (void) setOldValue:(float)value;
- (float) getOldValue;

@end
