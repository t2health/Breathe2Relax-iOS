//
//  ViewBubbleBar.h
//  iBreathe130
//
//  Created by Roger Reeder on 8/31/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewXLabel.h"

@interface ViewBubbleBar : UIView {
	id selectedItem;
	UIFont *defaultFont;
	CGFloat xPad;
	CGFloat yPad;
	CGFloat yUnit;
	CGFloat plotWidth;
	NSDate *startDate;
	int numberOfLabels;  //Should be odd for best results.  3,5,9 etc
	int maxPoints;
	ViewXLabel *labels[99];
	int lastBar;
}
@property (nonatomic, retain) NSDate *startDate;

- (id)initWithFrame:(CGRect)frame 
	   andStartDate:(NSString *)date
	   andMaxPoints:(int)points
  andNumberOfLabels:(int)nlabels; 

- (void)initDisplay:(CGRect)rect;
- (void)updateBubble:(CGFloat)offset withWhichBar:(int)whichBar;
- (NSString *)monthString:(int)monthValue;
- (NSString *)weekdayString:(int)weekdayValue;
@end
