//
//  AudioController.m
//  iBreathe110
//
//  Created by Roger Reeder on 8/4/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import "AudioController.h"
#import "RootViewController.h"


@implementation AudioController

@synthesize parentController;

- (id) init {
	if ((self = [super init])) {
		//do your own initialization here
		for (int i = 0 ; i <= enSCPause; i++) {
			players[i] = nil;
		}
	}
	return self;
}

- (BOOL)isPlaying:(enSoundChannels)soundChannel {
	BOOL response = NO;
	if((soundChannel >= enSCIn && soundChannel <= enSCAmbient) && players[soundChannel] != nil) {
		response = players[soundChannel].isPlaying;
	}
	return response;
}

- (void)play:(enSoundChannels)soundChannel {
	if (players[soundChannel] != nil) {
		if (!(players[soundChannel].isPlaying)) {
			[players[soundChannel] play];
		}
	} else {
		NSLog(@"No Sound on channel:%d",soundChannel);
	}
}

- (void)stopAll {
	for (int i = 0; i <= enSCAmbient; i++) {
		if([players[i] isPlaying])
			[players[i] stop];
		[players[i] release];
		players[i] = nil;
	}
}
- (void)stopAllButMusic {
	for (int i = 0; i <= enSCAmbient; i++) {
		if( i != enSCMusic) {
            if ([players[i] isPlaying])
                [players[i] stop];
            [players[i] release];
            players[i] = nil;
        }
	}
}


- (void)stop:(enSoundChannels)soundChannel {
	if (players[soundChannel] != nil) {
		if([players[soundChannel] isPlaying]) {
			[players[soundChannel] stop];
        }
		[players[soundChannel] release];
		players[soundChannel] = nil;
	}
}

- (void)preparePlayer:(enSoundChannels)soundChannel andMP3File:(NSString *)mp3File andMP3Volume:(float) mp3Volume andMP3Pan:(float)mp3Pan andNumberOfLoops:(NSInteger) numberOfLoops delegate:(id)delegate {
    NSLog(@"Preparing to play %@",mp3File);
    NSString *mpPath = [[NSBundle mainBundle] pathForResource:mp3File ofType:@"mp3"]; // *Music filename* is the name of the file that you want to play.  BE SURE that you type the correct characters as the system is case-sensitive.  It caused a crash for me...  Very painful.
	if(players[soundChannel] != nil) {
		if([players[soundChannel] isPlaying]) [players[soundChannel] stop];
		[players[soundChannel] dealloc];
	}
	AVAudioPlayer *av =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:mpPath] error:nil];
	players[soundChannel] = av;

	players[soundChannel].volume = mp3Volume;
    players[soundChannel].numberOfLoops = numberOfLoops; /* can be as many times as needed by the application   -    myExampleSound.numberOfLoops = -1; >> this will allow the file to play an infinite number of times  */
    if (delegate) {
        players[soundChannel].delegate = delegate;
    } else {
        players[soundChannel].delegate = self;
        
    }
	[players[soundChannel] prepareToPlay]; 
}

- (void) dealloc
{
    for (int i = 0 ; i <= enSCPause; i++) {
        if (players[i] != nil) {
            if ([players[i] isPlaying]) {
                [players[i] stop];
            }
            players[i] = nil;
        }
    }
	[super dealloc];
}

- (void) fade:(NSNumber *)whatChannel {
#define fade_out_steps 0.1;
    int soundChannel = [whatChannel intValue];
    if (players[soundChannel]) {
        if ([players[soundChannel] isPlaying]) {
            float theVolume = players[soundChannel].volume - fade_out_steps;
            if (theVolume > 0.0f) {
                players[soundChannel].volume = theVolume;
                [self performSelector:@selector(fade:) withObject:whatChannel afterDelay:0.1];
            } else {
                [players[soundChannel] stop];
            }
            
        }
    }

}

- (void) fadeSlow:(NSNumber *)whatChannel {
#define fadeSlow_out_steps 0.003;
    int soundChannel = [whatChannel intValue];
    if (players[soundChannel]) {
        if ([players[soundChannel] isPlaying]) {
            float theVolume = players[soundChannel].volume - fadeSlow_out_steps;
            if (theVolume > 0.0f) {
                players[soundChannel].volume = theVolume;
                [self performSelector:@selector(fadeSlow:) withObject:whatChannel afterDelay:0.1];
            } else {
                [players[soundChannel] stop];
            }
            
        }
    }
    
}

























@end
