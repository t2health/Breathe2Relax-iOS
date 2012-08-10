//
//  ViewChart.m
//  iBreathe
//
//  Created by Roger Reeder on 7/7/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewChart.h"


@implementation ViewChart
@synthesize justUpdate, backgroundImage, dataPoint, oldDataPoint, firstDate;

- (id)initWithFrame:(CGRect)frame 
			andData:(ObjectDataAccess *)data   
   andUseThisSeries:(int)useThisSeries
  andNumberOfSeries:(int)numberOfSeries {
    if ((self = [super initWithFrame:frame])) {
		justUpdate = NO;
		currentPoint = 0;
		settings = [[NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chartProperties" ofType:@"plist"]] mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil] retain];
		dataConnection = data;
		seriesBegin= useThisSeries;
		seriesEnd = useThisSeries + numberOfSeries - 1;
		groupSeriesBy = 1;
		
		
		NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
		[df setDateFormat:@"yyyy-MM-dd"];
		self.firstDate = [dataConnection getFirstSessionDate];
		if (self.firstDate == nil) {
			self.firstDate = [NSDate date];
		}
		self.firstDate = [df dateFromString:[df stringFromDate:self.firstDate]];
		self.firstDate = [self.firstDate dateByAddingTimeInterval:-(DAYINSEC)];
		
		NSDate *previousDate;
		//previousDate = [dataConnection getLastSessionDate];
		//if (previousDate == nil) {
		previousDate = [NSDate date];
		//}
		previousDate = [df dateFromString:[df stringFromDate:previousDate]];
		previousDate = [previousDate dateByAddingTimeInterval:(DAYINSEC)*2];
		NSTimeInterval interval = [self.firstDate timeIntervalSinceDate:previousDate];
		maxPoints =  (int)(-interval / (DAYINSEC));
		if (maxPoints < 8) {
			self.firstDate = [self.firstDate dateByAddingTimeInterval:-(DAYINSEC) * (8 - maxPoints)];
			interval = [self.firstDate timeIntervalSinceDate:previousDate];
			maxPoints =  (int)(-interval / (DAYINSEC));
		}
		
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:self.firstDate];
		NSInteger weekday = [weekdayComponents weekday];
		/***********************************************************************************************
		 Purpose of Weekend offset is to convert counter to a value that modulus 7 will result in 0 or 1
		 For Saturday and Sunday for the purpose of render different vertical lines.
		 
		 weekday 1 = Sunday  so   if we start on tuesday (3) and the counter will be 0 then the weekend offset will be
		 
		 
		 0 (tue) is 0 + 3 = 3 % 7 = 3
		 1 (wed) is 1 + 3 = 4 % 7 = 4
		 2 (thu) is 2 + 3 = 5 % 7 = 5
		 3 (fri) is 3 + 3 = 6 % 7 = 6
		 4 (sat) is 4 + 3 = 7 % 7 = 0 (weekend)
		 5 (sun) is 5 + 3 = 8 % 7 = 1 (weekend)
		 6 (mon) is 6 + 3 = 9 & 7 = 2	
		 
		 if (counter + weekendOffset) % 7  < 2 then it's a weekend)  simple calculation as we render vertical lines.  
		 int weekendOffset =  [weekday intValue];
		 ***********************************************************************************************/
		weekendOffset = weekday;
		[gregorian release];
		
		yUnit = frame.size.height / 100.0f;
		plotWidth = frame.size.width / (CGFloat)(maxPoints - 1);
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
	//int i,j,k;
	CGFloat graphicLineWidth = 7.0f;
	CGFloat color[4];
	CGFloat ghost[4];
	BOOL bGhost = NO;
	float pattern[2] = {0.0f, 4.0f}; // dots
	if (rect.size.width != self.frame.size.width) {
		if (rect.size.width > plotWidth * 1.5f) {
			bGhost = YES;
		}
		if (dataPoint != nil) {
			for (int i = seriesBegin; i <= seriesEnd; i++) {
				[self seriesColor:i colorToSet:color];
				graphicLineWidth = [self seriesWidth:i];
				
				CGContextSetLineCap(c, kCGLineCapRound);
				CGContextSetLineJoin(c, kCGLineJoinRound);
				CGContextSetLineWidth(c, graphicLineWidth);//(CGFloat)k);
				
				NSDictionary *oldrecord = [oldDataPoint objectAtIndex:i];
				NSDictionary *newrecord = [dataPoint objectAtIndex:i];
				
				if (bGhost) {
					for (int i = 0; i < 4; i++) {
						ghost[i] = color[i];
					}
					ghost[3] = ghost[3] * 0.5f;
					//for (int i = 0; i < 2; i++) {
					pattern[1] = graphicLineWidth - 2.0f;
					//}
					CGContextSetLineDash(c, 0.0f, pattern, 2);
					CGContextSetStrokeColor(c, ghost);
				}else {
					CGContextSetLineDash(c, 0.0f, nil, 0);
					CGContextSetStrokeColor(c, color);
				}
				CGFloat y = [(NSNumber *)[oldrecord valueForKey:@"fldValue"] floatValue];
				CGContextMoveToPoint(c, rect.origin.x + rect.size.width, rect.origin.y + ((100.0f-y) * yUnit));
				y = [(NSNumber *)[newrecord valueForKey:@"fldValue"] floatValue];
				CGContextAddLineToPoint(c, rect.origin.x+1.0f, rect.origin.y + ((100.0f-y) * yUnit));
				CGContextStrokePath(c);
				CGContextSetLineDash(c, 0.0f, nil, 0);
				CGContextSetStrokeColor(c, color);
				CGContextMoveToPoint(c, rect.origin.x+1.0f, rect.origin.y + ((100.0f-y) * yUnit));
				CGContextAddLineToPoint(c, rect.origin.x, rect.origin.y + ((100.0f-y) * yUnit));
				CGContextStrokePath(c);
				if (bGhost) {
					CGContextSetStrokeColor(c, color);
					CGContextSetLineDash(c, 0.0f, nil, 0);
					y = [(NSNumber *)[oldrecord valueForKey:@"fldValue"] floatValue];
					CGContextMoveToPoint(c, rect.origin.x + rect.size.width, rect.origin.y + ((100.0f-y) * yUnit));
					CGContextAddLineToPoint(c, rect.origin.x + rect.size.width - 1.0f, rect.origin.y + ((100.0f-y) * yUnit));
					y = [(NSNumber *)[newrecord valueForKey:@"fldValue"] floatValue];
					CGContextMoveToPoint(c, rect.origin.x, rect.origin.y + ((100.0f-y) * yUnit));
					CGContextAddLineToPoint(c, rect.origin.x + 1.0f, rect.origin.y + ((100.0f-y) * yUnit));
					CGContextStrokePath(c);
				}
			}
		}
		self.oldDataPoint = self.dataPoint;
	}
}


- (void)dealloc {
    [super dealloc];
}

- (NSString *)seriesLabel:(int) seriesIndex {
	NSArray *s = [settings valueForKey:@"Series"];
	if ([s count] <= seriesIndex) {
		return @"";
	}
	NSDictionary *dict = [s objectAtIndex:seriesIndex];
	NSString *t =[dict valueForKey:@"label"];
	return t;
}

- (UIColor *)seriesUIColor:(int) seriesIndex {
	NSArray *s = [settings valueForKey:@"Series"];
	if ([s count] <= seriesIndex) {
		return [UIColor whiteColor];
	}
	NSDictionary *dict = [s objectAtIndex:seriesIndex];
	dict =[dict valueForKey:@"line"];
	dict = [dict valueForKey:@"color"];
	UIColor *c = [[[UIColor alloc] initWithRed:[[dict valueForKey:@"red"] floatValue] green:[[dict valueForKey:@"green"] floatValue] blue:[[dict valueForKey:@"blue"] floatValue] alpha:[[dict valueForKey:@"alpha"] floatValue]] autorelease];

	return c;
}
- (void)seriesColor:(int) seriesIndex colorToSet:(CGFloat *)color {
	NSArray *s = [settings valueForKey:@"Series"];
	CGFloat defaultColor[4] = {1.0f,1.0f,1.0f,0.7f};
	if ([s count] > seriesIndex) {
		NSDictionary *dict = [s objectAtIndex:seriesIndex];
		dict =[dict valueForKey:@"line"];
		dict = [dict valueForKey:@"color"];
		color[0] = [[dict valueForKey:@"red"] floatValue];
		color[1] = [[dict valueForKey:@"green"] floatValue];
		color[2] = [[dict valueForKey:@"blue"] floatValue];
		color[3] = [[dict valueForKey:@"alpha"] floatValue];
	}
	else {
		for (int i = 0; i < 4; i++) {
			color[i] = defaultColor[i];
		}
	}
	
}

- (CGFloat)seriesWidth:(int) seriesIndex {
	CGFloat w = 3.0f;
	NSArray *s = [settings valueForKey:@"Series"];
	if ([s count] > seriesIndex) {
		NSDictionary *dict = [s objectAtIndex:seriesIndex];
		dict =[dict valueForKey:@"line"];
		NSString *t =[dict valueForKey:@"width"];
		w = [t floatValue];
	}
	return w;
}

@end
