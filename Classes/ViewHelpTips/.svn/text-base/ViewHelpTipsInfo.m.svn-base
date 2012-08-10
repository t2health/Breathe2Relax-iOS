//
//  ViewHelpTipsInfo.m
//  Breathe2Relax
//
//  Created by Roger Reeder on 9/24/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import "ViewHelpTipsInfo.h"

#import "B2RAppDelegate.h"

@implementation ViewHelpTipsInfo
@synthesize checkShowAgain;
@synthesize appPosition;
@synthesize tipString;
@synthesize playFile;

const CGFloat HelpInfoBoxBHeight = 27.0f;
const CGFloat HelpInfoBoxBLWidth = 27.0f;
const CGFloat HelpInfoBoxBRWidth = 27.0f;
const CGFloat HelpInfoBoxCLWidth = 11.0f;
const CGFloat HelpInfoBoxMLWidth = 16.0f;
const CGFloat HelpInfoBoxMRWidth = 20.0f;
const CGFloat HelpInfoBoxTHeight = 27.0f;
const CGFloat HelpInfoBoxTLWidth = 27.0f;
const CGFloat HelpInfoBoxTRWidth = 27.0f;
const CGFloat HELPBUTTONASPECT = (80.0f/28.0f);
const CGFloat CHECKBOXASPECT = (232.0f/39.0f);


@synthesize sURL, sTitle, sText;

- (id)initWithFrame:(CGRect)frame withToggle:(BOOL)toggle {
    if ((self = [super initWithFrame:frame])) {
		[self initDisplay:toggle];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Layout Funtions
- (void)initDisplay:(bool)toggle {
	CGFloat x,y,w,h;
	CGFloat bHeight, bWidth, bPadding;
	bPadding = 10.0f;
	
	
	CGFloat xScale = 0.75f;
	CGFloat yScale = 0.75f;
	if (self.frame.size.width > 480.0f || self.frame.size.width > 480.0f) {
		bHeight = 40;
		bWidth = bHeight * HELPBUTTONASPECT;
		if (self.frame.size.width > self.frame.size.height) {//landscape
			xScale = 0.6f;
			yScale = 0.9f;
		}else {
			xScale = 0.95;
			yScale = 0.6f;
		}
		
	}else {
		bHeight = 24;
		bWidth = bHeight * HELPBUTTONASPECT;
		if (self.frame.size.width > self.frame.size.height) {//landscape
			xScale = 0.95f;
			yScale = 0.95f;
		}else {
			xScale = 0.95f;
			yScale = 0.95f;
		}
	}
	
	w = self.frame.size.width *xScale;
	h = self.frame.size.height * yScale;
	x = (self.frame.size.width - w) * 0.5f;
	y = (self.frame.size.height - h) * 0.5f;
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	v.backgroundColor = [UIColor clearColor];
	[self addSubview:v];
	vContainer = v;
	[v release];
	
	CGRect r = vContainer.frame;
	x = 0.0f;
	y = 0.0f;
	w = HelpInfoBoxTLWidth;
	h = HelpInfoBoxTLWidth;
	UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	[iv setImage:[UIImage imageNamed:@"HelpInfoBoxTL.png"]];
	[vContainer addSubview:iv];
	ivBoxTL = iv;
	[iv release];
	
	x = x + w;
	w = r.size.width - HelpInfoBoxTLWidth - HelpInfoBoxTRWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	[iv setImage:[UIImage imageNamed:@"HelpInfoBoxT.png"]];
	[vContainer addSubview:iv];
	ivBoxT = iv;
	[iv release];
	
	x = x + w;
	w = HelpInfoBoxTRWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	[iv setImage:[UIImage imageNamed:@"HelpInfoBoxTR.png"]];
	[vContainer addSubview:iv];
	ivBoxTR = iv;
	[iv release];
	
	
	x = 0.0f;
	y = HelpInfoBoxTLWidth;
	w = HelpInfoBoxMLWidth;
	h = r.size.height - HelpInfoBoxTLWidth - HelpInfoBoxBLWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	[iv setImage:[UIImage imageNamed:@"HelpInfoBoxML.png"]];
	[vContainer addSubview:iv];
	ivBoxML = iv;
	[iv release];
	
	x = x + w;
	w = HelpInfoBoxCLWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	[iv setImage:[UIImage imageNamed:@"HelpInfoBoxCL.png"]];
	[vContainer addSubview:iv];
	ivBoxCL	= iv;
	[iv release];
	
	
	x = x + w;
	w = r.size.width - HelpInfoBoxMLWidth - HelpInfoBoxMRWidth - HelpInfoBoxCLWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	[iv setImage:[UIImage imageNamed:@"HelpInfoBoxC.png"]];
	[vContainer addSubview:iv];
	ivBoxC= iv;
	[iv release];
	
	x = x + w;
	w = HelpInfoBoxMRWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	[iv setImage:[UIImage imageNamed:@"HelpInfoBoxMR.png"]];
	[vContainer addSubview:iv];
	ivBoxMR	= iv;
	[iv release];
	
	x = 0.0f;
	y = y + h;
	w = HelpInfoBoxBLWidth;
	h = HelpInfoBoxBLWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	[iv setImage:[UIImage imageNamed:@"HelpInfoBoxBL.png"]];
	[vContainer addSubview:iv];
	ivBoxBL = iv;
	[iv release];
	
	x = x + w;
	w = r.size.width - HelpInfoBoxBLWidth - HelpInfoBoxBRWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	[iv setImage:[UIImage imageNamed:@"HelpInfoBoxB.png"]];
	[vContainer addSubview:iv];
	ivBoxB = iv;
	[iv release];
	
	x = x + w;
	w = HelpInfoBoxBRWidth;
	iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	[iv setImage:[UIImage imageNamed:@"HelpInfoBoxBR.png"]];
	[vContainer addSubview:iv];
	ivBoxBR = iv;
	[iv release];
	
	x = HelpInfoBoxMLWidth;
	y = HelpInfoBoxTLWidth;
	w = r.size.width - HelpInfoBoxMLWidth - HelpInfoBoxMRWidth;
	h = r.size.height - HelpInfoBoxTLWidth;
	
	v = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
	v.backgroundColor = [UIColor clearColor];
	[vContainer addSubview:v];
	vDialog = v;
	[v release];
	
	UIFont *flblTitle =	[UIFont fontWithName:@"Helvetica" size:bHeight * 0.88f];
	UILabel *lbl = [[UILabel new] initWithFrame:CGRectMake(bPadding, bPadding, vDialog.frame.size.width - 2.0f * bPadding, bHeight)];
	lbl.numberOfLines = 1;
	lbl.font = flblTitle;
	[lbl setTextAlignment:UITextAlignmentLeft];
	[lbl setLineBreakMode:UILineBreakModeClip];
	lbl.text = @"Title";
	[lbl setTextColor:[UIColor whiteColor]];
	[lbl setShadowColor:[UIColor blackColor]];
	[lbl setShadowOffset:CGSizeMake(1.0f, 1.0f)];
	[lbl setBackgroundColor:[UIColor clearColor]];
	[lbl setAlpha:1.0f];
	[vDialog addSubview:lbl];
	lblTitle = lbl;
	[lbl release];
	
	r = vDialog.frame;
	UIWebView *web = [[UIWebView alloc]  initWithFrame:r];
	[web setBackgroundColor:[UIColor clearColor]];
	[web setOpaque:NO];
	wvInfo = web;
	[vDialog addSubview:wvInfo];
	[web release];
	
	iv = [[UIImageView alloc]  initWithFrame:CGRectMake(0.0f, r.size.height - 50.0f, r.size.width, 50.0f)];
	[iv setImage:[UIImage imageNamed:@"bottomshader.png"]];
	[vDialog addSubview:iv];
	ivShaderB = iv;
	[iv release];

	
	UIButton *b = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[b setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"menuButton.png"]]  forState:UIControlStateNormal];
	[b setFrame:CGRectMake((vDialog.frame.size.width - bWidth) / 2.0f, vDialog.frame.size.height - bHeight, bWidth, bHeight)];
	b.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:bHeight * 0.7f];
	[b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[b setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
	[b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[b setTitleShadowColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	[b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	[b setTitleShadowColor:[UIColor grayColor] forState:UIControlStateSelected];
	b.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[b setTitle:@"Close" forState:UIControlStateNormal];
	[b setTitle:@"Close" forState:UIControlStateHighlighted];
	[b setTitle:@"Close" forState:UIControlStateSelected];
	[vDialog addSubview:b];
	b.userInteractionEnabled = NO;
	[b addTarget:self action:@selector(closeButton_TouchDown:) forControlEvents:UIControlEventTouchDown];
	bClose = b;
	[b release];
	
	
	ViewCheckboxController *chk = [[ViewCheckboxController alloc] initWithNibName:@"ViewCheckboxController" bundle:nil];
	[chk.view setFrame:CGRectMake(0.0f, vDialog.frame.size.height - bHeight * 2.0f, bHeight * CHECKBOXASPECT, bHeight)];
	chk.view.hidden = !toggle; 
	[vDialog addSubview:chk.view];
	self.checkShowAgain = chk;
	[chk release];
	//[self updateLayout:self.frame];
	self.hidden = YES;
}

- (void)updateLayout:(CGRect)frame {
	[self setFrame:frame];
	CGFloat x,y,w,h;
	CGFloat bHeight, bWidth, bPadding;
	bPadding = 10.0f;
	
	CGFloat xScale = 0.75f;
	CGFloat yScale = 0.75f;
	if (frame.size.width > 480.0f || frame.size.width > 480.0f) {
		bHeight =  35.0f;
		bWidth = bHeight * HELPBUTTONASPECT;
		if (frame.size.width > frame.size.height) {//landscape
			xScale = 0.8f;
			yScale = 0.9f;
		}else {
			xScale = 0.95;
			yScale = 0.8f;
		}

	}else {
		bHeight =  25;
		bWidth = bHeight * HELPBUTTONASPECT;
		if (frame.size.width > frame.size.height) {//landscape
			xScale = 0.95f;
			yScale = 0.95f;
		}else {
			xScale = 0.95f;
			yScale = 0.95f;
		}
	}

	w = (frame.size.width * xScale);
	h = (frame.size.height * yScale) ;
	x = (frame.size.width - w) * 0.5f;
	y = (frame.size.height - h) * 0.5f;
	
	[vContainer setFrame:CGRectMake(x, y, w, h)];

	x = HelpInfoBoxMLWidth;
	y = HelpInfoBoxTLWidth;
	w = w - (HelpInfoBoxMLWidth * 2.0f);
	h = h - (HelpInfoBoxTLWidth * 2.0f);
	[vDialog setFrame:CGRectMake(x, y, w, h)];
	
	x = 0.0f;
	y = 0.0f;
	w = HelpInfoBoxTLWidth;
	h = HelpInfoBoxTLWidth;
	[ivBoxTL setFrame:CGRectMake(x, y, w, h)];
	
	x = x + w;
	w = vContainer.frame.size.width - HelpInfoBoxTLWidth - HelpInfoBoxTRWidth;
	[ivBoxT setFrame:CGRectMake(x, y, w, h)];
	
	x = x + w;
	w = HelpInfoBoxTRWidth;
	[ivBoxTR setFrame:CGRectMake(x, y, w, h)];
	
	
	x = 0.0f;
	y = HelpInfoBoxTLWidth;
	w = HelpInfoBoxMLWidth;
	h = vContainer.frame.size.height - HelpInfoBoxTLWidth - HelpInfoBoxBLWidth;
	[ivBoxML setFrame:CGRectMake(x, y, w, h)];
	
	x = x + w;
	w = HelpInfoBoxCLWidth;
	[ivBoxCL setFrame:CGRectMake(x, y, w, h)];
	
	
	x = x + w;
	w = vContainer.frame.size.width - HelpInfoBoxMLWidth - HelpInfoBoxMRWidth - HelpInfoBoxCLWidth;
	[ivBoxC setFrame:CGRectMake(x, y, w, h)];
	
	x = x + w;
	w = HelpInfoBoxMRWidth;
	[ivBoxMR setFrame:CGRectMake(x, y, w, h)];
	
	x = 0.0f;
	y = y + h;
	w = HelpInfoBoxBLWidth;
	h = HelpInfoBoxBLWidth;
	[ivBoxBL setFrame:CGRectMake(x, y, w, h)];
	
	x = x + w;
	w = vContainer.frame.size.width - HelpInfoBoxBLWidth - HelpInfoBoxBRWidth;
	[ivBoxB setFrame:CGRectMake(x, y, w, h)];
	
	x = x + w;
	w = HelpInfoBoxBRWidth;
	[ivBoxBR setFrame:CGRectMake(x, y, w, h)];
	
	x = bPadding;
	y = bPadding;
	w = vDialog.frame.size.width - (bPadding * 2.0f);
	h = bHeight;
	[lblTitle setFrame:CGRectMake(x, y, w, h)];
	
	x = bPadding;
	y = bPadding + bHeight;
	w = vDialog.frame.size.width - bPadding * 2.0f;
	h = vDialog.frame.size.height - bPadding * 2.0f - bHeight;
	[wvInfo setFrame:CGRectMake(x, y, w, h - bClose.frame.size.height)];
	
	x = 0.0f;
	y = vDialog.frame.size.height - 50.0f;
	w = vDialog.frame.size.width;
	h = 50.0f;
	[ivShaderB setFrame:CGRectMake(x, y, w, h)];
	
	w = bClose.frame.size.width;
	h = bClose.frame.size.height;
	x =  (vDialog.frame.size.width - bWidth - bPadding * 2.0f);
	y = vDialog.frame.size.height - h;
	[bClose setFrame:CGRectMake(x,y,w,h)];
	w = vDialog.frame.size.width;
	CGRect rect = CGRectMake(0.0f, y, w - 2 * bPadding - bWidth , h);
	self.checkShowAgain.view.frame = rect;
    CGFloat fontSize = 16.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        fontSize = 32.0f;
    }
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        fontSize = fontSize * 0.6f;
    }
    [self.checkShowAgain.bDescription.titleLabel setFont:[self.checkShowAgain.checkboxButton.titleLabel.font fontWithSize:fontSize]];
	
	[self reloadString];
	
}


- (void)closeButton_TouchDown:(id)sender {
	if (self.appPosition) {
        B2RAppDelegate * appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.audioPlayer stopAll];
        [appDelegate.firstTime setGuideForPosition:self.appPosition value:!self.checkShowAgain.checkboxSelected];
    }
	[self animClose];
}

- (void)showInfo:(NSString *)titleOfPart tipText:(NSString *)tipToShow {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	NSString *html = @"<html><head><style type=\"text/css\">%@</style></head><body><div><hr />%@<hr /></div></body></html>";
	NSString *css;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		css = @"body {color:#FAFAFA;font-size:32pt;font-family:helvetica;font-style:italic;padding:0px;margin:0px;background-color:transparent;}";
    } else {
		css = @"body {color:#FAFAFA;font-size:16pt;font-family:helvetica;font-style:italic;padding:0px;margin:0px;background-color:transparent;}";
        
    }
	html = [NSString stringWithFormat:html,css,tipToShow];
	sText = [html retain];
    sUrl = @"http://t2health.org";
	[self reloadString];
	[lblTitle setText:titleOfPart];
	int fontSize = [appDelegate MaxOfFontForLabel:lblTitle andWidth:lblTitle.frame.size.width andHeight:lblTitle.frame.size.height];
	[lblTitle setFont:[lblTitle.font fontWithSize:(CGFloat)fontSize]];
	[self animShow];
}

- (void)reloadString {
	[wvInfo loadHTMLString:sText baseURL:[NSURL URLWithString:sUrl]];
}

#pragma mark -
#pragma mark Animation Funtions
- (void)animShow {
	bClose.userInteractionEnabled = NO;
	self.alpha = 0.0f;
	self.hidden = NO;
	[UIView beginAnimations:@"animShow" context:nil];
	[UIView setAnimationDuration:0.25f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.alpha = 1.0f;
	[UIView commitAnimations];
	
}
- (void)animClose{
	[UIView beginAnimations:@"helpInfoClose" context:nil];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDidStopSelector:@selector(animationHasFinished:finished:context:)];
	self.alpha = 0.0f;
	[UIView commitAnimations];
}

- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    B2RAppDelegate *appDelegate = (B2RAppDelegate *)[UIApplication sharedApplication].delegate;
	if ((animationID == @"animShow")/* && finished*/) {  
		bClose.userInteractionEnabled = YES;
        if (self.playFile) {
            [appDelegate.audioPlayer preparePlayer:enSCAmbient andMP3File:self.playFile andMP3Volume:1.0f andMP3Pan:0.0f andNumberOfLoops:0 delegate:nil];
            [appDelegate.audioPlayer play:enSCAmbient];
        }
	}
	if ((animationID == @"helpInfoClose")/* && finished*/) {
		self.hidden = YES;
		//if (![sUrl isEqualToString:@""]) {
		//	[self showInfo:sTitle filename:sUrl];
		//}
	}
}


@end
