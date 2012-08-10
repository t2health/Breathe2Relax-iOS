//
//  FirstTime.m
//  Breathe
//
//  Created by Roger Reeder on 2/5/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import "FirstTime.h"
#import "B2RAppDelegate.h"
#import "ObjectDataAccess.h"

@implementation FirstTime
@synthesize firstTime;
@synthesize skipVAS;
@synthesize shownPersonalize;
@synthesize shownRootGuide;

- (id) init:(BOOL)ft {
	self.firstTime = ft;
    shownRootGuide = NO;
	return self;
}

- (BOOL) showGuideForPosition:(enAppPosition)appPosition {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL result = YES;
    switch (appPosition) {
        case enAppPositionRoot:
            [appDelegate incrementEventCount:@"Root"];
            if (shownRootGuide) {
                result = NO;
            } else {
                shownRootGuide = YES;
            }
            break;
        case enAppPositionVASPre:
            [appDelegate incrementEventCount:@"VASPre"];
            if (shownVASPre || self.skipVAS) {
                result = NO;
            } else {
                shownVASPre = YES;
            }
            break;
        case enAppPositionBreathe:
            [appDelegate incrementEventCount:@"Breathe"];
            if (shownPractice) {
                result = NO;
            } else {
                shownPractice = YES;
            }
            break;
        case enAppPositionVASPost:
            [appDelegate incrementEventCount:@"VASPost"];
            if (shownVASPost || self.skipVAS) {
                result = NO;
            } else {
                shownVASPost = YES;
            }
            break;
        case enAppPositionLearn:
            [appDelegate incrementEventCount:@"Learn"];
            if (shownLearn) {
                result = NO;
            } else {
                shownLearn = YES;
            }
            break;
        case enAppPositionSetup:
            [appDelegate incrementEventCount:@"Settings"];
            if (shownSetup) {
                result = NO;
            } else {
                shownSetup = YES;
            }
            break;
        case enAppPositionResults:
            [appDelegate incrementEventCount:@"Results"];
            if (shownResults) {
                result = NO;
            } else {
                shownResults = YES;
            }
            break;
        case enAppPositionSetupScenes:
            [appDelegate incrementEventCount:@"SetupScenes"];
            result = NO;
            break;
        case enAppPositionSetupMusic:
            [appDelegate incrementEventCount:@"SetupMusic"];
            result = NO;
            break;
        case enAppPositionSetupInhale:
            [appDelegate incrementEventCount:@"SetupInhale"];
            result = NO;
            break;
        case enAppPositionSetupExhale:
            [appDelegate incrementEventCount:@"SetupExhale"];
            result = NO;
            break;
        case enAppPositionShowMe:
            [appDelegate incrementEventCount:@"ShowMe"];
            result = NO;
            break;
        case enAppPositionPersonalize:
            [appDelegate incrementEventCount:@"Personalize"];
            result = NO;
            break;
        default:
            break;
    }
    if (!result) {
        return result;
    }
	NSDictionary *ps = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guide" ofType:@"plist"]] 
														mutabilityOption:NSPropertyListImmutable 
																  format:nil 
                                                        errorDescription:nil];
	NSArray *appLocations = [NSArray arrayWithArray:[ps objectForKey:@"GuideLocations"]];
    NSDictionary *appLocationInfo = (NSDictionary *)[appLocations objectAtIndex:appPosition];
    NSString *key = [appLocationInfo objectForKey:@"key"];
    
    result = [[appDelegate.datalayer getSettingValue:key andDefaultValue:@"1"] boolValue];
    return result;
}

- (void) setGuideForPosition:(enAppPosition)appPosition value:(BOOL)value {
	NSDictionary *ps = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guide" ofType:@"plist"]] 
														mutabilityOption:NSPropertyListImmutable 
																  format:nil 
                                                        errorDescription:nil];
	NSArray *appLocations = [NSArray arrayWithArray:[ps objectForKey:@"GuideLocations"]];
    NSDictionary *appLocationInfo = (NSDictionary *)[appLocations objectAtIndex:appPosition];
    NSString *key = [appLocationInfo objectForKey:@"key"];

    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.datalayer saveSetting:key andValue:[NSString stringWithFormat:@"%d",value]];
}

- (void) resetAllGuides {
	NSDictionary *ps = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guide" ofType:@"plist"]] 
														mutabilityOption:NSPropertyListImmutable 
																  format:nil 
                                                        errorDescription:nil];
    
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	NSArray *appLocations = [NSArray arrayWithArray:[ps objectForKey:@"GuideLocations"]];
    for (int i= 0; i < [appLocations count]; i++) {
        NSDictionary *appLocationInfo = (NSDictionary *)[appLocations objectAtIndex:i];
        NSString *key = [appLocationInfo objectForKey:@"key"];
        [appDelegate.datalayer saveSetting:key andValue:[NSString stringWithFormat:@"%d",YES]];
    }
}
- (NSString *) getGuideTitleForPosition:(enAppPosition)appPosition {
    NSString *result = @"";
	NSDictionary *ps = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guide" ofType:@"plist"]] 
														mutabilityOption:NSPropertyListImmutable 
																  format:nil 
                                                        errorDescription:nil];
	NSArray *appLocations = [NSArray arrayWithArray:[ps objectForKey:@"GuideLocations"]];
    NSDictionary *appLocationInfo = (NSDictionary *)[appLocations objectAtIndex:appPosition];
    result = [appLocationInfo objectForKey:@"title"];
    return result;
    
}

- (NSString *) getGuideDetailForPosition:(enAppPosition)appPosition {
    NSString *result = @"";
	NSDictionary *ps = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guide" ofType:@"plist"]] 
														mutabilityOption:NSPropertyListImmutable 
																  format:nil 
                                                        errorDescription:nil];
	NSArray *appLocations = [NSArray arrayWithArray:[ps objectForKey:@"GuideLocations"]];
    NSDictionary *appLocationInfo = (NSDictionary *)[appLocations objectAtIndex:appPosition];
    result = [appLocationInfo objectForKey:@"detail"];
    return result;
}
@end
