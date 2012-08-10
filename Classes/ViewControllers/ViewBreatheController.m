//
//  ViewBreatheController.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/4/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//
#import "B2RAppDelegate.h"
#import "ViewBreatheController.h"
#import "ViewVASController.h"
#import "Visual.h"
#import "Music.h"
#import "AudioController.h"

#import "Analytics.h"

@implementation ViewBreatheController

@synthesize vPractice;
@synthesize vPracticeScenery;
@synthesize vTubeGauge;
@synthesize bLeft;
@synthesize bMiddle;
@synthesize bRight;
@synthesize ivBackground;
@synthesize lStart;

#define kScenesFramesPerSecond				30.0f

const CGFloat kFramesPerSecond_iPad =	15.0f;
const CGFloat kFramesPerSecond_iPhone =	15.0f;
const CGFloat kPixelsToScroll_iPad =	1.0f;
const CGFloat kPixelsToScroll_iPhone =	1.0f;
const int kFadeFrames = 1000;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    practiceState = enPracticeStateStopped;
    orientation = [[UIDevice currentDevice] orientation];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																							target:self 
																							action:@selector(bCancel_Click:)] autorelease];
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[[UIApplication sharedApplication] delegate];
	Visual *vis = (Visual *) [appDelegate.visuals objectAtIndex:appDelegate.playerSettings.visual];
    NSString *bundleName = [NSString stringWithFormat:@"%@%d.%@",vis.bundleName,RANDOM_INT(1, vis.numberOfFrames), vis.postFix];
    self.ivBackground.image = [UIImage imageNamed:bundleName];
    self.bLeft.titleLabel.numberOfLines = 0;
    self.bLeft.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.bLeft.titleLabel.textAlignment = UITextAlignmentCenter;
    self.bRight.titleLabel.numberOfLines = 0;
    self.bRight.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.bRight.titleLabel.textAlignment = UITextAlignmentCenter;
    [appDelegate.audioPlayer stopAll];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    if (helpTips) {
        [helpTips updateLayout:self.view.frame];
    }
}
    
- (void)viewWillDisappear:(BOOL)animated {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.audioPlayer stopAll];
	if (timer != nil) {
		[timer invalidate];
		timer = nil;
	}
}
- (void)viewDidAppear:(BOOL)animated {

    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.firstTime showGuideForPosition:enAppPositionBreathe]) {
        helpTips = [appDelegate showInfo:[appDelegate.firstTime getGuideTitleForPosition:enAppPositionBreathe] 
                                withInfo:[appDelegate.firstTime getGuideDetailForPosition:enAppPositionBreathe] 
                           containerView:self.view 
                             appPosition:enAppPositionBreathe];
    } else if (helpTips) {
        [helpTips updateLayout:self.view.frame];
    }
    [self fadeInLabel];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL result = NO;
    if ((UIInterfaceOrientationIsLandscape(interfaceOrientation) && UIInterfaceOrientationIsLandscape(orientation)) || (UIInterfaceOrientationIsPortrait(interfaceOrientation) && UIInterfaceOrientationIsPortrait(orientation))) {
        result = YES;
    }
    //return result;
    return YES;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    CGFloat tubeWidth = self.vPractice.frame.size.width * TUBEWIDTHRATIO;
    if (self.vPractice.frame.size.height > self.vPractice.frame.size.width) {
        tubeWidth = self.vPractice.frame.size.height * TUBEWIDTHRATIO;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        tubeWidth = tubeWidth * 0.5f;
    }
    CGRect r = CGRectMake(5.0f, 5.0f, tubeWidth, self.vPractice.frame.size.height - 10.0f);
    [self.vTubeGauge updateLayout:r];
    [self.vPracticeScenery updateLayout:self.view.frame];
    if (helpTips) {
        [helpTips updateLayout:self.view.frame];
    }
}
- (void)startPractice:(int)startCycle {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	newBreathSpanIn = appDelegate.playerSettings.breathSpanIn;
    newBreathSpanOut = appDelegate.playerSettings.breathSpanOut;
	breathPosition = 0;
	breathInhaling = YES;
	cycle = startCycle;
	float ambientVolume = 1.0;
    if (appDelegate.playerSettings.audioPrompts || appDelegate.playerSettings.audioInstructions) {
        ambientVolume = 0.05;// Tone it down if there's audio prompts or instructions
    }
	float ambientPan = -1.0f;
	Visual *vis = (Visual *) [appDelegate.visuals objectAtIndex:appDelegate.playerSettings.visual];
	[self initPracticeScenery:vis.overlayFile];
	self.vPracticeScenery.bStatic = vis.staticImage;
	if (appDelegate.playerSettings.showGauge) {
		[self initTubeGauge];
	}
	//[self initAudioPlayer];
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	if (appDelegate.audioPlayer != nil) {
		[appDelegate.audioPlayer stop:enSCAmbient];
        if (appDelegate.playerSettings.ambientMusicOn) {
            Music *m = (Music *)[appDelegate.music objectAtIndex:(appDelegate.playerSettings.ambientMusic >= 0) ? appDelegate.playerSettings.ambientMusic : RANDOM_INT(0, [appDelegate.music count] - 1)];
            [appDelegate.audioPlayer preparePlayer:enSCMusic andMP3File:m.bundleName andMP3Volume:ambientVolume andMP3Pan:ambientPan andNumberOfLoops:-1 delegate:self];
        }
		[self loadPlayer:cycle];
	}
	if (self.vPracticeScenery != nil) {
		[self.vPracticeScenery fadeInView:self];
		if (appDelegate.playerSettings.visualPrompts) {
			[self.vPracticeScenery showInfoOverlay:@"Inhale"];
			[self.vPracticeScenery showSubInfoOverlay:[NSString stringWithFormat:@"%4.1f seconds inhale",(CGFloat)appDelegate.playerSettings.breathSpanIn/1000.0f]];
		}
	}else if (self.vTubeGauge != nil) {
		self.vTubeGauge.liquidLevel = 0.0f;
		[self.vTubeGauge fadeInView:self];
	}else {
		[self startAnimatedPractice];
	}
	
	
}

-(void)initPracticeScenery:(NSString *) overlayFile{
	CGRect r = self.vPractice.frame;
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    ViewPracticeScenery *vp = [[ViewPracticeScenery alloc] initWithFrame:r visual:(Visual *)[appDelegate.visuals objectAtIndex:appDelegate.playerSettings.visual]];
	vp.backgroundColor = [UIColor blackColor];
	vp.alpha = 0.0f;
    vp.parentDelegate = self;
	[self.vPractice addSubview:vp];
    self.vPracticeScenery = vp;
    [vp release];
}

- (void)closePracticeScenery {
	if (self.vPracticeScenery != nil) {
		[self.vPracticeScenery removeFromSuperview];
		//[self.vPracticeScenery release];
		//self.vPracticeScenery = nil;
	}
}
- (void)startAnimatedPractice {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	if (appDelegate.audioPlayer != nil) {
		if (appDelegate.playerSettings.ambientMusicOn) {
			[appDelegate.audioPlayer play:enSCMusic];
		}
	}
	if (self.vPracticeScenery != nil) {
		[self.vPracticeScenery startSplashSlideShow:appDelegate.playerSettings.breathSpanIn exhaleLength:appDelegate.playerSettings.breathSpanOut fadeLength:kFadeFrames cycles:appDelegate.playerSettings.cycles];
	}
	animationInterval = 1.0f/kScenesFramesPerSecond; // 1/45 of a second
    
	newBreathSpanIn = appDelegate.playerSettings.breathSpanIn;
    newBreathSpanOut = appDelegate.playerSettings.breathSpanOut;
    speedState = enSpeedNone;
    
	timer =	[NSTimer scheduledTimerWithTimeInterval:animationInterval
											 target:self
										   selector:@selector(updatePractice:)
										   userInfo:nil
											repeats:YES];
}	

- (void)adjustSpeed:(BOOL)faster {
    if (breathInhaling) {
        newBreathSpanIn = newBreathSpanIn + (faster ? -25 : 25);
        newBreathSpanIn = (newBreathSpanIn < MINBREATHLENGTH ? MINBREATHLENGTH : newBreathSpanIn);
        newBreathSpanIn = (newBreathSpanIn > MAXBREATHLENGTH ? MAXBREATHLENGTH : newBreathSpanIn);
    } else {
        newBreathSpanOut = newBreathSpanOut + (faster ? -25 : 25);
        newBreathSpanOut = (newBreathSpanOut < MINBREATHLENGTH ? MINBREATHLENGTH : newBreathSpanOut);
        newBreathSpanOut = (newBreathSpanOut > MAXBREATHLENGTH ? MAXBREATHLENGTH : newBreathSpanOut);
    }
}


#pragma mark -
#pragma mark Tube Gauge Functions
- (void)initTubeGauge {
	if (self.vTubeGauge == nil) {
		CGFloat tubeWidth = self.vPractice.frame.size.width * TUBEWIDTHRATIO;
		if (self.vPractice.frame.size.height > self.vPractice.frame.size.width) {
			tubeWidth = self.vPractice.frame.size.height * TUBEWIDTHRATIO;
		}
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			tubeWidth = tubeWidth * 0.5f;
        }
		CGRect r = CGRectMake(5.0f, 5.0f, tubeWidth, self.vPractice.frame.size.height - 10.0f);
		ViewTubeGauge *vtg = [[ViewTubeGauge alloc] initWithFrame:r];
		vtg.alpha = 0.0f;
		[self.view addSubview:vtg];
		vtg.liquidLevel = 0.0f;
		self.vTubeGauge = vtg;
		[vtg release];
	}
}
- (void)closeTubeGauge {
	if (self.vTubeGauge != nil) {
		[self.vTubeGauge removeFromSuperview];
		//[vTubeGauge release];
		self.vTubeGauge = nil;
	}
}

- (void)stopPractice {
    self.bLeft.userInteractionEnabled = NO;
    self.bMiddle.userInteractionEnabled = NO;
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	if (timer != nil) {
		[timer invalidate];
		timer = nil;
	}
	if (self.vTubeGauge != nil) {
		[self.vTubeGauge fadeOutView];
	}
    if (self.vPracticeScenery != nil) {
        [self.vPracticeScenery stopSplashSlideShow];
        [self.vPracticeScenery fadeOutView];
    }
	
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate.audioPlayer stopAllButMusic];
    NSNumber *channel = [[NSNumber alloc] initWithInt:enSCMusic];
    if (appDelegate.playerSettings.audioPrompts || appDelegate.playerSettings.audioInstructions) {
        [appDelegate.audioPlayer fadeSlow:channel];
    } else {
        [appDelegate.audioPlayer fade:channel];
    }

	[appDelegate.audioPlayer preparePlayer:enSCAmbient andMP3File:@"f_PostStart" andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
	[appDelegate.audioPlayer play:enSCAmbient];
	
}


- (void)bBack: (id) sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bDone: (id) sender {
    NSString *controllerBundle = @"ViewVASController-iphone";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        controllerBundle = @"ViewVASController-ipad";
    }
    ViewVASController *anotherController = [[ViewVASController alloc] initWithNibName:controllerBundle bundle:nil];
    anotherController.title = @"Rate Stress";
    anotherController.vasState = 1;//Post VAS
    [self.navigationController pushViewController:anotherController animated:YES];
    [anotherController release];
}
- (void)bCancel_Click:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)bLeft_Click:(id)sender {
    switch (practiceState) {
        case enPracticeStateRunning:
            speedState = enSpeedUp;
            break;
        case enPracticeStatePaused:
            practiceState = enPracticeStateRunning;
            [self startPractice:1];//Start on cycle 1
            [self refreshButtons];
            break;
        default:
            break;
    }
}

- (IBAction)bMiddle_Click:(id)sender {
    switch (practiceState) {
        case enPracticeStateStopped:
            practiceState = enPracticeStateRunning;
            [self startPractice:1];//Start on cycle 1
            break;
        case enPracticeStateRunning:
            practiceState = enPracticeStatePaused;
            [self stopPractice];
            break;
        case enPracticeStatePaused:
            practiceState = enPracticeStateRunning;
            [self startPractice:cycle];//Start on cycle 1
            break;
        default:
            break;
    }
    [self refreshButtons];
}

- (IBAction)bRight_Click:(id)sender {
    switch (practiceState) {
        case enPracticeStateStopped:
            [self proceed];
            break;
        case enPracticeStateRunning:
            speedState = enSpeedDown;
            break;
        case enPracticeStatePaused:
            [self proceed];
            break;
        default:
            break;
    }
}

- (IBAction)bButton_Up:(id)sender {
    speedState = enSpeedNone;
}

- (void)refreshButtons {
    switch (practiceState) {
        case enPracticeStateRunning:
            [self.bLeft setTitle:@"Shorten Inhale" forState:UIControlStateNormal];
            self.bLeft.hidden = NO;
            [self.bMiddle setTitle:@"Pause" forState:UIControlStateNormal];
            [self.bRight setTitle:@"Lengthen Inhale" forState:UIControlStateNormal];
            self.bRight.hidden = NO;
            break;
        case enPracticeStatePaused:
            self.bLeft.hidden = NO;
            [self.bLeft setTitle:@"Restart" forState:UIControlStateNormal];
            [self.bMiddle setTitle:@"Resume" forState:UIControlStateNormal];
            self.bRight.hidden = NO;
            [self.bRight setTitle:@"Proceed" forState:UIControlStateNormal];
            break;
        case enPracticeStateStopped:
            self.bLeft.hidden = YES;
            [self.bLeft setTitle:@"Restart" forState:UIControlStateNormal];
            [self.bMiddle setTitle:@"Restart" forState:UIControlStateNormal];
            self.bRight.hidden = NO;
            [self.bRight setTitle:@"Proceed" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}

- (void)proceed {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.datalayer isAlreadySession:nil] || appDelegate.firstTime.skipVAS) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSString *controllerBundle = @"ViewVASController-iphone";
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            controllerBundle = @"ViewVASController-ipad";
        }
        ViewVASController *anotherController = [[ViewVASController alloc] initWithNibName:controllerBundle bundle:nil];
        anotherController.title = @"Rate Stress";
        anotherController.vasState = 1;//Post VAS
        [self.navigationController pushViewController:anotherController animated:YES];
        [anotherController release];
    }

}

- (void)loadPlayer:(int)cycleToPlay {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	if (newBreathSpanIn != appDelegate.playerSettings.breathSpanIn) {
		appDelegate.playerSettings.breathSpanIn = newBreathSpanIn;
	}
	if (newBreathSpanOut != appDelegate.playerSettings.breathSpanOut) {
		appDelegate.playerSettings.breathSpanOut = newBreathSpanOut;
	}
	audioPart = -1;
	for (int i = 0 ; i < enSCAmbient; i++) {
		startPos[i] = -1;
		hasPlayed[i] = NO;
	}
	startPos[0] = 0;
	switch (cycleToPlay) {
		case 1:
			inhaleTracks = 0;
			if (appDelegate.playerSettings.audioInstructions) {
				[appDelegate.audioPlayer preparePlayer:inhaleTracks andMP3File:@"f_in_deep_1" andMP3Volume:1.0f andMP3Pan:-1.0f andNumberOfLoops:0 delegate:self];
				if (appDelegate.playerSettings.breathSpanIn > 7100) {
					inhaleTracks++;
					[appDelegate.audioPlayer preparePlayer:inhaleTracks andMP3File:@"f_in_expand" andMP3Volume:1.0f andMP3Pan:-1.0f andNumberOfLoops:0 delegate:self];
				}
				exhaleTracks = inhaleTracks + 1;
				[appDelegate.audioPlayer preparePlayer:exhaleTracks andMP3File:@"f_out_slow_1" andMP3Volume:1.0f andMP3Pan:-1.0f andNumberOfLoops:0 delegate:self];
				if (appDelegate.playerSettings.breathSpanIn > 6000) {
					exhaleTracks++;
					[appDelegate.audioPlayer preparePlayer:exhaleTracks andMP3File:@"f_out_deflate" andMP3Volume:1.0f andMP3Pan:-1.0f andNumberOfLoops:0 delegate:self];
				}
				exhaleTracks++;
				[appDelegate.audioPlayer preparePlayer:exhaleTracks andMP3File:@"f_pause_naturally" andMP3Volume:1.0f andMP3Pan:-1.0f andNumberOfLoops:0 delegate:self];
				startPos[inhaleTracks+1] = 0;
				startPos[exhaleTracks] = appDelegate.playerSettings.breathSpanIn - 2000; // Play last track 2 seconds from end of 
			}else {
				[appDelegate.audioPlayer preparePlayer:0 andMP3File:@"f_in_deep_3" andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
				
				[appDelegate.audioPlayer preparePlayer:1 andMP3File:@"f_out_slow_3" andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
				[appDelegate.audioPlayer preparePlayer:2 andMP3File:@"f_relax_4" andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
				exhaleTracks = 2;
				startPos[inhaleTracks+1] = 0;
				startPos[2] = appDelegate.playerSettings.breathSpanOut - 1500.0f * ((CGFloat)appDelegate.playerSettings.breathSpanOut/(CGFloat)REFBREATHLENGTH);
			}
			break;
		case 2:
			inhaleTracks = 0;
			if (appDelegate.playerSettings.audioInstructions) {
				[appDelegate.audioPlayer preparePlayer:inhaleTracks andMP3File:@"f_in_deep_1" andMP3Volume:1.0f andMP3Pan:-1.0f andNumberOfLoops:0 delegate:self];
				if (appDelegate.playerSettings.breathSpanIn > 7100) {
					inhaleTracks++;
					[appDelegate.audioPlayer preparePlayer:inhaleTracks andMP3File:@"f_in_expand" andMP3Volume:1.0f andMP3Pan:-1.0f andNumberOfLoops:0 delegate:self];
				}
				exhaleTracks = inhaleTracks + 1;
				[appDelegate.audioPlayer preparePlayer:exhaleTracks andMP3File:@"f_out_slow_1" andMP3Volume:1.0f andMP3Pan:-1.0f andNumberOfLoops:0 delegate:self];
				if (appDelegate.playerSettings.breathSpanIn > 6000) {
					exhaleTracks++;
					[appDelegate.audioPlayer preparePlayer:exhaleTracks andMP3File:@"f_out_deflate" andMP3Volume:1.0f andMP3Pan:-1.0f andNumberOfLoops:0 delegate:self];
				}
				exhaleTracks++;
				[appDelegate.audioPlayer preparePlayer:exhaleTracks andMP3File:@"f_pause_naturally" andMP3Volume:1.0f andMP3Pan:-1.0f andNumberOfLoops:0 delegate:self];
				startPos[inhaleTracks+1] = 0;
				startPos[exhaleTracks] = appDelegate.playerSettings.breathSpanIn - 2000; // Play last track 2 seconds from end of 
			} else {
				[appDelegate.audioPlayer preparePlayer:0 andMP3File:@"f_in_deep_3" andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
				
				[appDelegate.audioPlayer preparePlayer:1 andMP3File:@"f_out_slow_3" andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
				[appDelegate.audioPlayer preparePlayer:2 andMP3File:@"f_relax_4" andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
				exhaleTracks = 2;
				startPos[inhaleTracks+1] = 0;
				startPos[2] = appDelegate.playerSettings.breathSpanOut - 1500.0 * ((CGFloat)appDelegate.playerSettings.breathSpanOut/(CGFloat)REFBREATHLENGTH);
			}
			break;
		default:
			inhaleTracks = 0;
			if (appDelegate.playerSettings.audioInstructions && appDelegate.playerSettings.breathSpanIn > 5000) {
				[appDelegate.audioPlayer preparePlayer:inhaleTracks andMP3File:[NSString stringWithFormat:@"f_in_deep_%d",((cycleToPlay - appDelegate.playerSettings.cycles/2 == 1) ? 3 : RANDOM_INT(1,4))] andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
			} else {
				[appDelegate.audioPlayer preparePlayer:inhaleTracks andMP3File:[NSString stringWithFormat:@"f_in_deep_%d",((cycleToPlay - appDelegate.playerSettings.cycles/2 == 1) ? 3 : RANDOM_INT(3,4))] andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
			}
			if (cycleToPlay <= (appDelegate.playerSettings.cycles /2)) { //First Half
				if (appDelegate.playerSettings.audioInstructions && cycleToPlay < 6 && appDelegate.playerSettings.breathSpanIn > 4000) {
					inhaleTracks++;
					[appDelegate.audioPlayer preparePlayer:1 andMP3File:@"f_think_number" andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
				}
				inhaleTracks++;
				[appDelegate.audioPlayer preparePlayer:inhaleTracks andMP3File:[NSString stringWithFormat:@"f_%d_1",cycleToPlay] andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
				if(!(appDelegate.playerSettings.audioInstructions && cycleToPlay < 6 && appDelegate.playerSettings.breathSpanIn > 4000)) {
					startPos[inhaleTracks] = 5500.0f * (CGFloat)appDelegate.playerSettings.breathSpanIn/(CGFloat)REFBREATHLENGTH;
				}
			}else {
				if (cycleToPlay - appDelegate.playerSettings.cycles/2 == 1) {
					inhaleTracks++;
					[appDelegate.audioPlayer preparePlayer:inhaleTracks andMP3File:@"f_count_backward" andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
				}
				inhaleTracks++;
				[appDelegate.audioPlayer preparePlayer:inhaleTracks andMP3File:[NSString stringWithFormat:@"f_%d_2",appDelegate.playerSettings.cycles-cycleToPlay+1 ] andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
				startPos[inhaleTracks] = 5500.0f * (CGFloat)appDelegate.playerSettings.breathSpanIn/(CGFloat)REFBREATHLENGTH;
			}
			startPos[inhaleTracks + 1] = 0;
			exhaleTracks = inhaleTracks + 1;
			if (appDelegate.playerSettings.audioInstructions && appDelegate.playerSettings.breathSpanOut > 5000) {
				[appDelegate.audioPlayer preparePlayer:exhaleTracks andMP3File:[NSString stringWithFormat:@"f_out_slow_%d",RANDOM_INT(1,4) ] andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
			} else {
				[appDelegate.audioPlayer preparePlayer:exhaleTracks andMP3File:[NSString stringWithFormat:@"f_out_slow_%d",RANDOM_INT(3,4) ] andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
			}
			
			exhaleTracks++;
			if (appDelegate.playerSettings.audioInstructions && appDelegate.playerSettings.breathSpanOut > 5000) {
				[appDelegate.audioPlayer preparePlayer:exhaleTracks andMP3File:[NSString stringWithFormat:@"f_relax_%d",RANDOM_INT(1,4) ] andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
			} else {
				[appDelegate.audioPlayer preparePlayer:exhaleTracks andMP3File:[NSString stringWithFormat:@"f_relax_%d",RANDOM_INT(3,4) ] andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:self];
			}
			
			startPos[exhaleTracks] = (CGFloat)RANDOM_INT(4500,6500) * (CGFloat)appDelegate.playerSettings.breathSpanOut/(CGFloat)REFBREATHLENGTH ;
			break;
			
	}
	
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	if (flag == YES) {
		if ((breathInhaling && audioPart < inhaleTracks) || ((!breathInhaling) && audioPart < exhaleTracks) ) {
			if (startPos[audioPart+1] <= breathPosition) {
				if (!hasPlayed[audioPart+1]) {
					[appDelegate.audioPlayer play:audioPart+1];
				}
				hasPlayed[audioPart+1]=YES;
				audioPart++;
			}
		}
	}
}

- (void)updatePractice:(NSTimer *)theTimer {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	BOOL extendTime = NO;
	int i;
    if (speedState != enSpeedNone) {
        switch (speedState) {
            case enSpeedUp:
                [self adjustSpeed:YES];
                break;
            case enSpeedDown:
                [self adjustSpeed:NO];
                break;
            default:
                break;
        }
        if (newBreathSpanIn != appDelegate.playerSettings.breathSpanIn) {
            appDelegate.playerSettings.breathSpanIn = newBreathSpanIn;
            if (self.vPracticeScenery != nil) {
                [self.vPracticeScenery showSubInfoOverlay:[NSString stringWithFormat:@"%5.2f sec inhale",(CGFloat)newBreathSpanIn/1000.0f]];
            }
        }
        if (newBreathSpanOut != appDelegate.playerSettings.breathSpanOut) {
            appDelegate.playerSettings.breathSpanOut = newBreathSpanOut;
            if (self.vPracticeScenery != nil) {
                [self.vPracticeScenery showSubInfoOverlay:[NSString stringWithFormat:@"%5.2f sec exhale",(CGFloat)newBreathSpanOut/1000.0f]];
            }
        }

    }
	if ((breathInhaling && breathPosition >appDelegate.playerSettings.breathSpanIn)||(!breathInhaling && breathPosition > appDelegate.playerSettings.breathSpanOut)) {
		for (i = enSCIn; i <= enSCPause; i++) {
			if ([appDelegate.audioPlayer isPlaying:i]) {
				extendTime = YES;
			}
		}
		if (extendTime) {
			if (appDelegate.playerSettings.visualPrompts) {
				[self.vPracticeScenery showSubInfoOverlay:@"Cycle Extended By Voice"];
			}
		} else {
			breathInhaling = !breathInhaling;
            if (breathInhaling) {
                [self.bLeft setTitle:@"Shorten Inhale" forState:UIControlStateNormal];
                [self.bRight setTitle:@"Lengthen Inhale" forState:UIControlStateNormal];
            } else {
                [self.bLeft setTitle:@"Shorten Exhale" forState:UIControlStateNormal];
                [self.bRight setTitle:@"Lengthen Exhale" forState:UIControlStateNormal];
            }
			breathPosition = 0;
			if (appDelegate.playerSettings.visualPrompts) {
                if (breathInhaling) {
                    [self.vPracticeScenery showInfoOverlay:@"Inhale"];
                    [self.vPracticeScenery showSubInfoOverlay:[NSString stringWithFormat:@"%5.2f seconds inhale",(CGFloat)appDelegate.playerSettings.breathSpanIn/1000.0f]];
                } else {
                    [self.vPracticeScenery showInfoOverlay:@"Exhale"];
                    [self.vPracticeScenery showSubInfoOverlay:[NSString stringWithFormat:@"%5.2f seconds exhale",(CGFloat)appDelegate.playerSettings.breathSpanOut/1000.0f]];
                }
			}
			if (breathInhaling) {
				cycle++;
                [appDelegate.datalayer saveSetting:@"breathSpanIn" andValue:[NSString stringWithFormat:@"%d",appDelegate.playerSettings.breathSpanIn]];
				if (appDelegate.audioPlayer != nil && cycle <= appDelegate.playerSettings.cycles) {
					[self loadPlayer:cycle];
				}
                if (newBreathSpanIn != appDelegate.playerSettings.breathSpanIn) {
                    appDelegate.playerSettings.breathSpanIn = newBreathSpanIn;
                    [appDelegate.datalayer saveSetting:@"breathSpanIn" andValue:[NSString stringWithFormat:@"%d",appDelegate.playerSettings.breathSpanIn]];
                }
			} else {
                if (newBreathSpanOut != appDelegate.playerSettings.breathSpanOut) {
                    appDelegate.playerSettings.breathSpanOut = newBreathSpanOut;
                    [appDelegate.datalayer saveSetting:@"breathSpanOut" andValue:[NSString stringWithFormat:@"%d",appDelegate.playerSettings.breathSpanOut]];
                }
            }
		}
		
	}
	if (cycle <= appDelegate.playerSettings.cycles) {
		breathPosition = breathPosition + (int)(animationInterval * 1000.0f);
		if (appDelegate.audioPlayer != nil && appDelegate.playerSettings.audioPrompts) {
			if (startPos[audioPart+1] >= 0) { 
				if (!(hasPlayed[audioPart+1] || [appDelegate.audioPlayer isPlaying:audioPart])) { 
					if (breathPosition >= startPos[audioPart+1]) {
						if ( (breathInhaling && audioPart+1 <= inhaleTracks) || (!breathInhaling && audioPart+1 > inhaleTracks) ) { 
							[appDelegate.audioPlayer play:audioPart+1];
							hasPlayed[audioPart+1] = YES;
							audioPart += 1;
						}
					}
				}
			}
		}
        
		if (self.vPracticeScenery != nil) {
			if (breathInhaling && 250 >= abs(appDelegate.playerSettings.breathSpanIn/2 - breathPosition) && appDelegate.playerSettings.visualPrompts) {
				if (cycle > appDelegate.playerSettings.cycles/2 && appDelegate.playerSettings.visualPrompts) {
					[self.vPracticeScenery showSubInfoOverlay:[NSString stringWithFormat:@"%d Cycles Left",appDelegate.playerSettings.cycles - cycle + 1]];
				} else {
					[self.vPracticeScenery showSubInfoOverlay:[NSString stringWithFormat:@"Cycle %d of %d",cycle, appDelegate.playerSettings.cycles]];
				}
				
			}
            /*********************************************************
             *              MOVE AND FADE SCREENS
             *********************************************************/
            [self.vPracticeScenery updateScreen:breathPosition displayLengthIn:appDelegate.playerSettings.breathSpanIn displayLengthOut:appDelegate.playerSettings.breathSpanOut cycle:cycle zoomIn:breathInhaling];
		}
		if (self.vTubeGauge != nil) {
			if (breathInhaling) {
				self.vTubeGauge.liquidLevel = (CGFloat) breathPosition / (CGFloat)appDelegate.playerSettings.breathSpanIn;
			}else{
				self.vTubeGauge.liquidLevel = ((CGFloat)appDelegate.playerSettings.breathSpanOut - (CGFloat)breathPosition) / (CGFloat)appDelegate.playerSettings.breathSpanOut;
			}
		}
		
		
		
	}else {
		//[self flurryEndBreathing:@"Complete"];
        practiceState = enPracticeStateStopped;
        [self stopPractice];
        [self refreshButtons];
	}
	
}

#pragma mark -
#pragma mark Controller Animation Cycle
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if ((animationID == @"fadeOutViewPracticeScenery")/* && finished*/) {  
		[self closePracticeScenery];
        self.bLeft.userInteractionEnabled = YES;
        self.bMiddle.userInteractionEnabled = YES;
	}
	if ((animationID == @"fadeInViewPracticeScenery")/* && finished*/) {  
		if (self.vTubeGauge != nil) {
			self.vTubeGauge.liquidLevel = 0.0f;
			[self.vTubeGauge updateLiquidLevel];
			[self.vTubeGauge fadeInView:self];
		}else {
			[self startAnimatedPractice];
		}
	}
	if ((animationID == @"fadeOutViewTubeGauge")/* && finished*/) {  
		if (self.vPracticeScenery != nil) {
			[self.vPracticeScenery fadeOutView];
		}
		[self closeTubeGauge];
	}
	if ((animationID == @"fadeInViewTubeGauge")/* && finished*/) {
		[self startAnimatedPractice];
	}
	if ((animationID == @"fadeInLabel")/* && finished*/) {
		[self fadeOutLabel];
	}
	if ((animationID == @"fadeOutLabel")/* && finished*/) {
	}
    
    
}	
- (void)fadeInLabel {		//Animate Fade In
	[UIView beginAnimations:@"fadeInLabel" context:nil];
	[UIView setAnimationDuration:5.0f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.lStart.alpha = 1.0f;
	[UIView commitAnimations];
}

- (void)fadeOutLabel {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutLabel" context:nil];
	[UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.lStart.alpha = 0.0f;
	[UIView commitAnimations];
}


@end
