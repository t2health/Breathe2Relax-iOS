//
//  ViewPersonalizeController.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/12/11.
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
#import "ViewPersonalizeController.h"
#import "B2RAppDelegate.h"
#import "FirstTime.h"
#import "PlayerSettings.h"

#import "ViewScenesList.h"
#import "ViewSettingMusicList.h"
#import "ViewSettingBreath.h"
#import "ViewVideoController.h"
#import "ViewBCVideoController.h"

@implementation ViewPersonalizeController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
	//																						target:self 
	//																					action:@selector(bCancel_Click:)] autorelease];
    CGFloat sectionHeaderHeight = 80.0f;
    CGFloat rowHeight = 40.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        sectionHeaderHeight = sectionHeaderHeight * 1.5f;
        rowHeight = rowHeight * 1.0f;
    }
    self.tableView.sectionHeaderHeight = sectionHeaderHeight;
    self.tableView.rowHeight = rowHeight;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [Analytics logEvent:@"PERSONALIZE VIEW"];
    [super viewDidAppear:animated];
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.firstTime.shownPersonalize = YES;
    if ([appDelegate.firstTime showGuideForPosition:enAppPositionPersonalize]) {
		[appDelegate showInfo:[appDelegate.firstTime getGuideTitleForPosition:enAppPositionPersonalize] 
                     withInfo:[appDelegate.firstTime getGuideDetailForPosition:enAppPositionPersonalize] 
                containerView:self.view appPosition:enAppPositionPersonalize];
    }
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"Welcome to Breathe2Relax, you can personalize the settings below to make your experience more pleasing";
    switch (section) {
        case 1:
            title = @"Demonstration Video";
            break;
            
        default:
            break;
    }
    return title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 4;
            break;
        case 1:
            rows = 1;
            break;
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Select Scenery";
                    cell.accessoryType = ([appDelegate eventCount:@"SetupScenes"]==0) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryCheckmark;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    break;
                case 1:
                    cell.textLabel.text = @"Select Background Music";
                    cell.accessoryType = ([appDelegate eventCount:@"SetupMusic"]==0) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryCheckmark;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat: @"Set Inhale Length (%4.1f secs)", (CGFloat)appDelegate.playerSettings.breathSpanIn/1000.0f];
                    cell.accessoryType = ([appDelegate eventCount:@"SetupInhale"]==0) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryCheckmark;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    break;
                case 3:
                    cell.textLabel.text = [NSString stringWithFormat: @"Set Exhale Length (%4.1f secs)", (CGFloat)appDelegate.playerSettings.breathSpanOut/1000.0f];
                    cell.accessoryType = ([appDelegate eventCount:@"SetupExhale"]==0) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryCheckmark;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Show Me How";
                    cell.accessoryType = ([appDelegate eventCount:@"ShowMe"]==0) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryCheckmark;
                    cell.accessoryView.frame = CGRectMake(0.0f, cell.accessoryView.frame.origin.y, cell.accessoryView.frame.size.width, cell.accessoryView.frame.size.height);
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)bCancel_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *anotherController = nil;
    NSString *controllerBundle = @"";
    NSString *controllerTitle = @"";
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    controllerTitle = @"Select Scenery";
                    anotherController = (UIViewController *)[[ViewScenesList alloc] initWithStyle:UITableViewStylePlain];
                    ((ViewScenesList *)anotherController).settings = appDelegate.playerSettings;
                    break;
                case 1:
                    controllerTitle = @"Select Background Music";
                    controllerBundle = @"ViewSettingMusicList";
                    anotherController = (UIViewController *)[[ViewSettingMusicList alloc] initWithNibName:controllerBundle bundle:nil];
                    ((ViewSettingMusicList *)anotherController).settings = appDelegate.playerSettings;
                    break;
                case 2:
                    controllerTitle = @"Set Inhale Length";
                    controllerBundle = @"ViewSettingBreath";
                    anotherController = (UIViewController *)[[ViewSettingBreath alloc] initWithNibName:controllerBundle bundle:nil];
                    ((ViewSettingBreath *)anotherController).inhaling = YES;
                    ((ViewSettingBreath *)anotherController).settings = appDelegate.playerSettings;
                    break;
                case 3:
                    controllerTitle = @"Set Exhale Length";
                    controllerBundle = @"ViewSettingBreath";
                    anotherController = (UIViewController *)[[ViewSettingBreath alloc] initWithNibName:controllerBundle bundle:nil];
                    ((ViewSettingBreath *)anotherController).inhaling = NO;
                    ((ViewSettingBreath *)anotherController).settings = appDelegate.playerSettings;
                    break;
                default:
                    break;
            }
            anotherController.title = controllerTitle;
            [self.navigationController pushViewController:anotherController animated:YES];
            [anotherController release];
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self showMe];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
}

- (void)showMe {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *msg = @"";
    BOOL hasInternet = NO;
    switch (appDelegate.networkStatus) {
        case NotReachable:
            hasInternet = NO;
            msg = @"Can't stream video, there's no internet connection, try again later or from another location";
            break;
        default:
            if (appDelegate.connectionRequired) {
                msg = @"Can't stream video, network available but connection not established, try again later or from another location";
            } else {
                hasInternet = YES;
            }
            break;
    }
    if (hasInternet) {
        NSString *controllerBundle;
        if (appDelegate.useYouTube) {
            controllerBundle = @"ViewVideoController";
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                controllerBundle = @"ViewVideoController";
            }
            
            ViewVideoController *anotherController = [[ViewVideoController alloc] initWithNibName:controllerBundle bundle:nil];
            anotherController.title = @"Watch Demonstration";
            B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
            anotherController.moviePath = [appDelegate getAppSetting:@"URLs" withKey:@"watchDemo"];
            [self.navigationController pushViewController:anotherController animated:YES];
            [anotherController release];
        } else {
            controllerBundle = @"ViewBCVideoController";
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                controllerBundle = @"ViewBCVideoController";
            }
            
            ViewBCVideoController *anotherController2 = [[ViewBCVideoController alloc] initWithNibName:controllerBundle bundle:nil];
            anotherController2.title = @"Watch Demonstration";
            B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
            long long videoID = [[appDelegate getAppSetting:@"Brightcove" withKey:@"demo"] longLongValue];
            //anotherController.moviePath = url;
            anotherController2.videoID = videoID;
            [self.navigationController pushViewController:anotherController2 animated:YES];
            [anotherController2 release];
            
        }
    } else {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Show Me How"
                                                     message:msg 
                                                    delegate:self 
                                           cancelButtonTitle:@"Ok" 
                                           otherButtonTitles: nil];
        [av show];
        [av release];
        
    }
    
}
@end
