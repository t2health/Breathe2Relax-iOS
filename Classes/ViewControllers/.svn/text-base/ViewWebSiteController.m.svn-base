//
//  ViewWebSiteController.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/23/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewWebSiteController.h"

#import "Analytics.h"

@implementation ViewWebSiteController

@synthesize webView;
@synthesize url;
@synthesize activity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [Analytics logEvent:[NSString stringWithFormat:@"WEBSITE %@ VIEW",self.title]];
    if (self.url) {
        NSURL *theURL = [[NSURL alloc] initWithString:self.url];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:theURL];
        [self.webView loadRequest:request];
        [request release];
        [theURL release];
        //show URL in WebView;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
//    self.webView.delegate = nil;
    [self.webView stopLoading];
    if ([self.activity isAnimating]) {
        [self.activity stopAnimating];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activity stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

@end
