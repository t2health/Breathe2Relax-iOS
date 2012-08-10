//
//  ViewXChart.h
//  iBreathe130
//
//  Created by Roger Reeder on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewXChart : UIView {
	id selectedItem;
	CGFloat xPad;
	CGFloat yPad;
	CGFloat yUnit;
	CGFloat plotWidth;
	NSDate *startDate;
	int numberOfLabel;  //Should be odd for best results.  3,5,9 etc
	int maxPoints;
}
- (id)initWithFrame:(CGRect)frame 
			andStartDate:(NSString *)date
	   andMaxPoints:(int)points
  andNumberOfLabels:(int)labels; 

- (int)getNumberOfSeries;
- (void)seriesColor:(int) seriesIndex colorToSet:(CGFloat *)color;
- (CGFloat)seriesWidth:(int) seriesIndex;

- (BOOL)isSeriesValue:(int)x andY:(int)y;
- (CGFloat)getSeriesValue:(int)x andY:(int)y;
- (UIColor *)seriesUIColor:(int) seriesIndex;
- (NSString *)seriesLabel:(int) seriesIndex;
- (NSString *)getSeriesValueLabel:(int)x;

@end
