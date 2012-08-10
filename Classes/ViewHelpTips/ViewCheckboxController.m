//
//  ViewCheckboxController.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 2/9/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewCheckboxController.h"


@implementation ViewCheckboxController
@synthesize checkboxButton, bDescription, checkboxSelected;


- (IBAction)checkboxButton:(id)sender{
	if (self.checkboxSelected == NO){
		[self.checkboxButton setSelected:YES];
		self.checkboxSelected = YES;
	} else {
		[self.checkboxButton setSelected:NO];
		self.checkboxSelected = NO;
	}
}


- (void)viewDidLoad {
    [super viewDidLoad];
	self.checkboxSelected = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}

@end
