//
//  ViewXChart.m
//  iBreathe130
//
//  Created by Roger Reeder on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ViewXChart.h"


@implementation ViewXChart


- (id)initWithFrame:(CGRect)frame 
	   andStartDate:(NSString *)date
	   andMaxPoints:(int)points
  andNumberOfLabels:(int)labels {
    if (self = [super initWithFrame:frame]) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		startDate = [df dateFromString:tDay];
		maxPoints = points;
		}
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
	int i,j;

	
	//  Gradient Background...
	CGGradientRef myGradient;
	CGColorSpaceRef myColorSpace;
	size_t num_locations = 2;
	CGFloat locations[2] = {0.0f, 1.0f};
	CGFloat components[8] = {
		0.0f, 0.0f, 0.0f, 0.0f, // Start color
		0.0f, 0.0f, 0.0f, 1.0f	// End color
	};
	
	myColorSpace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, num_locations);
	
	yUnit = (rect.size.height - yPad * (CGFloat)(1 + groupSeriesBy)) / 100.0f / (CGFloat)groupSeriesBy;
	
	//apply gradient on vertical axis
	CGPoint myStartPoint = CGPointMake(rect.size.width/2.0f, 0.0f);
	CGPoint myEndPoint = CGPointMake(rect.size.width/2.0f, rect.size.height * 0.2f);
	CGContextDrawLinearGradient(c, myGradient, myStartPoint, myEndPoint, 0);

	
	//fill in the rest.
	CGContextSetRGBFillColor(c, 0.0f, 0.0f, 0.0f, 1.0f);
	CGContextFillRect(c, CGRectMake(0.0f, rect.size.height * 0.2f, rect.size.width, rect.size.height));
	
	
	xPad = 0.0f;
	yPad = 0.0f;
	plotWidth = (rect.size.width - xPad * 2.0f)/(CGFloat)(maxPoints - 1);
	
	// Draw Rotated Text....
	CGFloat fontSize = plotWidth * 0.8f;
	if (fontSize > rect.size.height / 3.0f) {
		fontSize = rect.size.height / 3.0f;
	}
	CGPoint textPoint = CGPointMake(rect.size.width - xPad - plotWidth - fontSize, fontSize * 0.6f);
	CGPoint textMonthPoint = CGPointMake(rect.size.width - xPad - plotWidth - fontSize, rect.size.height - fontSize * 1.7f);
	UIFont *f = [UIFont fontWithName:@"Helvetica" size:fontSize];
	UIFont *fM = [UIFont fontWithName:@"Helvetica" size:fontSize * 1.5f];
	NSString *t;
	NSString *tPrint;
	NSRange dayRange;
	NSRange monthRange;
	NSString *tMonth;
	dayRange.location = 7;
	dayRange.length = 2;
	monthRange.location = 4;
	monthRange.length = 2;
	BOOL bWeekend = NO;
	for (j = 0; j < groupSeriesBy; j++) {
		for (i=0; i < maxPoints; i++) {
			//draw vertical lines
			t = [self getSeriesValueLabel:i];
			if ([t hasPrefix:@"Sun"]) {
				bWeekend = !bWeekend;
			}
			tMonth = @"";
			if ([t length] > 4 ) {
				tPrint = [t substringWithRange:monthRange];
				switch ([tPrint intValue]) {
					case 1:
						tMonth = @"Jan";
						break;
					case 2:
						tMonth = @"Feb";
						break;
					case 3:
						tMonth = @"Mar";
						break;
					case 4:
						tMonth = @"Apr";
						break;
					case 5:
						tMonth = @"May";
						break;
					case 6:
						tMonth = @"Jun";
						break;
					case 7:
						tMonth = @"Jul";
						break;
					case 8:
						tMonth = @"Aug";
						break;
					case 9:
						tMonth = @"Sep";
						break;
					case 10:
						tMonth = @"Oct";
						break;
					case 11:
						tMonth = @"Nov";
						break;
					case 12:
						tMonth = @"Dec";
						break;
					default:
						break;
				}
				tPrint = [NSString stringWithFormat:@"%d",[[t substringWithRange:dayRange] intValue]];
			}else {
				tPrint = t;
			}

			textPoint.x = xPad + ((CGFloat)i + 0.7f) * plotWidth;
			textMonthPoint.x = xPad + ((CGFloat)i + 0.7f) *plotWidth + (fontSize * 0.2f);
			//if ([tPrint isEqualToString:@"1"]||[tPrint isEqualToString:@"7"]||[tPrint isEqualToString:@"14"]||[tPrint isEqualToString:@"21"]||[tPrint isEqualToString:@"28"]) {
			if (i != (maxPoints - 1)) {
				t = [self getSeriesValueLabel:i + 1];
			}
			if (i == 0 && [tPrint intValue] < 25) {
				[[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f] set];
				[tMonth drawAtPoint:CGPointMake(textMonthPoint.x, textMonthPoint.y + 1.0f) withFont:fM];
				[[UIColor colorWithRed:0.0f green:0.75f blue:1.0f alpha:1.0f] set];
				[tMonth drawAtPoint:textMonthPoint withFont:fM];
			}
			if (i == (maxPoints - 1) || [[t substringWithRange:dayRange] isEqualToString:@"01"]) {
				[[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f] set];
				[tMonth drawAtPoint:CGPointMake(textMonthPoint.x - (fontSize * 1.3f), textMonthPoint.y + 1.0f) withFont:fM];
				[[UIColor colorWithRed:0.0f green:0.75f blue:1.0f alpha:1.0f] set];
				[tMonth drawAtPoint:CGPointMake(textMonthPoint.x - (fontSize * 1.3f), textMonthPoint.y) withFont:fM];
			}
			if ([tPrint isEqualToString:@"1"]) {
				[[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f] set];
				[tMonth drawAtPoint:CGPointMake(textMonthPoint.x, textMonthPoint.y + 1.0f) withFont:fM];
				[[UIColor colorWithRed:0.0f green:0.75f blue:1.0f alpha:1.0f] set];
				[tMonth drawAtPoint:textMonthPoint withFont:fM];
			}
			CGContextSaveGState(c);
			CGContextTranslateCTM(c, textPoint.x, textPoint.y);
//			CGAffineTransform textTransform = CGAffineTransformMakeRotation(-1.57);
			CGAffineTransform textTransform = CGAffineTransformMakeRotation(-1.57f * 0.5f);
			CGContextConcatCTM(c, textTransform);
			CGContextTranslateCTM(c, -textPoint.x, -textPoint.y);
			
			[[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f] set];
			[tPrint drawAtPoint:CGPointMake(textPoint.x -1.0f, textPoint.y + 1.0f) withFont:f];
			if (bWeekend) {
				//[[UIColor cyanColor] set];
				[[UIColor colorWithRed:0.0f green:1.0f blue:1.0f alpha:1.0f] set];
			}else {
				[[UIColor colorWithRed:0.0f green:0.40f blue:1.0f alpha:1.0f] set];
			}
			[tPrint drawAtPoint:textPoint withFont:f];
			CGContextRestoreGState(c);
		}
	}
}

- (void)dealloc {
    [super dealloc];
}

- (int)getNumberOfSeries {
	NSDictionary *d = [data objectAtIndex:0];
	NSArray *a = [d objectForKey:@"seriesPoints"];
	return [a count];
}
//	CGFloat graphLineColors[4][4] = {0.5f, 1.0f, 0.5f, 1.0f, 1.0f, 1.0f, 0.5f, 1.0f, 0.5f, 1.0f, 1.0f, 1.0f, 1.0f, 0.5f, 1.0f, 1.0f};

- (CGFloat)getSeriesValue:(int)x andY:(int)y {
	NSDictionary *d = [data objectAtIndex:x];
	NSArray *a = [d objectForKey:@"seriesPoints"];
	NSString *t = (NSString *)[a objectAtIndex:y];
	CGFloat v = [t floatValue];
	return v;
}
- (NSString *)getSeriesValueLabel:(int)x {
	NSString *t = @"";
	if(x < [data count]) {
		NSDictionary *d = [data objectAtIndex:x];
		t = [d objectForKey:@"label"];
	}
	return t;
}
- (BOOL)isSeriesValue:(int)x andY:(int)y {
	NSDictionary *d = [data objectAtIndex:x];
	NSArray *a = [d objectForKey:@"seriesPoints"];
	NSString *t = (NSString *)[a objectAtIndex:y];
	return ![t isEqualToString:@""];
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
	UIColor *c = [[UIColor alloc] initWithRed:[[dict valueForKey:@"red"] floatValue] green:[[dict valueForKey:@"green"] floatValue] blue:[[dict valueForKey:@"blue"] floatValue] alpha:[[dict valueForKey:@"alpha"] floatValue]];
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
