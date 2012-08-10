//
//  ViewCellSettingSwitch.h
//  iBreath160
//
//  Created by Roger Reeder on 1/27/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewCellSettingSwitch : UITableViewCell {
	UILabel *primaryLabel;
	UILabel *secondaryLabel;
	UISwitch *toggleSwitch;
	
}

@property(nonatomic,retain)UILabel *primaryLabel;
@property(nonatomic,retain)UILabel *secondaryLabel;
@property(nonatomic,retain)UISwitch *toggleSwitch;

@end
