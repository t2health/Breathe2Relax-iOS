//
//  ViewSettingMusicList.h
//  Breathe2Relax
//
//  Created by Roger Reeder on 3/29/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioController.h"
#import "PlayerSettings.h"

@interface ViewSettingMusicList : UIViewController <UITableViewDelegate> {
    NSArray *items;
    int selectedMusic;
    AudioController *audiPreview;
    IBOutlet UILabel *tfTitle;
    IBOutlet UILabel *tfArtist;
    IBOutlet UILabel *tfDescription;
    IBOutlet UILabel *tfCredit;
    IBOutlet UITableView *tvMusicList;
    IBOutlet UIButton *bPreview;
    IBOutlet UIButton *bUse;
    PlayerSettings *settings;
}

@property(nonatomic, retain) PlayerSettings *settings;
@property (nonatomic, retain) IBOutlet UILabel *tfTitle;
@property (nonatomic, retain) IBOutlet UILabel *tfArtist;
@property (nonatomic, retain) IBOutlet UILabel *tfDescription;
@property (nonatomic, retain) IBOutlet UILabel *tfCredit;
@property (nonatomic, retain) IBOutlet UIButton *bPreview;
@property (nonatomic, retain) IBOutlet UIButton *bUse;
@property (nonatomic, retain) IBOutlet UITableView *tvMusicList;

- (IBAction) bPreview_TouchUp:(id)sender;
- (IBAction) bUse_TouchUp:(id)sender;
- (void) updateMusicDisplay;
@end
