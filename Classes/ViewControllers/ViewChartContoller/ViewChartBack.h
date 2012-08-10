
//
//  ViewChartBack.h
//  iBreathe130
//
//  Created by Roger Reeder on 9/16/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewChartBack : UIView {
	UIImage *backgroundImage;  //Name of image to use in repeating fashion for background
	NSDate *firstDate;
	CGFloat plotWidth;
	int maxPoints;
}
@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) NSDate *firstDate;
@property (nonatomic) CGFloat plotWidth;
@property (nonatomic) int maxPoints;

@end
