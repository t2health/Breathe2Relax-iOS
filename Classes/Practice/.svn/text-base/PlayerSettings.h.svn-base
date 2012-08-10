//
//  PlayerSettings.h
//  Breathe
//
//  Created by Roger Reeder on 1/29/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

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
