//
//  ViewVertBar.m
//  iBreathe130
//
//  Created by Roger Reeder on 9/2/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewVertBar.h"


@implementation ViewVertBar

- (id)initWithFrame:(CGRect)frame withBarColor:(UIColor *)barColor {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		cBarCenter = CGColorCreateCopy(barColor.CGColor); 
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
	
	CGGradientRef myGradient;
	CGColorSpaceRef myColorSpace;
	size_t num_locations = 2;
	CGFloat locations[2] = {0.0f, 1.0f};
	CGFloat components[8];
	const CGFloat *comps1 = CGColorGetComponents(cBarCenter);
	for (int i = 0 ; i < 4 ; i++) {
		components[i] = comps1[i];
	}
	for (int i = 0 ; i < 3 ; i++) {
		components[i+4] = comps1[i];
	}
	components[7] = 0.0f;
	myColorSpace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, num_locations);
	
	
	//left side
	CGPoint myStartPoint = CGPointMake(rect.size.width * 0.5f, rect.size.height * 0.5f);
	CGPoint myEndPoint = CGPointMake(0.0f, rect.size.height * 0.5f);
	//draw gradient into context
	CGContextDrawLinearGradient(c, myGradient, myStartPoint, myEndPoint, 0);

	//fill in the middle.
	//CGContextSetRGBFillColor(c, 0.01f, 0.1f, 0.95f, 1.0f);
	//CGContextFillRect(c, CGRectMake(rect.size.width * 0.25f, 0.0f, rect.size.width * 0.5f, rect.size.height));
	
	//right side
	myStartPoint = CGPointMake(rect.size.width * 0.5f, rect.size.height * 0.5f);
	myEndPoint = CGPointMake(rect.size.width, rect.size.height * 0.5f);
	//draw gradient into context
	CGContextDrawLinearGradient(c, myGradient, myStartPoint, myEndPoint, 0);
}

- (void)dealloc {
    [super dealloc];
}

@end
