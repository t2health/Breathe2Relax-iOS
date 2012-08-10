    //
//  viewReaderController.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 7/4/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewReaderController.h"
#import "Analytics.h"

@implementation ViewReaderController
@synthesize wvReader;
@synthesize timer;
@synthesize pixelsPerFrame;
@synthesize animationInterval;


#pragma mark -
#pragma mark Controller Life Cycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	pixelsPerFrame = 1.0f;
	animationInterval = 1.0f/30.0f;
	CGRect rect = [[UIScreen mainScreen] bounds];
	UIView *v = [[UIView alloc] initWithFrame:rect];
	v.backgroundColor = [UIColor blackColor];
	self.view = v;
	[self initDisplay];
	[v release];
	[super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
	
- (void)initDisplay {
	/***********************************
	 Initial Learn Content Scroller.... 
	 ***********************************/
	CGFloat shaderHeight = 60.0f;
	CGRect frame = self.view.frame;
	UIScrollView *sv = [[UIScrollView alloc] initWithFrame:frame];
	[sv setContentSize:CGSizeMake(self.view.frame.size.width, 2700.0f)];
	sv.delegate = self;
	sv.backgroundColor = [UIColor clearColor];
	
	svReader = sv;
	[self.view addSubview:svReader];
	[sv release];
	
	UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, svReader.contentSize.width, svReader.contentSize.height)];
	[web setBackgroundColor:[UIColor clearColor]];
	[web setOpaque:NO];
	wvReader = web;
	wvReader.delegate = self;
	[svReader addSubview:wvReader];
	
	UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, shaderHeight)];
	[iv setImage:[UIImage imageNamed:@"blacktopfade.png"]];
	[self.view addSubview:iv];
	ivTopFader = iv;
	[iv release];
	
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - shaderHeight, frame.size.width, shaderHeight)];
	[iv setImage:[UIImage imageNamed:@"blackbottomfade.png"]];
	[self.view addSubview:iv];
	ivBottomFader = iv;
	[iv release];
	[web release];
	
	timer = nil;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	CGSize goodSize = [webView sizeThatFits:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
	if (svReader.frame.size.height >= goodSize.height) {
		[svReader setContentSize:CGSizeMake(goodSize.width, svReader.frame.size.height)];
		[webView setFrame:CGRectMake(0.0f, 0.0f, goodSize.width, svReader.frame.size.height)];
	} else {
		[svReader setContentSize:goodSize];
		[webView setFrame:CGRectMake(0.0f, 0.0f, goodSize.width, goodSize.height)];
	}
}

- (void)loadHTML:(NSString *)fileName{
    [Analytics logEvent:[NSString stringWithFormat:@"READER VIEW %@", fileName]];
	NSString *pdfPath2 = [[NSBundle mainBundle] pathForResource:fileName ofType:@"htm"];
	NSURL *pdfURL = [NSURL fileURLWithPath:pdfPath2];
	NSURLRequest *URLReq = [NSURLRequest requestWithURL:pdfURL];
	wvReader.alpha = 0.0f;
	[wvReader loadRequest:URLReq];
	wvReader.alpha = 1.0f;
}
		
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[timer invalidate];
	timer = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {

    [super dealloc];
}

- (void)updateLayout:(CGRect)frame {
	CGFloat shaderHeight = 60.0f;
	[self.view setFrame:frame];
	[wvReader setFrame:CGRectMake(1.0f, 1.0f, frame.size.width - 2.0f, frame.size.height - 2.0f)];
	[wvReader reload];
	[ivTopFader setFrame:CGRectMake(0.0f, 0.0f, frame.size.width, shaderHeight)];
	[ivBottomFader setFrame:CGRectMake(0.0f, frame.size.height - shaderHeight, frame.size.width, shaderHeight)];
	[svReader setFrame:frame];
	if (timer != nil) {
		[timer invalidate];
		[self startScrolling];
	}
	
}

#pragma mark -
#pragma mark Controller Animation Cycle
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if ((animationID == @"fadeOutReader")/* && finished*/) {  
		[timer invalidate];
	}
	if ((animationID == @"fadeInReader")/* && finished*/) {  
		[self startScrolling];
	}
}	

- (void)fadeOutReader {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutReader" context:nil];
	[UIView setAnimationDuration:0.25f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)fadeInReader {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInReader" context:nil];
	[UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 1.0f;
	[UIView commitAnimations];
}

- (void)animShowView {		//Animate Fade Out
	//CGRect r = self.view.frame;
	//[UIView beginAnimations:@"animShowView" context:nil];
	//[UIView setAnimationDuration:1.0f];
	//[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];

	//[UIView commitAnimations];
}

- (void)startScrolling{
	scrollCounter = 0;
	bScroll = NO;
	timer =	[NSTimer scheduledTimerWithTimeInterval:animationInterval
											 target:self
										   selector:@selector(scroll:)
										   userInfo:nil
											repeats:YES];
	
}

-(void)scroll:(NSTimer *)theTimer {
	scrollCounter++;
	CGPoint old = [svReader contentOffset];
	if ((CGFloat)scrollCounter * animationInterval > 5.0f) {  //However many seconds to wait before scrolling.
		bScroll = YES;
	}
	if (!bScroll) return;
	if (old.y + svReader.frame.size.height >= svReader.contentSize.height) {
		return;
	}
	[svReader setContentOffset:CGPointMake(0.0f, old.y + pixelsPerFrame) animated:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	scrollCounter = 0;
	if (bScroll) {
		bScroll = NO;
	}
}

@end
