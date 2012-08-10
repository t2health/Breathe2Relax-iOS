//
//  ViewSettingListController.h
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/3/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

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
