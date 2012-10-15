//
//  PlayerSettings.h
//  Breathe
//
//  Created by Roger Reeder on 1/29/11.
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
#import <Foundation/Foundation.h>

@interface PlayerSettings : NSObject {
	int visual;
	BOOL showGauge;
	BOOL audioinstructions;
	BOOL audioPrompts;
	BOOL ambientMusicOn;
    int ambientMusic;
	BOOL visualPrompts;
    int breathSpanIn;
    int breathSpanOut;
    int breathPauseIn;
    int breathPauseOut;
	int voiceType;
	int cycles;
    BOOL trackOn;
    BOOL analytics;
}

@property(nonatomic) int visual;
@property(nonatomic) BOOL showGauge;
@property(nonatomic) BOOL visualPrompts;
@property(nonatomic) BOOL ambientMusicOn;
@property(nonatomic) int ambientMusic;
@property(nonatomic) BOOL audioInstructions;
@property(nonatomic) BOOL audioPrompts;
@property(nonatomic) int breathSpanIn;
@property(nonatomic) int breathSpanOut;
@property(nonatomic) int breathPauseIn;
@property(nonatomic) int breathPauseOut;
@property(nonatomic) int voiceType;
@property(nonatomic) int cycles;
@property(nonatomic) BOOL trackOn;
@property(nonatomic) BOOL analytics;

- (id)initWithName:(int)v 
		 voiceType:(int)voice 
			cycles:(int)cyc 
	  visualPrompts:(BOOL)vprompt 
		 showGauge:(BOOL)show 
	   ambientMusicOn:(BOOL)ambMusOn 
      ambientMusic:(int)ambMus
 audioInstructions:(BOOL)aInstuct
	  audioPrompts:(BOOL)aprompt 
      breathSpanIn:(int) breathIn
     breathSpanOut:(int) breathOut
     breathPauseIn:(int) pauseIn
    breathPauseOut:(int) pauseOut
           trackOn:(BOOL)track
         analytics:(BOOL)analyt;

@end
