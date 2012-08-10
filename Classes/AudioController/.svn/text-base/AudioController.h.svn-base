//
//  AudioController.h
//  iBreathe110
//
//  Created by Roger Reeder on 8/4/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>

typedef enum {
	enSCIn = 0,
	enSCEx,
	enSCSay,
	enSCThink,
	enSCNumber,
	enSCYourself,
	enSCOut,
	enSCDef,
	enSCRelax,
	enSCEasy,
	enSCFocus,
	enSCBackward,
	enSCPause,
    enSCMusic,
	enSCAmbient
} enSoundChannels;

@class RootViewController;
@interface AudioController : NSObject <AVAudioPlayerDelegate> {
    AVAudioPlayer *players[enSCAmbient+1];
	RootViewController *parentController;
	
}
@property (nonatomic, retain) RootViewController *parentController;

//TODO: why is players not a retained property?

- (void) preparePlayer:(enSoundChannels)soundChannel andMP3File:(NSString *)mp3File andMP3Volume:(float) mp3Volume andMP3Pan:(float)mp3Pan andNumberOfLoops:(NSInteger) numberOfLoops delegate:(id)delegate;
- (BOOL) isPlaying:(enSoundChannels)soundChannel;
- (void) play:(enSoundChannels)soundChannel;
- (void) stop:(enSoundChannels)soundChannel;
- (void) stopAll;
- (void) stopAllButMusic;
- (void) fade:(NSNumber *)whatChannel;
- (void) fadeSlow:(NSNumber *)whatChannel;
@end
