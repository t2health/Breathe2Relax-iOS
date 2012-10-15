//
//  ViewSettingBreath.m
//  iBreath160
//
//  Created by Roger Reeder on 1/26/11.
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
#import "ViewSettingBreath.h"
#import "PlayerSettings.h"
#import "B2RAppDelegate.h"
#import "Analytics.h"

@implementation ViewSettingBreath

@synthesize lTime;
@synthesize breathInflate;
@synthesize lLastTime;
@synthesize lMoveTime;
@synthesize bBreathe;
@synthesize imgBall;
@synthesize vDialog;
@synthesize bSave;
@synthesize bCancel;
@synthesize lDialogMessage;
@synthesize lInstructions;
@synthesize settings;
@synthesize inhaling;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//TODO: Could these values be set in the XIB?
	self.lTime.alpha = 1.0f;
	self.lLastTime.alpha = 1.0f;
	self.lMoveTime.alpha = 0.0f;
	self.lLastTime.text = [NSString stringWithFormat:@"%4.1f sec", (float)breathInflate/1000.0f];
	breathDeflate = 0;
	tempBreath = -1;
	ballCenter = CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f);
	self.imgBall.alpha = 0.0f;
    ballWidth = self.view.frame.size.width;
    if (self.view.frame.size.height < ballWidth) {
        ballWidth = self.view.frame.size.height;
    }
    ballWidth = ballWidth * 0.8f;
	breathes = 0;
	longestBreath = 0;
	shortestBreath = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		self.lInstructions.font	 = [self.lInstructions.font fontWithSize:32];
		self.lDialogMessage.font	 = [self.lInstructions.font fontWithSize:32];
    }
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.inhaling) {
        self.lInstructions.text =[appDelegate getAppSetting:@"Comments" withKey:@"inhaleBreath"];
    } else {
        self.lInstructions.text =[appDelegate getAppSetting:@"Comments" withKey:@"exhaleBreath"];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    ballCenter = CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f);
	self.imgBall.alpha = 0.0f;
    ballWidth = self.view.frame.size.width;
    if (self.view.frame.size.height < ballWidth) {
        ballWidth = self.view.frame.size.height;
    }
    //ballWidth = ballWidth * 0.8f;

}
- (void)viewDidAppear:(BOOL)animated {
    [Analytics logEvent:[NSString stringWithFormat:@"SETTING %@ VIEW",self.inhaling ? @"INHALE" : @"EXHALE"]];

    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.inhaling) {
        if ([appDelegate.firstTime showGuideForPosition:enAppPositionSetupInhale]) {
            [appDelegate showInfo:[appDelegate.firstTime getGuideTitleForPosition:enAppPositionSetupInhale] 
                         withInfo:[appDelegate.firstTime getGuideDetailForPosition:enAppPositionSetupInhale] 
                    containerView:self.view appPosition:enAppPositionSetupInhale];
        }
    } else {
        if ([appDelegate.firstTime showGuideForPosition:enAppPositionSetupExhale]) {
            [appDelegate showInfo:[appDelegate.firstTime getGuideTitleForPosition:enAppPositionSetupExhale] 
                         withInfo:[appDelegate.firstTime getGuideDetailForPosition:enAppPositionSetupExhale] 
                    containerView:self.view appPosition:enAppPositionSetupExhale];
        }
    }
    
}

-(void)countUp {
	tempBreath += 100;
	self.lTime.text = [NSString stringWithFormat:@"%4.1f sec", (float)tempBreath/1000.0f];
	
}

-(void)countDown {
	tempBreath -= 100;
	self.lTime.text = [NSString stringWithFormat:@"%4.1f sec", (float)tempBreath/1000.0f];
	if (tempBreath <= 0) {
		if (timer != NULL) {
			[timer invalidate];
			timer = NULL;
		}
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)bBreathe_TouchUp:(id)sender {
	//[self fadeOutTime];
	int tag = ((UIButton *)sender).tag;
    
	switch (tag) {
		case 0:
			if (tempBreath >= 200) {
                if (self.inhaling) {
                    self.settings.breathSpanIn = breathInflate;
                } else {
                    self.settings.breathSpanOut = breathInflate;
                }
				[self.navigationController popViewControllerAnimated:TRUE];
			}
			vDialog.hidden = YES;
			break;
		case 1:
			if (tempBreath >= 0) {
				breathes = 0;
				self.imgBall.alpha = 0.0f;
				shortestBreath = 0;
				longestBreath = 0;
				self.vDialog.hidden = YES;
                [self fadeInInstructions];
				self.vDialog.alpha = 0.0f;
			}else {
				[self.navigationController popViewControllerAnimated:TRUE];
			}
			break;
		case 2:
			if (timer != NULL) {
				[timer invalidate];
				timer = NULL;
			}
            breathInflate = tempBreath;
			[self slideUpTime];
            if (tempBreath >= 200) {
                if (self.inhaling) {
                    //[self contractBall];
                    self.lDialogMessage.text = [NSString stringWithFormat:@"%4.1f second inhale. If this was comfortably long enough then press save, otherwise you can retry.",(CGFloat)breathInflate/1000.0f];
                } else {
                    //[self expandBall];
                    self.lDialogMessage.text = [NSString stringWithFormat:@"%4.1f second exhale. If this exhale was comfortably long enough then press save, othewise you can retry.",(CGFloat)breathInflate/1000.0f];
                }
                [self.bSave setTitle:@"Save" forState:UIControlStateNormal];
                [self.bCancel setTitle:@"Retry" forState:UIControlStateNormal];
                self.bSave.hidden = NO;
            } else {
                if (self.inhaling) {
                    self.lDialogMessage.text = @"PRESS AND HOLD the button the entire time you are inhaling, go ahead and try again.";
                } else {
                    self.lDialogMessage.text = @"PRESS AND HOLD the button the entire time you are exhaling, go ahead and try again.";
                }
                self.bSave.hidden = YES;
                [self.bCancel setTitle:@"Try Again" forState:UIControlStateNormal];
                tempBreath = 0;
            }
            self.vDialog.alpha = 1.0f;
            self.vDialog.hidden = NO;
			break;
		default:
			break;
	}
    /* OLD METHOD
	switch (tag) {
		case 0:
			if (breathes > 0) {
				self.settings.breathSpanIn = breathInflate;
                self.settings.breathSpanOut = breathInflate;
				[self.navigationController popViewControllerAnimated:TRUE];
			}
			vDialog.hidden = YES;
			break;
		case 1:
			if (breathes > 0) {
				breathes = 0;
				self.imgBall.alpha = 0.0f;
				shortestBreath = 0;
				longestBreath = 0;
				self.vDialog.hidden = YES;
				self.vDialog.alpha = 0.0f;
			}else {
				[self.navigationController popViewControllerAnimated:TRUE];
			}
			break;
		case 2:
			if (tempBreath > 4000) {
				inhaleTimes[breathes] = tempBreath;
				if (longestBreath < tempBreath) {
					longestBreath = tempBreath;
				}
				if (shortestBreath == 0 || shortestBreath > tempBreath) {
					shortestBreath = tempBreath;
				}
				breathes++;
			}
			breathInflate = tempBreath;
			[self slideUpTime];
			[self contractBall];
			if (timer != NULL) {
				[timer invalidate];
				timer = NULL;
			}
			timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/10.0) target:self selector:@selector(countDown) userInfo:nil repeats:YES];
			if (breathes >= 5) {
				int sumOfTime = 0;
				for (int i = 0; i < 5; i++) {
					if (inhaleTimes[i] < longestBreath && inhaleTimes[i] > shortestBreath) {
						sumOfTime += inhaleTimes[i];
					}
				}
				breathInflate = sumOfTime/3;
				self.lDialogMessage.text = [NSString stringWithFormat:@"Your shortest breath was %4.1f seconds. The longest was %4.1f seconds. The average of the middle three was %4.1f seconds. To save this press the save button.",(CGFloat)shortestBreath/1000.0f,(CGFloat)longestBreath/1000.0f,(CGFloat)breathInflate/1000.0f];
				self.bSave.titleLabel.text = @"Save";
				self.bCancel.titleLabel.text = @"Retry";
				self.vDialog.alpha = 1.0f;
				self.vDialog.hidden = NO;
			}
			break;
		default:
			break;
	}
     */
}

- (void)bBreathe_Down:(id)sender{
	if (timer != NULL) {
		[timer invalidate];
		timer = NULL;
	}
	self.imgBall.alpha = 1.0f;
	[self fadeOutInstructions];
    if (self.inhaling) {
        [self expandBall];
        tempBreath = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/10.0) target:self selector:@selector(countUp) userInfo:nil repeats:YES];
    } else {
        [self contractBall];
        tempBreath = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/10.0) target:self selector:@selector(countUp) userInfo:nil repeats:YES];
    }
}


#pragma mark -
#pragma mark Controller Animation Cycle
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if ((animationID == @"slideUpTime")/* && finished*/) {  
		self.lLastTime.text = lMoveTime.text;
		self.lLastTime.alpha = 1.0f;
		self.lMoveTime.alpha = 0.0f;
		[self.lMoveTime setCenter:self.lTime.center];
	}
}	
- (void)slideUpTime {		//Animate Fade Out
	self.lMoveTime.text = lTime.text;
	self.lMoveTime.alpha = 1.0f;
	[UIView beginAnimations:@"slideUpTime" context:nil];
	[UIView setAnimationDuration:0.50f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	[self.lMoveTime setCenter:lLastTime.center];
	self.lLastTime.alpha = 0.0f;
	[UIView commitAnimations];
}


- (void)fadeOutInstructions {		//Animate Fade Out
	[UIView beginAnimations:@"fadeOutInstructions" context:nil];
	[UIView setAnimationDuration:0.25f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.lInstructions.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)fadeInInstructions {		//Animate Fade Out
	[UIView beginAnimations:@"fadeInInstructions" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.lInstructions.alpha = 1.0f;
	[UIView commitAnimations];
}


- (void) expandBall {
    CGFloat duration = 12.0f;
    
    CGRect originalFrame = CGRectMake(ballCenter.x - ballWidth/2.0f, ballCenter.y - ballWidth/2.0f, ballWidth, ballWidth);
    
    CGFloat newWidth = ballWidth / 3.0f;
    CGRect newFrame = CGRectMake(ballCenter.x - newWidth/2.0f, ballCenter.y-newWidth/2.0f, newWidth, newWidth);
    
    [self.imgBall setFrame:newFrame];
	[UIView beginAnimations:@"expand ball" context:nil];
    [UIView setAnimationDuration:duration];
	//[UIView setAnimationBeginsFromCurrentState:TRUE];
	[self.imgBall setFrame:originalFrame];
	[UIView commitAnimations];
}

- (void) contractBall {
	//CGFloat duration = (CGFloat)tempBreath/1000.0f;
    CGFloat duration = 12.0f;
    
    CGRect originalFrame = CGRectMake(ballCenter.x - ballWidth/2.0f, ballCenter.y - ballWidth/2.0f, ballWidth, ballWidth);
    
    CGFloat newWidth = ballWidth / 3.0f;
    CGRect newFrame = CGRectMake(ballCenter.x - newWidth/2.0f, ballCenter.y-newWidth/2.0f, newWidth, newWidth);
    
    [self.imgBall setFrame:originalFrame];
	[UIView beginAnimations: @"contract ball" context: nil];
    [UIView setAnimationDuration: duration];
	//[UIView setAnimationBeginsFromCurrentState: TRUE];
	[self.imgBall setFrame: newFrame];
	[UIView commitAnimations];
}


- (void)saveEdit: (id) sender {
}


- (void)bSave_click: (id) sender {
    if (self.settings) {
        self.settings.breathSpanIn = (CGFloat)breathInflate/10.0f;
        self.settings.breathSpanOut = (CGFloat)breathInflate/10.0f;
    }
	[self.navigationController popViewControllerAnimated:TRUE];
}

- (void)bCancel_click: (id) sender {
	[self.navigationController popViewControllerAnimated:TRUE];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
