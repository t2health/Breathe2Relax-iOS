//
//  ViewSettingListController.h
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/3/11.
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
#import <UIKit/UIKit.h>
#import "MessageUI/MessageUI.h"
#import "MessageUI/MFMailComposeViewController.h"

#import "PlayerSettings.h"
typedef enum {
	enSectionVisual = 0,
	enSectionAudio,
	enSectionTimings,
    enSectionTracking,
	enSectionHelp,
	enSectionAnalytics,
	enCellVisual = 0,
	enCellMetronome,
	enCellVisualPrompts,
	enCellAudioPrompts = 0,
	enCellAudioInstructions,
	enCellBackgroundMusicOn,
	enCellBackgroundMusic,
	enCellBreathSpanIn = 0,
    enCellbreathSpanOut,
	enCellBreathCycles,
    enCellTrackOn = 0,
    enCellResetHelpPrompts = 0,
    enCellRateApp = 0,
    enCellHelpSuggestions,
    enCellAnalyticsOn
} enB2RSettings;


@interface ViewSettingListController : UITableViewController <MFMailComposeViewControllerDelegate> {
	NSArray *items;
	PlayerSettings *settings;
    
    BOOL resetHelp;
    int selectedSection;
    int selectedRow;
}
@property(nonatomic, retain) PlayerSettings *settings;
@property(nonatomic, retain) NSArray *items;

- (void)saveSettings;
- (void)toggleSwitch: (id) sender;
- (void)segmentControl_changed:(id)sender;
- (UITableViewCell *)createCellForIdentifier:(NSString *)identifier 
								   tableView:(UITableView *)tableView 
								   indexPath:(NSIndexPath *)indexPath 
									   style:(UITableViewCellStyle)style 
								  selectable:(BOOL)selectable;
- (void)sendFeedback;
- (void)rateApp;
@end
