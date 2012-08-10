//
//  ViewVideoController.m
//  BrightcoveTest
//
//  Created by Roger Reeder on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewVideoController.h"
#import "Analytics.h"

@implementation ViewVideoController
@synthesize moviePath;
@synthesize moviePlayer;
@synthesize movieDescription;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.moviePlayer = nil;
    }
    return self;
}

- (void)dealloc
{
	if (wvVideo) {
		//******************  STOP THE YOUTUBE PLAYER!!!!  *********************
		UIView *ytMovie  = [self findYTMovieViewInView:wvVideo];
		if (ytMovie) {
			[ytMovie removeFromSuperview];
		}
		[wvVideo removeFromSuperview];
	}
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.moviePath) {
        if (![self.moviePath hasPrefix:@"http://www.youtube.com"] && ![self.moviePath hasPrefix:@"http://youtu.be"])
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay 
                                                                                                    target:self 
                                                                                                    action:@selector(replay:)] autorelease];
    }
    
}


- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:[NSString stringWithFormat:@"MOVIE %@ VIEW", self.movieDescription]];
    if (self.moviePath) {
        [self playVideo:self.moviePath];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark -
#pragma mark Video Utilities
-(void)replay:(id)sender {
    if (self.moviePath) {
        [self playVideo:self.moviePath];
    }
}


-(void)playVideo:(NSString *)videoFileName {
	NSString *urlAddress;
	NSURL *url;
    BOOL simulated = NO;
#if TARGET_IPHONE_SIMULATOR
	simulated = YES;
#endif

	if ([videoFileName hasPrefix:@"http://www.youtube.com"] || [videoFileName hasPrefix:@"http://youtu.be"]) {
		if (simulated) {
			NSString* msg = @"Unable To Stream YouTube videos in Simulator.";
			
			UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"youtube video"
														 message:msg 
														delegate:self 
											   cancelButtonTitle:@"Ok" 
											   otherButtonTitles: nil];
			[av show];
			[av release];
		}else {
			self.view.alpha = 1.0f;
			UIWebView *web;
            
			CGRect frame = self.view.bounds;
			web = [[UIWebView alloc] initWithFrame:frame];
			[web setBackgroundColor:[UIColor blackColor]];
			[web setOpaque:YES];
			wvVideo = web;
			wvVideo.delegate = self;
			[self.view addSubview:wvVideo];
			[web release];
			
			activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			[activityIndicator setHidesWhenStopped:FALSE];
			[activityIndicator setCenter:[wvVideo center]];
			[self.view addSubview:activityIndicator];
			[activityIndicator startAnimating];
			
			NSString *html =@"<html>\
			<head>\
			<style type=\"text/css\">\
			body {\
			background-color:transparent;\
			color:white;\
			font-size:11pt;\
			font-family:helvetica;\
			padding:0px 0px 0px 0px;\
			margin:0px 0px 0px 0px;\
			background:#000000;\
			}\
			</style>\
			</head>\
			<body><div>%@</div></body></html>";
			html = [NSString stringWithFormat:html,[self embedYouTube:@"yt01" url:videoFileName frame:wvVideo.frame]];
			wvVideo.alpha = 0.0f;
			[wvVideo loadHTMLString:html baseURL:[NSURL URLWithString:@"http://youtube.com"]];
		}
	}
	else {
		if ([videoFileName hasPrefix:@"http://"] || [videoFileName hasPrefix:@"rtsp://"]) {
			urlAddress = [NSString stringWithFormat:@"%@", videoFileName];
			url = [NSURL URLWithString:urlAddress];
		}
		else {
			urlAddress = [[NSBundle mainBundle] pathForResource:videoFileName ofType:@"mp4"];
			url = [NSURL fileURLWithPath:urlAddress];
		}
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
		//If it has the view then it's the newer player and needs to have additional initialization.
		//player.movieControlMode = MPMovieControlModeDefault;
        player.controlStyle = MPMovieControlStyleDefault;
		if([player respondsToSelector:@selector(view)] == YES) {
			[player.view setFrame:self.view.bounds];
			[self.view addSubview:player.view];
			player.fullscreen = NO;
			player.controlStyle = MPMovieControlStyleDefault;
			
			[[NSNotificationCenter defaultCenter] addObserver:self 
													 selector:@selector(moviePlayerDidExitFullscreenNotification:) 
														 name:MPMoviePlayerDidExitFullscreenNotification 
													   object:player];
			
		}
		[[NSNotificationCenter defaultCenter] addObserver:self		 
												 selector:@selector(moviePlayerPlaybackDidFinishNotification:)	 
													 name:MPMoviePlayerPlaybackDidFinishNotification	
												   object:player];
        //  need to watch and see what kind of connection, don't let user just sit right here....
        [activityIndicator startAnimating];
		[player prepareToPlay];
		if (moviePlayer != nil) {
			[moviePlayer release];
		}
		moviePlayer = player;
	}
}

- (NSString *)embedYouTube:(NSString*)objectID url:(NSString*)url frame:(CGRect)frame {
	NSString *embedHTML = @"<embed class=\"video\" id=\"%@\" \
	src=\"%@\" \
	type=\"application/x-shockwave-flash\" \
	width=\"%0.0f\" \
	height=\"%0.0f\"></embed>";
	NSString *html = [NSString stringWithFormat:embedHTML, objectID, url, frame.size.width, frame.size.height];
	return html;
	
}


-(void)moviePlayerPlaybackDidFinishNotification:(NSNotification*) aNotification {
	MPMoviePlayerController *player = [aNotification object];
	//If it's the newer player with it's own view then we need to remove it from our controller's view.
	if ([player respondsToSelector:@selector(view)] == YES) {
		if (player.view.hidden != YES) {
			player.view.hidden = YES;
			[player.view removeFromSuperview];
		}
	}
	[[NSNotificationCenter defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:player];
}
-(void)moviePlayerDidExitFullscreenNotification:(NSNotification*) aNotification {
	MPMoviePlayerController *player = [aNotification object];
	player.view.hidden = YES;
	[player.view removeFromSuperview];
	[[NSNotificationCenter defaultCenter] 
	 removeObserver:self 
	 name:MPMoviePlayerDidExitFullscreenNotification
	 object:player];
	//[self.parentController hideVideo];
}


- (void)updateLayout:(CGRect)frame {
	[self.view setFrame:frame];
	if (wvVideo) {
		[wvVideo setCenter:CGPointMake(frame.size.width/2.0f, frame.size.height/2.0f)];
	}
	if (activityIndicator) {
		[activityIndicator setCenter:CGPointMake(frame.size.width/2.0f, frame.size.height/2.0f)];
	}
}

#pragma mark -
#pragma mark Controller Animation Cycle
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if ((animationID == @"hideVideo")/* && finished*/) {  
	}
	if ((animationID == @"fadeInBrowser")/* && finished*/) {  
		activityIndicator.hidden = YES;
	}
}	

- (void)fadeOutView {		//Animate Fade Out
	if (wvVideo != nil) {
		NSString *urlAddress = @"about:blank";
		NSURL *url = [NSURL URLWithString:urlAddress];
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
		[wvVideo loadRequest:urlRequest];
		wvVideo.hidden = false;
		
	}
	[UIView beginAnimations:@"hideVideo" context:nil];
	[UIView setAnimationDuration:0.25f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 0.0f;
	[UIView commitAnimations];
}
- (void)fadeOutBrowser {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutBrowser" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	wvVideo.alpha = 0.0f;
	[UIView commitAnimations];
}


- (void)fadeInView {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInView" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.view.alpha = 1.0f;
	[UIView commitAnimations];
}

- (void)fadeInBrowser {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInBrowser" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	wvVideo.alpha = 1.0f;
	activityIndicator.alpha = 0.0f;
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark WebView Callbacks
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *connectionError = [[[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Error connecting to page.  Please check your 3G and/or Wifi settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease]; 
    [connectionError show];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(windowNowVisible:)
	 name:UIWindowDidBecomeVisibleNotification
	 object:self.view
	 ];
	[activityIndicator stopAnimating];
	UIButton *b = [self findButtonInView:wvVideo];
	[b sendActionsForControlEvents:UIControlEventTouchUpInside];
	[self fadeInBrowser];
	
}

- (NSString *)showSubviews:(UIView *)view tabs:(NSString *)tabs {
	if (!tabs) {
		tabs = @"";
	}
	NSString *currStr = tabs;
	currStr = [NSString stringWithFormat:@"%@%@\n", tabs, [view class], nil];
	if (view.subviews && [view.subviews count] > 0) {
		tabs = [tabs stringByAppendingString:@"\t"];
		for (UIView *subviews in view.subviews) {
			currStr = [currStr stringByAppendingString:[self showSubviews:subviews tabs:tabs]];
		}
	}
	return currStr;
}

#pragma mark -
#pragma mark Private Functions
- (UIButton *)findButtonInView:(UIView *) view {
	UIButton *button = nil;
	if ([view isMemberOfClass:[UIButton class]]) {
		return (UIButton *) view;
	}
	
	if (view.subviews && [view.subviews count] > 0) {
		for (UIView *subview in view.subviews) {
			button = [self findButtonInView:subview];
			if (button) {
				return button;
			}
		}
	}
	return button;
}

//TODO: Is this general purpose (take the string for the name of the movie view) or should the movie be a retained variable?
// This is specifically looking for the youtube player view.
- (UIView *)findYTMovieViewInView:(UIView *) view {
	UIView *movie = nil;
	NSString *className = [NSString stringWithFormat:@"%@",  [view class], nil];
	if ([className isEqualToString:@"YTMovieView"] ) {
		return view;
	}
	
	if (view.subviews && [view.subviews count] > 0) {
		for (UIView *subview in view.subviews) {
			movie = [self findYTMovieViewInView:subview];
			if (movie) {
				return movie;
			}
		}
	}
	return movie;
}



//TODO:Can you explain why this message is named this way?
// Because it's called from the event UIWindowDidBecomeVisibleNotification and seemed appropriate.
- (void)windowNowVisible:(NSNotification *)note {
	[[NSNotificationCenter defaultCenter] 
	 removeObserver:self
	 name:UIWindowDidBecomeVisibleNotification
	 object:self.view];
}

@end
