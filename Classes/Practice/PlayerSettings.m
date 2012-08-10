//
//  PlayerSettings.m
//  Breathe
//
//  Created by Roger Reeder on 1/29/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import "PlayerSettings.h"


@implementation PlayerSettings

@synthesize visual;
@synthesize voiceType;
@synthesize cycles;
@synthesize visualPrompts;
@synthesize showGauge;
@synthesize ambientMusicOn;
@synthesize ambientMusic;
@synthesize audioInstructions;
@synthesize audioPrompts;
@synthesize breathSpanIn;
@synthesize breathSpanOut;
@synthesize breathPauseIn;
@synthesize breathPauseOut;
@synthesize trackOn;
@synthesize analytics;

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
         analytics:(BOOL)analyt {
	
	self.visual = v;
	self.voiceType = voice;
	self.cycles = cyc;
	self.visualPrompts = vprompt;
	self.showGauge = show;
    self.ambientMusicOn = ambMusOn;
    self.ambientMusic = ambMus;
	self.audioInstructions = aInstuct;
	self.audioPrompts = aprompt;
	self.breathSpanIn = breathIn;
    self.breathSpanOut = breathOut;
    self.breathPauseIn = pauseIn;
    self.breathPauseOut = pauseOut;
    self.trackOn = track;
    self.analytics = analyt;
	return self;
}

@end
