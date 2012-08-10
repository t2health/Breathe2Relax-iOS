//
//  ViewScenesList.m
//  iBreath160
//
//  Created by Roger Reeder on 1/26/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewScenesList.h"
#import "ViewCellSettingVisual.h"
#import "Visual.h"
#import "B2RAppDelegate.h"

@implementation ViewScenesList

@synthesize settings;

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	items = appDelegate.visuals;
    
	self.tableView.rowHeight = 80.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.rowHeight = 140.0f;
    }
	
}
- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"SETTING SCENERY LIST VIEW"];
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.firstTime showGuideForPosition:enAppPositionSetupScenes]) {
		[appDelegate showInfo:[appDelegate.firstTime getGuideTitleForPosition:enAppPositionSetupScenes] 
                     withInfo:[appDelegate.firstTime getGuideDetailForPosition:enAppPositionSetupScenes] 
                containerView:self.view appPosition:enAppPositionSetupScenes];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [items count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    Visual *vis = (Visual *)[items objectAtIndex:indexPath.row];
    ViewCellSettingVisual *cell = (ViewCellSettingVisual *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ViewCellSettingVisual alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.primaryLabel.text = vis.name;
    cell.secondaryLabel.text = vis.description;
    cell.myImageView.image = [UIImage imageNamed:vis.thumbName];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.settings) {
        self.settings.visual = (int)indexPath.row;
    }
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end

