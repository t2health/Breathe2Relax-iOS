//
//  ViewSettingListController.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/3/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewSettingListController.h"
#import "ViewCellSettingLine.h"
#import "ViewCellSettingSwitch.h"
#import "ViewCellSegment.h"
#import "ViewCellSettingVisual.h"
#import "ViewScenesList.h"
#import "ViewSettingMusicList.h"
#import "ViewSettingBreath.h"
#import "FirstTime.h"
#import "Visual.h"
#import "Music.h"
#import "B2RAppDelegate.h"
#import "ViewWebSiteController.h"


@implementation ViewSettingListController

@synthesize settings;
@synthesize items;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	PlayerSettings *s = appDelegate.playerSettings;
	
	settings = [[PlayerSettings alloc] initWithName:s.visual 
										  voiceType:s.voiceType 
											 cycles:s.cycles 
									  visualPrompts:s.visualPrompts 
										  showGauge:s.showGauge 
                                     ambientMusicOn:s.ambientMusicOn 
                                       ambientMusic:s.ambientMusic 
                                  audioInstructions:s.audioInstructions 
									   audioPrompts:s.audioPrompts 
                                       breathSpanIn:s.breathSpanIn
                                      breathSpanOut:s.breathSpanOut
                                      breathPauseIn:s.breathPauseIn
                                     breathPauseOut:s.breathPauseOut
                                            trackOn:s.trackOn
                                          analytics:s.analytics];
	
    selectedRow = -1;
    selectedSection = -1;
    
	NSMutableArray *sa = [[[NSMutableArray alloc] init] autorelease] ;
	NSDictionary *ps = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"]] 
														mutabilityOption:NSPropertyListImmutable 
																  format:nil 
                                                        errorDescription:nil];
	NSArray *sections = [NSArray arrayWithArray:[ps objectForKey:@"Sections"]];
	
	for (NSDictionary *section in sections) {
		[sa addObject:section];
	}
	items = [[NSArray arrayWithArray:sa] retain];
	
    resetHelp = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    if (selectedSection >= 0 && selectedRow >= 0) {
        [self.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"SETTINGS LIST VIEW"];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSInteger rows = [(NSArray *)[(NSDictionary *)[items objectAtIndex:section] objectForKey:@"Rows"] count];
	return rows;
}

- (void)segmentControl_changed:(id)sender {
	int section = [sender tag]/10;
	int row = [sender tag] % 10;
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	int iValue = [segmentedControl selectedSegmentIndex];
	switch (section) {
		case enSectionTimings:
			switch (row) {
				case enCellBreathCycles:
					settings.cycles = (iValue * 2)+8;
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
}

- (void)toggleSwitch:(id)sender {
	int section = [sender tag]/10;
	int row = [sender tag] % 10; //  s = Section and r = Row
	BOOL bValue = ((UISwitch *)sender).on;
	switch (section) {
		case enSectionVisual:
			switch (row) {
				case enCellMetronome:
					settings.showGauge = bValue;
					break;
				case enCellVisualPrompts:
					settings.visualPrompts = bValue;
					break;
				default:
					break;
			}
			break;
            
		case enSectionAudio:
			switch (row) {
				case enCellAudioPrompts:
					settings.audioPrompts = bValue;
					break;
				case enCellAudioInstructions:
					settings.audioInstructions = bValue;
					break;
				case enCellBackgroundMusicOn:
					settings.ambientMusicOn = bValue;
					break;
				default:
					break;
			}
			break;
        case enSectionTracking:
            switch (row) {
                case enCellTrackOn:
                   settings.trackOn = bValue;
                    break;
                default:
                    break;
            }
		case enSectionHelp:
			switch (row) {
				case enCellResetHelpPrompts:
                    if (bValue) {
                        resetHelp = YES;
                    }
					break;
				default:
					break;
			}
			break;
		case enSectionAnalytics:
			switch (row) {
				case enCellAnalyticsOn:
					settings.analytics = bValue;
					break;
				default:
					break;
			}
			break;
	}
}

-(UITableViewCell *)createCellForIdentifier:(NSString *)identifier
								  tableView:(UITableView *)tableView
								  indexPath:(NSIndexPath *)indexPath
									  style:(UITableViewCellStyle)style
								 selectable:(BOOL)selectable {
    
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    int tag = indexPath.section * 10 + indexPath.row;
    if (cell == nil) {
		if ([identifier isEqualToString:@"Visual"]) {
			cell = (UITableViewCell *)[[[ViewCellSettingVisual alloc] initWithStyle:UITableViewCellAccessoryDisclosureIndicator reuseIdentifier:identifier] autorelease];
		}
		if ([identifier isEqualToString:@"Switch"]) {
			cell = (UITableViewCell *)[[[ViewCellSettingSwitch alloc] initWithStyle:UITableViewCellAccessoryNone reuseIdentifier:identifier] autorelease];
			((ViewCellSettingSwitch *)cell).toggleSwitch.tag = tag;
			[((ViewCellSettingSwitch *)cell).toggleSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
		}
		if ([identifier isEqualToString:@"Segment"]) {
			cell = (UITableViewCell *)[[[ViewCellSegment alloc] initWithStyle:UITableViewCellAccessoryNone reuseIdentifier:identifier] autorelease];
			((ViewCellSegment *)cell).segmentControl.tag = tag;
			[((ViewCellSegment *)cell).segmentControl addTarget:self action:@selector(segmentControl_changed:) forControlEvents:UIControlEventValueChanged];
            
		}
		if ([identifier isEqualToString:@"Cycle"]) {
			cell = (UITableViewCell *)[[[ViewCellSegment alloc] initWithStyle:UITableViewCellAccessoryNone reuseIdentifier:identifier] autorelease];
			((ViewCellSegment *)cell).segmentControl.tag = tag;
			[((ViewCellSegment *)cell).segmentControl addTarget:self action:@selector(segmentControl_changed:) forControlEvents:UIControlEventValueChanged];
		}
		if ([identifier isEqualToString:@"VoiceType"]) {
			cell = (UITableViewCell *)[[[ViewCellSegment alloc] initWithStyle:UITableViewCellAccessoryNone reuseIdentifier:identifier] autorelease];
			((ViewCellSegment *)cell).segmentControl.tag = tag;
			[((ViewCellSegment *)cell).segmentControl addTarget:self action:@selector(segmentControl_changed:) forControlEvents:UIControlEventValueChanged];
		}
		if ([identifier isEqualToString:@"Line"]) {
			cell = (UITableViewCell *)[[[ViewCellSettingLine alloc] initWithStyle:UITableViewCellAccessoryDisclosureIndicator reuseIdentifier:identifier] autorelease];
		}
        cell.selectionStyle = selectable ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
		
        SEL initCellSelector = NSSelectorFromString([NSString stringWithFormat:@"initCellFor%@:indexPath:", identifier]);
        if ([self respondsToSelector:initCellSelector]) {
            [self performSelector:initCellSelector withObject:cell withObject:indexPath];
        }
    }
	ViewCellSettingLine *c = (ViewCellSettingLine *)cell;
	ViewCellSettingSwitch *cT = (ViewCellSettingSwitch *)cell;
	ViewCellSegment *cS = (ViewCellSegment *)cell;
	ViewCellSettingVisual *cV = (ViewCellSettingVisual *)cell;
	//RootViewController *rc = (RootViewController *)self.navigationController.delegate;
	
	Visual *vis = (Visual *)[appDelegate.visuals objectAtIndex:settings.visual];
	NSDictionary *setting = (NSDictionary *)[(NSArray *)[(NSDictionary *)[items objectAtIndex:indexPath.section] objectForKey:@"Rows"] objectAtIndex:indexPath.row];
    
	switch (indexPath.section) {
		case enSectionVisual:
			switch (indexPath.row) {
				case enCellVisual:
					cV.primaryLabel.text = vis.name;
					cV.secondaryLabel.text = vis.description;
					cV.myImageView.image = [UIImage imageNamed:vis.thumbName];
					cV.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					break;
                    
				case enCellMetronome:
					cT.primaryLabel.text = [setting objectForKey:@"Title"];
					cT.secondaryLabel.text = [setting objectForKey:@"Description"];
					cT.accessoryType = UITableViewCellAccessoryNone;
					cT.toggleSwitch.on = settings.showGauge;
					cT.toggleSwitch.enabled = YES;
                    cT.toggleSwitch.tag = tag;
					break;
                    
				case enCellVisualPrompts:
					cT.primaryLabel.text = [setting objectForKey:@"Title"];
					cT.secondaryLabel.text = [setting objectForKey:@"Description"];
					cT.accessoryType = UITableViewCellAccessoryNone;
					cT.toggleSwitch.on = settings.visualPrompts;
					cT.toggleSwitch.enabled = YES;
                    cT.toggleSwitch.tag = tag;
					break;
			}
			break;
            
		case enSectionAudio:
			switch (indexPath.row) {
				case enCellAudioPrompts://audio
					cT.primaryLabel.text = [setting objectForKey:@"Title"];
					cT.secondaryLabel.text = [setting objectForKey:@"Description"];
					cT.accessoryType = UITableViewCellAccessoryNone;
					cT.toggleSwitch.on = settings.audioPrompts;
					cT.toggleSwitch.enabled = YES;
                    cT.toggleSwitch.tag = tag;
					break;
				case enCellAudioInstructions://instructions
					cT.primaryLabel.text = [setting objectForKey:@"Title"];
					cT.secondaryLabel.text = [setting objectForKey:@"Description"];
					cT.accessoryType = UITableViewCellAccessoryNone;
					cT.toggleSwitch.on = settings.audioInstructions;
					cT.toggleSwitch.enabled = YES;
                    cT.toggleSwitch.tag = tag;
					break;
				case enCellBackgroundMusicOn:
					cT.primaryLabel.text = [setting objectForKey:@"Title"];
					cT.secondaryLabel.text = [setting objectForKey:@"Description"];
					cT.accessoryType = UITableViewCellAccessoryNone;
					cT.toggleSwitch.on = settings.ambientMusicOn;
					cT.toggleSwitch.enabled = YES;
                    cT.toggleSwitch.tag = tag;
					break;
				case enCellBackgroundMusic:
                    if (settings.ambientMusic >= 0) {
                        Music *mus = (Music *)[appDelegate.music objectAtIndex:settings.ambientMusic];
                        c.primaryLabel.text = @"Selected Background Music";
                        c.secondaryLabel.text = [NSString stringWithFormat:@"%@ (tap to change)", mus.title];
                    } else {
                        c.primaryLabel.text = @"Selected Background Music";
                        c.secondaryLabel.text = @"Randomly from list (tap to change)";
                    }
 					c.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					break;
			}
			break;
            
		case enSectionTimings:
			switch (indexPath.row) {
				case enCellBreathSpanIn:
					c.primaryLabel.text = [NSString stringWithFormat:@"Set Inhale Length (%4.1f secs)",(CGFloat)settings.breathSpanIn/1000.0f];
					c.secondaryLabel.text = [setting objectForKey:@"Description"];
					c.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					break;
				case enCellbreathSpanOut:
					c.primaryLabel.text = [NSString stringWithFormat:@"Set Exhale Length (%4.1f secs)",(CGFloat)settings.breathSpanOut/1000.0f];
					c.secondaryLabel.text = [setting objectForKey:@"Description"];
					c.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					break;
				case enCellBreathCycles:
					cS.secondaryLabel.text = [setting objectForKey:@"Description"];
					cS.accessoryType = UITableViewCellAccessoryNone;
					cS.segmentControl.selectedSegmentIndex = (settings.cycles - 8)/2;
					cS.segmentControl.enabled = YES;
                    cS.tag = tag;
					break;
			}
			break;
        case enSectionTracking:
            switch (indexPath.row) {
				case enCellTrackOn:
					cT.primaryLabel.text = [setting objectForKey:@"Title"];
					cT.secondaryLabel.text = [setting objectForKey:@"Description"];
					cT.accessoryType = UITableViewCellAccessoryNone;
                    [cT.toggleSwitch setOn:settings.trackOn];
					cT.toggleSwitch.enabled = YES;
                    cT.toggleSwitch.tag = tag;
					break;
                default:
                    break;
            }
            break;
		case enSectionHelp:
			switch (indexPath.row) {
				case enCellResetHelpPrompts:
					cT.primaryLabel.text = [setting objectForKey:@"Title"];
					cT.secondaryLabel.text = [setting objectForKey:@"Description"];
					cT.accessoryType = UITableViewCellAccessoryNone;
					cT.toggleSwitch.on = NO;
					cT.toggleSwitch.enabled = YES;
                    cT.toggleSwitch.tag = tag;
					break;
			}
			break;
            
		case enSectionAnalytics:
			switch (indexPath.row) {
				case enCellRateApp:
					c.primaryLabel.text = [setting objectForKey:@"Title"];
					c.secondaryLabel.text = [setting objectForKey:@"Description"];
					c.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					break;
				case enCellHelpSuggestions:
					c.primaryLabel.text = [setting objectForKey:@"Title"];
					c.secondaryLabel.text = [setting objectForKey:@"Description"];
					c.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					break;
				case enCellAnalyticsOn:
					cT.primaryLabel.text = [setting objectForKey:@"Title"];
					cT.secondaryLabel.text = [setting objectForKey:@"Description"];
					cT.accessoryType = UITableViewCellAccessoryNone;
					cT.toggleSwitch.on = settings.analytics;
					cT.toggleSwitch.enabled = YES;
                    cT.toggleSwitch.tag = tag;
					break;
			}
			break;
            
	}
	
    SEL customizeCellSelector = NSSelectorFromString([NSString stringWithFormat:@"customizeCellFor%@:indexPath:", identifier]);
    if ([self respondsToSelector:customizeCellSelector]) {
        [self performSelector:customizeCellSelector withObject:cell withObject:indexPath];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Switch";
    BOOL selectable = NO;
    UITableViewCellStyle style = UITableViewCellStyleDefault;
    
	NSDictionary *setting = (NSDictionary *)[(NSArray *)[(NSDictionary *)[items objectAtIndex:indexPath.section] objectForKey:@"Rows"] objectAtIndex:indexPath.row];
	identifier = [setting objectForKey:@"ReuseID"];
	selectable = [[setting objectForKey:@"Selectable"] boolValue];
    return [self createCellForIdentifier:identifier
                               tableView:tableView
                               indexPath:indexPath
                                   style:style
                              selectable:selectable];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // fixed font style. use custom view (UILabel) if you want something different
	NSString *s = [(NSDictionary *)[items objectAtIndex:section] objectForKey:@"Title"];
	return s;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 50.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        rowHeight = 80.0f;
    }
    if (indexPath.section == enSectionTimings && indexPath.row == enCellBreathCycles) {
        rowHeight = rowHeight * 1.5f;
    }
    return rowHeight;
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedSection = indexPath.section;
    selectedRow = indexPath.row;
    
	if (indexPath.section == enSectionVisual && indexPath.row == enCellVisual) {
		ViewScenesList *anotherViewController = [[ViewScenesList alloc] initWithStyle:UITableViewStylePlain];
		anotherViewController.title = @"Pick Scene";
        anotherViewController.settings = self.settings;
		[self.navigationController pushViewController:anotherViewController animated:YES];
		[anotherViewController release];
	} else if (indexPath.section == enSectionTimings && indexPath.row == enCellBreathSpanIn) {
		ViewSettingBreath *anotherViewController2 = [[ViewSettingBreath alloc] initWithNibName:@"ViewSettingBreath" bundle:nil];
		anotherViewController2.title = @"Set Inhale Length";
        anotherViewController2.settings = self.settings;
		anotherViewController2.breathInflate = settings.breathSpanIn;
        anotherViewController2.inhaling = YES;
		anotherViewController2.lLastTime.text = [NSString stringWithFormat:@"%4.1f sec",settings.breathSpanIn];
		[self.navigationController pushViewController:anotherViewController2 animated:YES];
		[anotherViewController2 release];
	} else if (indexPath.section == enSectionTimings && indexPath.row == enCellbreathSpanOut) {
		ViewSettingBreath *anotherViewController4 = [[ViewSettingBreath alloc] initWithNibName:@"ViewSettingBreath" bundle:nil];
		anotherViewController4.title = @"Set Exhale Length";
        anotherViewController4.settings = self.settings;
		anotherViewController4.breathInflate = settings.breathSpanIn;
        anotherViewController4.inhaling = NO;
		anotherViewController4.lLastTime.text = [NSString stringWithFormat:@"%4.1f sec",settings.breathSpanOut];
		[self.navigationController pushViewController:anotherViewController4 animated:YES];
		[anotherViewController4 release];
	} else if (indexPath.section == enSectionAudio && indexPath.row == enCellBackgroundMusic) {
		ViewSettingMusicList *anotherViewController3 = [[ViewSettingMusicList alloc] initWithNibName:@"ViewSettingMusicList" bundle:nil];
		anotherViewController3.title = @"Music";
        anotherViewController3.settings = self.settings;
		[self.navigationController pushViewController:anotherViewController3 animated:YES];
		[anotherViewController3 release];
	} else if (indexPath.section == enSectionAnalytics && indexPath.row == enCellRateApp) {
        [self rateApp];
	} else if (indexPath.section == enSectionAnalytics && indexPath.row == enCellHelpSuggestions) {
        [self sendFeedback];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [self saveSettings];
	[items release];
    [super dealloc];
}

- (void)saveSettings {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if (resetHelp) {
        [appDelegate.firstTime resetAllGuides];
    }
    if (settings.trackOn) {
        appDelegate.firstTime.skipVAS = NO;
    }
    [appDelegate savePracticeSettings:self.settings];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Mail
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)rateApp {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *url = [appDelegate getAppSetting:@"URLs" withKey:@"rateApp"];
    ViewWebSiteController *controller = [[ViewWebSiteController alloc] initWithNibName:@"ViewWebSiteController" bundle:nil];
    controller.url = url;
    
    //controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //[self presentModalViewController:controller animated:YES];
    controller.title = @"Rate Breathe2Relax";
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];

}

- (void)sendFeedback {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([MFMailComposeViewController canSendMail]) {
        NSString *toRecipient = [appDelegate getAppSetting:@"Feedback" withKey:@"recipient"]; 
        NSString *subject = [appDelegate getAppSetting:@"Feedback" withKey:@"subject"];
        NSString *emailBody = [appDelegate getAppSetting:@"Feedback" withKey:@"body"];
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setToRecipients:[NSArray arrayWithObject:toRecipient]];
        [picker setSubject:subject];
        [picker setMessageBody:emailBody isHTML:YES];
        [self presentModalViewController:picker animated:YES];
        [picker release];
    } else {
        NSString* msg = @"There's a problem sending email, possibly your email is not setup";
        
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Sending Feedback"
                                                     message:msg 
                                                    delegate:self 
                                           cancelButtonTitle:@"Ok" 
                                           otherButtonTitles: nil];
        [av show];
        [av release];
        
    }
}

@end
