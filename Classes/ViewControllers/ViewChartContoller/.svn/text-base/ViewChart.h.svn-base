//
//  ViewChart.h
//  iBreathe
//
//  Created by Roger Reeder on 7/7/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectDataAccess.h"


@interface ViewChart : UIView {
	int groupSeriesBy;
	NSDictionary *settings;
	id selectedItem;
	UIImage *backgroundImage;  //Name of image to use in repeating fashion for background
	ObjectDataAccess *dataConnection;
	int seriesBegin;
	int seriesEnd;
	CGFloat xPad;
	CGFloat yPad;
	CGFloat yUnit;
	CGFloat plotWidth;
	int maxPoints;
	int currentPoint;
	BOOL justUpdate;
	NSDate *firstDate;
	int weekendOffset;
	NSArray *dataPoint;
	NSArray *oldDataPoint;
}
@property (nonatomic, retain) NSDate *firstDate;
@property (nonatomic, retain) UIImage *backgroundImage;
//TODO: this and other variables in this file should be (nonatomic, assign)
@property (nonatomic) BOOL justUpdate;
@property (nonatomic, retain) NSArray *dataPoint;
@property (nonatomic, retain) NSArray *oldDataPoint;

- (id)initWithFrame:(CGRect)frame 
			andData:(ObjectDataAccess *)data 
   andUseThisSeries:(int)useThisSeries
  andNumberOfSeries:(int)numberOfSeries;

- (void)seriesColor:(int) seriesIndex colorToSet:(CGFloat *)color;
- (CGFloat)seriesWidth:(int) seriesIndex;
- (UIColor *)seriesUIColor:(int) seriesIndex;


@end
