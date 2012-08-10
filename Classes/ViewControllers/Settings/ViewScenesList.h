//
//  ViewScenesList.h
//  iBreath160
//
//  Created by Roger Reeder on 1/26/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerSettings.h"


@interface ViewScenesList : UITableViewController {
	NSArray *items;
    PlayerSettings *settings;
}

@property(nonatomic, retain) PlayerSettings *settings;

@end
