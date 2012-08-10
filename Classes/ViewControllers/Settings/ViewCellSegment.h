//
//  ViewCellSegment.h
//  Breathe
//
//  Created by Roger Reeder on 1/29/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewCellSegment : UITableViewCell {
	UILabel *primaryLabel;
	UILabel *secondaryLabel;
	UISegmentedControl *segmentControl;
}

@property(nonatomic,retain)UILabel *primaryLabel;
@property(nonatomic,retain)UILabel *secondaryLabel;
@property(nonatomic,retain)UISegmentedControl *segmentControl;

@end
