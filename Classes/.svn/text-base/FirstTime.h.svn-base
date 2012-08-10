//
//  FirstTime.h
//  Breathe
//
//  Created by Roger Reeder on 2/5/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FirstTime : NSObject {
	BOOL		firstTime;
    BOOL    shownRootGuide;
    BOOL    shownVASPre;
    BOOL    shownPractice;
    BOOL    shownVASPost;
    BOOL    shownResults;
    BOOL    shownSetup;
    BOOL    shownGuide;
    BOOL    shownLearn;
    BOOL    skipVAS;
    BOOL    shownPersonalize;
}
@property(nonatomic) BOOL firstTime;
@property(nonatomic) BOOL skipVAS;
@property(nonatomic) BOOL shownPersonalize;
@property(nonatomic) BOOL shownRootGuide;

- (id) init:(BOOL)ft;

- (BOOL) showGuideForPosition:(enAppPosition)appPosition;
- (void) setGuideForPosition:(enAppPosition)appPosition value:(BOOL)value;
- (void) resetAllGuides;
- (NSString *) getGuideTitleForPosition:(enAppPosition)appPosition;
- (NSString *) getGuideDetailForPosition:(enAppPosition)appPosition;

@end
