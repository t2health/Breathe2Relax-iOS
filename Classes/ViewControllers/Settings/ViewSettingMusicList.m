//
//  ViewSettingMusicList.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 3/29/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewSettingMusicList.h"
#import "ViewCellSettingMusic.h"
#import "RootViewController.h"
#import "B2RAppDelegate.h"
#import "Music.h"

@implementation ViewSettingMusicList
@synthesize tvMusicList;
@synthesize tfTitle;
@synthesize tfArtist;
@synthesize tfDescription;
@synthesize tfCredit;
@synthesize bPreview;
@synthesize bUse;
@synthesize settings;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger rows = 1;
    if (section == 1) {
        rows = [items count];
    }
    return rows;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RandomCell";
    if (indexPath.section == 1) {
        CellIdentifier = @"MusicCell";
    }
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if ([CellIdentifier isEqualToString:@"RandomCell"]) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        } else {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
    }
    if (indexPath.section == 1) {
        Music *mus = (Music *)[items objectAtIndex:indexPath.row];
        cell.textLabel.text = mus.title;
        cell.detailTextLabel.text = mus.description;
        //cell.creditLabel.text = mus.credit;
    } else {
        cell.textLabel.text = @"Random Music";
        cell.detailTextLabel.text = @"Play randomly from list below";
        //cell.creditLabel.text = @"";
    }
    return cell;
}

- (IBAction) bPreview_TouchUp:(id)sender{
    if ([audiPreview isPlaying:0] ) {
        [audiPreview stop:0];
        [self.bPreview setTitle:@"Preview" forState:UIControlStateNormal];
    } else  {
        Music *mus = (Music *)[items objectAtIndex:selectedMusic];
        [audiPreview preparePlayer:0 andMP3File:mus.bundleName andMP3Volume:1.0 andMP3Pan:0.0 andNumberOfLoops:-1 delegate:nil];
        [self.bPreview setTitle:@"Pause" forState:UIControlStateNormal];
        [audiPreview play:0];
    }
    
}
- (void) updateMusicDisplay {
    if (selectedMusic >= 0) {
        Music *mus = (Music *)[items objectAtIndex:selectedMusic];
        self.tfTitle.text = mus.title;
        self.tfArtist.text = mus.artist;
        self.tfDescription.text = mus.description;
        self.tfCredit.text = mus.credit;
        self.bPreview.userInteractionEnabled = YES;
        self.bPreview.hidden = NO;
        if ([audiPreview isPlaying:0] ) [audiPreview stop:0];
        [self.bPreview setTitle:@"Preview" forState:UIControlStateNormal];
    } else {
        self.tfTitle.text = @"Random Music";
        self.tfArtist.text = @"";
        self.tfDescription.text = @"Play randomly from list below";
        self.tfCredit.text = @"";
        self.bPreview.userInteractionEnabled = NO;
        self.bPreview.hidden = YES;
    }
    
}

- (IBAction) bUse_TouchUp:(id)sender{
    if (self.settings) {
        self.settings.ambientMusic = selectedMusic;
    }
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedMusic = -1;
    if (indexPath.section == 1) {
        selectedMusic = indexPath.row;
    }
    [self updateMusicDisplay];
}


- (void)dealloc
{
	if (audiPreview != nil) {
		[audiPreview stop:0];
	}
	[audiPreview release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	items = appDelegate.music;

    AudioController *ac = [[[AudioController alloc] init] retain];
    audiPreview = ac;
    [ac release];
    
    //Get their music section
    if (self.settings) {
        selectedMusic = self.settings.ambientMusic;
    }
    
    //[self updateMusicDisplay];
    if (selectedMusic == -1) {
        [self.tvMusicList selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [self.tvMusicList selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedMusic inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
 	self.tvMusicList.rowHeight = 50.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tvMusicList.rowHeight = 80.0f;
    }
   [self updateMusicDisplay];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:@"SETTING MUSIC LIST VIEW"];
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.firstTime showGuideForPosition:enAppPositionSetupMusic]) {
		[appDelegate showInfo:[appDelegate.firstTime getGuideTitleForPosition:enAppPositionSetupMusic] 
                     withInfo:[appDelegate.firstTime getGuideDetailForPosition:enAppPositionSetupMusic] 
                containerView:self.navigationController.view appPosition:enAppPositionSetupMusic];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
