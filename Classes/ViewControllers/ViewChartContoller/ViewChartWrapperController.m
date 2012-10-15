//
//  ViewChartWrapperController.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/27/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//
/*
 *
 * Breathe2Relax
 *
 * Copyright © 2009-2012 United States Government as represented by
 * the Chief Information Officer of the National Center for Telehealth
 * and Technology. All Rights Reserved.
 *
 * Copyright © 2009-2012 Contributors. All Rights Reserved.
 *
 * THIS OPEN SOURCE AGREEMENT ("AGREEMENT") DEFINES THE RIGHTS OF USE,
 * REPRODUCTION, DISTRIBUTION, MODIFICATION AND REDISTRIBUTION OF CERTAIN
 * COMPUTER SOFTWARE ORIGINALLY RELEASED BY THE UNITED STATES GOVERNMENT
 * AS REPRESENTED BY THE GOVERNMENT AGENCY LISTED BELOW ("GOVERNMENT AGENCY").
 * THE UNITED STATES GOVERNMENT, AS REPRESENTED BY GOVERNMENT AGENCY, IS AN
 * INTENDED THIRD-PARTY BENEFICIARY OF ALL SUBSEQUENT DISTRIBUTIONS OR
 * REDISTRIBUTIONS OF THE SUBJECT SOFTWARE. ANYONE WHO USES, REPRODUCES,
 * DISTRIBUTES, MODIFIES OR REDISTRIBUTES THE SUBJECT SOFTWARE, AS DEFINED
 * HEREIN, OR ANY PART THEREOF, IS, BY THAT ACTION, ACCEPTING IN FULL THE
 * RESPONSIBILITIES AND OBLIGATIONS CONTAINED IN THIS AGREEMENT.
 *
 * Government Agency: The National Center for Telehealth and Technology
 * Government Agency Original Software Designation: Breathe2Relax001
 * Government Agency Original Software Title: Breathe2Relax
 * User Registration Requested. Please send email
 * with your contact information to: robert.kayl2@us.army.mil
 * Government Agency Point of Contact for Original Software: robert.kayl2@us.army.mil
 *
 */
#import "ViewChartWrapperController.h"
#import "B2RAppDelegate.h"


@implementation ViewChartWrapperController

@synthesize seriesToRender, firstDate, previousDate;
@synthesize numberOfCharts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self fadeOutView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self updateLayout:self.view.frame];
    if (helpTips) {
        [helpTips updateLayout:self.view.frame];
    }
    [self fadeInView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
	timeInterval = 	1.0f/20.0f;
	timer = nil;
	
	CGRect rect = [[UIScreen mainScreen] bounds];
    
	UIView *v = [[UIView alloc] initWithFrame:rect];
	v.backgroundColor = [UIColor clearColor];
	self.view = v;
	[self initDisplay];
	[v release];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    self.view.alpha = 0.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.firstTime showGuideForPosition:enAppPositionResults]) {
		helpTips = [appDelegate showInfo:[appDelegate.firstTime getGuideTitleForPosition:enAppPositionResults] 
                     withInfo:[appDelegate.firstTime getGuideDetailForPosition:enAppPositionResults] 
                containerView:self.view appPosition:enAppPositionResults];
    }
    [self fadeInView];
}

- (void)initDisplay {
	CGFloat maxWidth = 3000.0f;
	CGRect r = self.view.frame;
	UIScrollView *sv = [[UIScrollView alloc] initWithFrame:r];
	[self.view addSubview:sv];
	svChart = sv;
	[sv release];
	
	xPad = 0.0f;
	yPad = 10.0f;
	
	CGFloat x,y,w,h;
	h = ((r.size.height - yPad) * 0.55f) / numberOfCharts;
	
	
	NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setDateFormat:@"yyyy-MM-dd"];
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.firstDate = [appDelegate.datalayer getFirstSessionDate];
	if (self.firstDate == nil) {
		self.firstDate = [NSDate date];
	}
	self.firstDate = [df dateFromString:[df stringFromDate:self.firstDate]];
	self.firstDate = [self.firstDate dateByAddingTimeInterval:-(DAYINSEC)];
	
	self.previousDate = [NSDate date];
	self.previousDate = [df dateFromString:[df stringFromDate:self.previousDate]];
	self.previousDate = [self.previousDate dateByAddingTimeInterval:(DAYINSEC)*2];
 	NSTimeInterval interval = [self.firstDate timeIntervalSinceDate:self.previousDate];
	int max =  (int)(-interval / (DAYINSEC));
	if (max < 14) {
		self.firstDate = [self.firstDate dateByAddingTimeInterval:-(DAYINSEC) * (14 - max)];
		interval = [self.firstDate timeIntervalSinceDate:self.previousDate];
		max =  (int)(-interval / (DAYINSEC));
	}
	NSDate *lastEntry = [appDelegate.datalayer getLastSessionDate];
	lastEntry = [df dateFromString:[df stringFromDate:lastEntry]];
	currentPoint = max - (int)([self.previousDate timeIntervalSinceDate:lastEntry] / (DAYINSEC)) ;
	self.previousDate = lastEntry;
	maxPoints = max;
	w = max * 40.0f;
	if (w > maxWidth) {
		w = maxWidth;
	}
	
	plotWidth = (w - (2.0f * xPad))/(CGFloat)(max - 1);
	
	UIGraphicsBeginImageContext(CGSizeMake(plotWidth * 7.0f + 1.0f, h));
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIGraphicsPushContext(context);
	
	//Draw here
	
	//  Gradient Background...
	CGGradientRef myGradient;
	CGColorSpaceRef myColorSpace;
	size_t num_locations = 2;
	CGFloat locations[2] = {0.0f, 1.0f};
	CGFloat components[8] = {
		0.0f, 0.0f, 0.0f, 0.5f, // Start color
		0.01f, 0.1f, 0.95f, 0.5f	// End color
	};
	
	myColorSpace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, num_locations);
	CGFloat yUnit = h / 100.0f;
	
	//apply gradient on vertical axis
	CGPoint myStartPoint = CGPointMake(w/2.0f, h * 0.25f);
	CGPoint myEndPoint = CGPointMake(w/2.0f, h);
	//draw gradient into context
	CGContextDrawLinearGradient(context, myGradient, myStartPoint, myEndPoint, 0);
	CGGradientRelease(myGradient);
	CGColorSpaceRelease(myColorSpace);
	
	// Horizontal lines
	CGContextSetLineDash(context, 0.0f, nil, 0);
	CGContextSetLineWidth(context, 1.0f);
	//CGContextSetStrokeColor(context, graphLineColorRefX);
	CGContextSetRGBStrokeColor(context, 0.6f, 0.6f, 1.0f, 0.5f);
	for (int i = 1; i < 4; i++) {
		if (i % 4 == 0) {
			CGContextSetLineWidth(context, 5.0f);
		}
		else {
			CGContextSetLineWidth(context, 3.0f);
		}
		
		x = 0.0f;
		y = (CGFloat)i * (yUnit * 25.0f);
		CGContextMoveToPoint(context, x, y);
		x = plotWidth * 8.0f;
		CGContextAddLineToPoint(context, x, y);
		CGContextStrokePath(context);
	}
	
	// Draw Reference Grid
	// Vertical Lines
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	float pattern[2] = {1.0f, 15.0f}; // dots
	//float weekendPattern[2] = {1.0f, 7.0f}; //dashes
	//CGContextSetStrokeColor(context, graphLineColorRefY);
	for (int i=0; i < 7; i++) {
		//draw vertical lines
		x = ((CGFloat)i)*plotWidth + (plotWidth * 0.5f);
		y = 0.0f;
		
		if (i == 0 || i == 6) {
			//CGContextSetLineDash(context, 0.0f, weekendPattern, 2);
			CGContextSetLineDash(context, 0.0f, nil, 0);
			CGContextSetLineWidth(context, 3.0f);
			CGContextSetRGBStrokeColor(context, 0.6f, 0.6f, 1.0f, 0.5f);
			CGContextMoveToPoint(context, x, y);
			y = h;
			CGContextAddLineToPoint(context, x, y);
			CGContextStrokePath(context);
		}else {
			//CGContextSetLineDash(context, 0.0f, pattern, 2);  //normally vertical dots
			CGContextSetLineDash(context, 0.0f, nil, 0);
			CGContextSetLineWidth(context, 1.0f);
			CGContextSetRGBStrokeColor(context, 0.6f, 0.6f, 1.0f, 0.2f);
			CGContextMoveToPoint(context, x, y);
			y = h;
			CGContextAddLineToPoint(context, x, y);
			CGContextStrokePath(context);
		}
		//		}
	}
	pattern[0] = 10.0f;
	pattern[1] = 10.0f;
	
	
	
	
	
	
	UIGraphicsPopContext();
	iBackground = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	//Chart Labels...
	CGFloat lblHeight = h * 0.15f;
	CGSize lblShadowOffset = CGSizeMake(1.0f, 1.0f);
	NSString *lblText;
	NSMutableArray *msSeriesToRender = [[NSMutableArray alloc] init];
	for(int tempValue=0;tempValue<=7;tempValue++){
		NSNumber *tempNumber = [[NSNumber alloc] initWithInt:tempValue];
		[msSeriesToRender addObject:tempNumber];
	}
	self.seriesToRender = [NSArray arrayWithArray:msSeriesToRender];
    [msSeriesToRender release];
	sessionID = [appDelegate.datalayer getMaxSessionID];
	dataPoint =[appDelegate.datalayer getDataForSession:sessionID];
	sessionID--;
	x = 0.0f;
	
	for (int i = 0; i < numberOfCharts; i++) {
		y = i * h;
		ViewChartBack *vcb = [[[ViewChartBack alloc] retain]
							  initWithFrame:CGRectMake(x + xPad, y + yPad, w - (2.0f * xPad), h  - yPad)]; 
		vcb.backgroundImage = iBackground;
		vcb.plotWidth = plotWidth;
		vcb.firstDate = self.firstDate;
		vcb.maxPoints = max;
		
		[svChart addSubview:vcb];
		vbChart[i] = vcb;
		[vcb release];
		
		ViewChart *vc = [[[ViewChart alloc] retain] 
						 initWithFrame:CGRectMake(x + xPad, y + yPad, w - (2.0f * xPad), h  - yPad) 
						 andData:appDelegate.datalayer 
						 andUseThisSeries:(i * 2)
						 andNumberOfSeries:2];
		vc.backgroundColor = [UIColor clearColor];
		vc.oldDataPoint = dataPoint;
		[svChart addSubview:vc];
		vChart[i] = vc;
		vChart[i].clearsContextBeforeDrawing = YES;
		[vc release];
		
		
		for (int j=0; j<2; j++) {  // top and bottom label
			switch (i) {
				case 0:
					lblText = [NSString stringWithFormat:j ? @"Relaxed" : @"Stressed"];
					break;
				case 1:
					lblText = [NSString stringWithFormat:j ? @"Calm" : @"Pressured"];
					break;
				case 2:
					lblText = [NSString stringWithFormat:j ? @"Content" : @"Angry"];
					break;
				case 3:
					lblText = [NSString stringWithFormat:j ? @"Focused" : @"Distracted"];
					break;
				default:
					break;
			}
			CGRect r = CGRectMake(xPad, 
								  y + yPad + (CGFloat)j * (h - lblHeight - yPad), 
								  sv.frame.size.width * 0.45f, 
								  lblHeight);
			UILabel *lbl = [[UILabel alloc] initWithFrame:r];
			UIFont *font = [UIFont fontWithName:@"Helvetica" size:lblHeight/1.5f];
			lbl.font = font;
			[lbl setTextAlignment: UITextAlignmentLeft];
			lbl.text = lblText;
			[lbl setTextColor:[vChart[i] seriesUIColor:i * 2]];
			[lbl setShadowColor:[UIColor blackColor]];
			[lbl setShadowOffset:lblShadowOffset];
			[lbl setBackgroundColor:[UIColor clearColor]];
			[lbl setAlpha:1.0f];
			[svChart addSubview:lbl];
			pChartLabelOffsets[i][j] = [lbl center];
			lChartLabels[i][j] = lbl;
		}
		if (i == numberOfCharts - 1) {
			CGFloat fontSize = plotWidth * 0.8f;
			if (fontSize > lblHeight * 0.5f) {
				fontSize = lblHeight * 0.5f;
			}
			CGFloat xRef = fontSize * 1.3f;
			int bubbles;
			bubbles = 5 ;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                bubbles = 15;
            }
			ViewBubbleBar *vbb = [[[ViewBubbleBar alloc] retain] initWithFrame:CGRectMake((r.size.width - plotWidth * (CGFloat)(bubbles - 1)) * 0.5f,sv.frame.size.height  - xRef - yPad,plotWidth * (CGFloat)(bubbles - 1),xRef) 
																  andStartDate:[df stringFromDate:firstDate]
																  andMaxPoints:maxPoints
															 andNumberOfLabels:bubbles];
			vbb.backgroundColor = [UIColor clearColor];
			vbb.clipsToBounds = NO;
			[svChart addSubview:vbb];
			pXChartOffset = [vbb center];
			vbbXBar = vbb;
			[vbb release];
		}
		
	}
	
	ViewVertBar *vvb = [[ViewVertBar alloc] 
						initWithFrame:CGRectMake(svChart.frame.size.width * 0.5 - 10.0f, 0.0f, 20.0f, svChart.frame.size.height)
						withBarColor:[UIColor colorWithRed: 0.0f green: 1.0f blue: 1.0f alpha: 1.0f]];
	vvb.backgroundColor = [UIColor	clearColor];
	
	[svChart insertSubview: vvb 
			  belowSubview: vbbXBar];
	vvbVertBar = vvb;
	[vvb release];
	
	CGSize sz = CGSizeMake(w, h * numberOfCharts);
	[svChart setContentSize:sz];
	UIEdgeInsets inset;
	inset.bottom = 0.0f;
	inset.top = 14.0f;
	inset.left = svChart.frame.size.width/2.0f - 10.0f;
	inset.right = svChart.frame.size.width/2.0f - 10.0f;
	[svChart setContentInset: inset];
	svChart.maximumZoomScale = 1.0f;
	svChart.minimumZoomScale = 1.0f;
	svChart.clipsToBounds = YES;
	svChart.delegate = self;
	//sessionID--;
	
	UIView *v = [[[UIView alloc] retain] initWithFrame: CGRectMake(r.size.width - 240.0f + 28.0f,r.size.height/2.0f - (292.0f/2.0f), 240.0f, 292.0f)];
	v.backgroundColor = [UIColor clearColor];
	v.alpha = 1.0f;
	UIButton *addB =[[UIButton buttonWithType: UIButtonTypeCustom] retain];
    UIImage *imgLegend = [UIImage imageNamed:[NSString stringWithFormat: @"legendP.png"]];
    CGFloat imgAspect = [appDelegate getImageAspect: imgLegend];
    CGFloat bWidth = 212.0f;
    CGRect legendFrame = CGRectMake(0.0f, 0.0f, bWidth, bWidth * imgAspect);
	[addB setFrame: legendFrame];
	[addB setBackgroundImage: imgLegend  forState: UIControlStateNormal];
	[addB setBackgroundImage: imgLegend  forState: UIControlStateSelected];
	[addB setBackgroundImage: imgLegend  forState: UIControlStateHighlighted];
	addB.tag = 1;
	[addB addTarget: self 
			 action: @selector(legendButton_TouchDown:) 
   forControlEvents: UIControlEventTouchDown];
	[v addSubview: addB];
	[self.view addSubview: v];
	vLegend = v;
	bLegend = addB;
	[addB release];
	[v release];
}

- (void) legendButton_TouchDown:(id)sender{
    CGFloat legendTabOffset = 50.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        legendTabOffset = legendTabOffset * 2.0f;
    }
    
	UIButton *button = (UIButton *)sender;
	button.userInteractionEnabled = NO;
	if (button.tag == 1) {
		button.tag = 0;
		[UIView beginAnimations:@"legendButton_TouchDown" context:nil];
		[UIView setAnimationDuration:1.0f];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector: @selector(animationHasFinished:finished:context:)];
		[vLegend setCenter:CGPointMake(self.view.frame.size.width + vLegend.frame.size.width/2.0f - legendTabOffset, [vLegend center].y)];
		[UIView commitAnimations];
	}
	else {
		button.tag = 1;
		[UIView beginAnimations:@"legendButton_TouchDown" context:nil];
		[UIView setAnimationDuration:1.0f];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
		[vLegend setCenter:CGPointMake(self.view.frame.size.width - vLegend.frame.size.width/2.0f, [vLegend center].y)];
		[UIView commitAnimations];
	}
	
	//Show info about what button is touched
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	//svChart.delegate = nil;
    /*
     for (int i = 0; i < numberOfCharts; i++) {
     [vChart[i] release];
     [vbChart[i] release];
     }
     */
    [super viewDidUnload];
}


- (void)dealloc {
	//svChart.delegate = nil;
    //[self.seriesToRender release];
    //[self.previousDate release];
    //[self.firstDate release];
	if (timer != nil) {
		[timer invalidate];
		timer = nil;
	}
    [super dealloc];
}

- (void)updateLayout:(CGRect)frame {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	[self.view setFrame:frame];
	[svChart setFrame:frame];
	[vvbVertBar setFrame:CGRectMake(svChart.frame.size.width * 0.5 - vvbVertBar.frame.size.width * 0.5f, 0.0f, vvbVertBar.frame.size.width, svChart.frame.size.height)];
	pVertBarOffset = vvbVertBar.center;
	pXChartOffset = CGPointMake(vbbXBar.center.x, frame.size.height - (vbbXBar.frame.size.height * 0.50f));
	vbbXBar.center = pXChartOffset;
	UIEdgeInsets inset;
	inset.bottom = 0.0f;// vbbXBar.frame.size.height;
	inset.top = 14.0f;
	inset.left = frame.size.width/2.0f;
	inset.right = frame.size.width/2.0f;
	[svChart setContentInset:inset];
	CGPoint hpPoint = CGPointMake(svChart.contentSize.width - frame.size.width/2.0f - 10.0f, -14.0f);
	svChart.contentOffset = hpPoint;
	bLegend.tag = 1;
    
    UIImage *imgLegend = [UIImage imageNamed:[NSString stringWithFormat: @"legendL.png"]];
    CGFloat imgAspect = [appDelegate getImageAspect: imgLegend];
    
	CGFloat x,y,w,h;
	if (frame.size.width > frame.size.height) {//landscape
        h = frame.size.height;
        w = h / imgAspect;
        x = frame.size.width - w;
    } else {
        w = frame.size.width;
        h = w * imgAspect;
        x = frame.size.width - w;
    }
    y = 0.0f;
    
	[bLegend setBackgroundImage: imgLegend  forState: UIControlStateNormal];
	[bLegend setBackgroundImage: imgLegend  forState: UIControlStateSelected];
	[bLegend setBackgroundImage: imgLegend  forState: UIControlStateHighlighted];
	[vLegend setFrame: CGRectMake(x, y, w, h)];
	[bLegend setFrame: CGRectMake(0.0f, 0.0f, w, h)];
}

- (void)startGraphing{
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (sessionID == 0) {
		//just one point.	
		NSArray *newPoint = [appDelegate.datalayer getDataForSession:1];
		for (int i = 0; i < numberOfCharts; i++) {
			vChart[i].dataPoint = newPoint;
			CGRect r = CGRectMake((CGFloat)(currentPoint) * plotWidth - 3.0f, 
								  0.0f, 
								  7.0f, 
								  vChart[i].frame.size.height);
			[vChart[i] setNeedsDisplayInRect:r];
		}
	} else {
		timer =	[NSTimer scheduledTimerWithTimeInterval:timeInterval
												 target:self
											   selector:@selector(updateGraph:)
											   userInfo:nil
												repeats:YES];
	}
    
}

- (void)showGuide {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.firstTime showGuideForPosition:enAppPositionResults]) {
		[appDelegate showInfo:[appDelegate.firstTime getGuideTitleForPosition:enAppPositionResults] 
                     withInfo:[appDelegate.firstTime getGuideDetailForPosition:enAppPositionResults] 
                containerView:self.view appPosition:enAppPositionResults];
    }
    
}

#pragma mark -
#pragma mark Chart and Note Rendering
-(void)updateGraph:(NSTimer *)theTimer {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSArray *newPoint = [appDelegate.datalayer getDataForSession:sessionID];
	NSDate *date;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	if (sessionID < 1) {
		[timer invalidate];
		timer = nil;
	} else {
		[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        if ([newPoint count]==0) {
            [df release];
            return;
        }
		NSMutableDictionary *record = (NSMutableDictionary *)[newPoint objectAtIndex:0];
		NSString *tDay = (NSString *)[record valueForKey:@"firstTimestamp"];
		date = [df dateFromString:tDay];
		CGFloat interval = ((NSTimeInterval)[self.previousDate timeIntervalSinceDate:date])/DAYINSEC;
		currentPoint = currentPoint - round(interval);
		for (int i = 0; i < numberOfCharts; i++) {
			vChart[i].dataPoint = newPoint;
			CGRect r = CGRectMake(((CGFloat)currentPoint) * plotWidth, 
								  0.0f, 
								  plotWidth * interval, 
								  vChart[i].frame.size.height);
			[vChart[i] setNeedsDisplayInRect:r];
		}
		self.previousDate = date;
		sessionID--;
		
	}
	[df release];
}

#pragma mark -
#pragma mark Controller Animation Cycle
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if ((animationID == @"fadeOutTrackView")/* && finished*/) {  
	}
	if ((animationID == @"fadeInTrackView")/* && finished*/) {
        [self startGraphing];
        [self showGuide];
        [self legendButton_TouchDown:bLegend];
	}
	if ((animationID == @"legendButton_TouchDown")/* && finished*/) {
		bLegend.userInteractionEnabled = YES;
	}
}	

- (void)fadeOutView {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutView" context:nil];
	[UIView setAnimationDuration:0.25f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)fadeInView {		//Animate Fade In
    [self updateLayout:self.view.frame];
	[UIView beginAnimations:@"fadeInTrackView" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 1.0f;
	[UIView commitAnimations];
}

- (void)animShowView {		//Animate Fade Out
	[UIView beginAnimations:@"animShowView" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 1.0f;
	[UIView commitAnimations];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGPoint p = scrollView.contentOffset;
	CGPoint tp = scrollView.contentOffset;
	CGFloat w = scrollView.frame.size.width;
	CGFloat xCenter = (w * 0.5f) + tp.x;
	
	
	for (int i = 0; i < numberOfCharts; i++) {
		for (int j = 0; j < 2; j++) {
			tp.x = pChartLabelOffsets[i][j].x + p.x;
			tp.y = [lChartLabels[i][j] center].y;
			[lChartLabels[i][j] setCenter:tp];
		}
	}
	CGFloat xDelta = 0.0f;
	CGPoint centerFocus = CGPointMake(xCenter, p.y + pVertBarOffset.y);
	int i = 0;
	for (i  = 0; i < maxPoints ; i++) {
		xDelta = (CGFloat)i * plotWidth - centerFocus.x;
		if ( fabs(xDelta) < (plotWidth * 0.5) ) {
			break;
		}
	}
	vbbXBar.center = CGPointMake(centerFocus.x + xDelta, p.y + pXChartOffset.y);
	[vbbXBar updateBubble:xDelta withWhichBar:i];
	[self updateBar:centerFocus withOffset:xDelta withWhichBar:i];
}

- (void)updateBar:(CGPoint)centerFocus withOffset:(CGFloat)offset withWhichBar:(int)whichBar {
	CGFloat newAlpha; 
	CGFloat minAlpha = 0.5f;
	
	if (fabs(offset) < plotWidth * 0.25f) {
		newAlpha = 1.0f - (fabs(offset)/(plotWidth * 0.25f) * (1.0f - minAlpha));
	}else {
		newAlpha = minAlpha;
	}
	
	vvbVertBar.alpha = newAlpha;
	[vvbVertBar setCenter:CGPointMake(centerFocus.x + offset, centerFocus.y)];
}


@end
