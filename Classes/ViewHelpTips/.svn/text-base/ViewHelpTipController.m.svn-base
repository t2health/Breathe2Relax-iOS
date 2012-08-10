//
//  ViewHelpTipController.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/6/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewHelpTipController.h"
#import "B2RAppDelegate.h"

@implementation ViewHelpTipController

@synthesize chkBox;
@synthesize vChkBox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [self.chkBox release];
    [self.vChkBox release];
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
    ViewCheckboxController *vc = [[ViewCheckboxController alloc] initWithNibName:@"ViewCheckboxController" bundle:nil];
    CGRect rect = self.vChkBox.frame;
    rect.origin.x = 0.0f;
    rect.origin.y = 0.0f;
    vc.view.frame = rect;
    [self.vChkBox addSubview:vc.view];
    self.chkBox = vc;
    [vc release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (IBAction)bClose_Click:(id)sender {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.navigationController dismissModalViewControllerAnimated:YES];
}
@end
