//
//  ViewXLabel.m
//  iBreathe130
//
//  Created by Roger Reeder on 9/1/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewXLabel.h"
#import "Analytics.h"

@implementation ViewXLabel
@synthesize titleText, dayText, monthText, yearText;


- (id)initWithFrame:(CGRect)frame
		   andTitle:(NSString *)title
			 andDay:(NSString *)day
		   andMonth:(NSString *)month
			andYear:(NSString *)year {
	
    if ((self = [super initWithFrame:frame])) {
        // Initialization code

		CGFloat fontSize = frame.size.width * 0.8f;
		if (fontSize > frame.size.height / 1.3f) {
			fontSize = frame.size.height / 1.3f;
		}
		CGSize lblShadowOffset = CGSizeMake(1.0f, 1.0f);
		fTitle = [UIFont fontWithName:@"Helvetica" size:fontSize];
		fSub = [UIFont fontWithName:@"Helvetica" size:fontSize * 0.5f];
		
/*
		titleText = [NSString stringWithFormat:@"%@",title];
		dayText = [NSString stringWithFormat:@"%@",day];
		monthText = [NSString stringWithFormat:@"%@",month];
*/
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
		[iv setImage:[UIImage imageNamed:@"shadowbox.png"]];
		iv.alpha = 0.5f;
		[self addSubview:iv];
		ivBackground = iv;
		[iv release];
		
		//  Day of the Week
		UILabel *lbl = [[UILabel new] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
		lbl.font = [fTitle fontWithSize:fontSize * 0.6f];
		[lbl setTextAlignment: UITextAlignmentCenter];
		lbl.text = day;
		[lbl setTextColor:[UIColor whiteColor]];
		[lbl setShadowColor:[UIColor blackColor]];
		[lbl setShadowOffset:lblShadowOffset];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setAlpha:0.0f];
		[self addSubview:lbl];
		dayText = lbl;
		[lbl release];
		
		//  Month
		lbl = [[UILabel new] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
		lbl.font = [fTitle fontWithSize:fontSize * 0.6f];
		[lbl setTextAlignment: UITextAlignmentCenter];
		lbl.text = month;
		[lbl setTextColor:[UIColor whiteColor]];
		[lbl setShadowColor:[UIColor blackColor]];
		[lbl setShadowOffset:lblShadowOffset];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setAlpha:0.0f];
		[self addSubview:lbl];
		monthText = lbl;
		[lbl release];

		//  Year
		lbl = [[UILabel new] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
		lbl.font = [fTitle fontWithSize:fontSize * 0.5f];
		[lbl setTextAlignment: UITextAlignmentCenter];
		lbl.text = year;
		[lbl setTextColor:[UIColor whiteColor]];
		[lbl setShadowColor:[UIColor blackColor]];
		[lbl setShadowOffset:lblShadowOffset];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setAlpha:0.0f];
		[self addSubview:lbl];
		yearText = lbl;
		[lbl release];

		//  Calendar Day
		lbl = [[UILabel new] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
		lbl.font = fTitle;
		[lbl setTextAlignment: UITextAlignmentCenter];
		lbl.text = title;
		[lbl setTextColor:[UIColor whiteColor]];
		[lbl setShadowColor:[UIColor blackColor]];
		[lbl setShadowOffset:lblShadowOffset];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setAlpha:1.0f];
		[self addSubview:lbl];
		titleText = lbl;
		[lbl release];
		
		
	}
    return self;
}

- (void)dealloc {
    [super dealloc];
}

-(int)getSubviewIndex {
	return [self.superview.subviews indexOfObject:self];
}

-(void)bringToFront {
	[self.superview bringSubviewToFront:self];
}
-(void)sendToBack {
	[self.superview sendSubviewToBack:self];
}

-(void)bringOneLevelUp {
	int currentIndex = [self getSubviewIndex];
	[self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex+1];
}
-(void)sendOneLevelDown {
	int currentIndex = [self getSubviewIndex];
	[self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex-1];
}

-(BOOL)isInFront {
	return ([self.superview.subviews lastObject]==self);
}
-(BOOL)isAtBack {
	return ([self.superview.subviews objectAtIndex:0]==self);
}


-(void)swapDepthsWithView:(ViewXLabel*)swapView {
	[self.superview exchangeSubviewAtIndex:[self getSubviewIndex] withSubviewAtIndex:[swapView getSubviewIndex]];
}

- (void)scaleLabel:(UIView *)v andCenter:(CGPoint)newCenter andAlpha:(CGFloat)newAlpha {
	CGRect r = self.frame;
	CGFloat aspect = r.size.width / r.size.height;
	CGFloat x,y,w,h;
	CGFloat otherAlpha =  newAlpha - 0.5f;
	if (otherAlpha < 0.0f) {
		otherAlpha = 0.0f;
	}
	otherAlpha = otherAlpha * 2.0f;
	h = (v.frame.size.height - newCenter.y) * 2.0f;
	w = h * aspect;
	x = newCenter.x - w * 0.5f;
	y = newCenter.y - h * 0.5f;
	CGFloat bubbleYRange = v.frame.size.height * 0.5f;

	[self setFrame:CGRectMake(x, y, w, h)];
	//Change Label Frame.
	@try {
		[titleText setFrame:CGRectMake(0.0f, 0.0f, w, h)];
		[dayText setFrame:CGRectMake(0.0f, 0.0f, w, h * 0.5f)];
		[monthText setFrame:CGRectMake(0.0f, 0.0f, w, h * 0.5f)];
		[yearText setFrame:CGRectMake(0.0f, h * 0.5f, w, h * 0.5f)];
		if (newCenter.y >= bubbleYRange) {
			//v.hidden = YES;
			[titleText setTextColor:[UIColor colorWithRed:0.0f green:0.75f blue:1.0f alpha:1.0f]];
			[titleText setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f]];
			[titleText setFont:fTitle];
			[dayText setFont:fSub];
			[monthText setFont:fSub];
			[yearText setFont:fSub];
		}else {
			//v.hidden = NO;
			UIFont *f = [titleText.font fontWithSize:h * 0.7f];
			UIFont *fSubs = [titleText.font fontWithSize:h * 0.25f];
			[titleText setTextColor:[UIColor colorWithRed:0.0f green:0.95f blue:1.0f alpha:1.0f]];
			[titleText setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f]];
			[titleText setFont:f];
			[dayText setFont:fSubs];
			[monthText setFont:fSubs];
			[yearText setFont:fSubs];
		}
		titleText.alpha = newAlpha;
		dayText.alpha = otherAlpha;
		monthText.alpha = otherAlpha;
		yearText.alpha = otherAlpha;
		ivBackground.alpha = otherAlpha * 0.5f;
		[dayText setCenter:CGPointMake(0.0f, dayText.frame.size.height * 0.5f)];
		[monthText setCenter:CGPointMake(w, monthText.frame.size.height * 0.5f)];
		[yearText setCenter:CGPointMake(w * 0.5f, h - (yearText.frame.size.height * 0.25f))];
		[ivBackground setFrame:CGRectMake(0.0f - (dayText.frame.size.width / 2.0f), 0.0f - (dayText.frame.size.height * 0.5f), w + monthText.frame.size.width, h + (yearText.frame.size.height * 0.75f))];
	}
	@catch (NSException * e) {
		[Analytics logError:[e name] message:[e reason] exception:(NSException *)e];
	}
}


@end
