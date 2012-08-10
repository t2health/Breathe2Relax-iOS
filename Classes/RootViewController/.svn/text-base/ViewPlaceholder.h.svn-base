//
//  ViewPlaceholder.h
//  iBreathe130
//
//  Created by Roger Reeder on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@interface ViewPlaceholder : UIView {
	UIImageView *ivbackground;
	
	RootViewController *parentController;
	
}


@property (nonatomic, retain) RootViewController *parentController;

- (void)updateLayout:(CGRect)frame;
- (void)animationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
- (void)fadeOutView;
- (void)fadeInView;
- (void)animShowView;

@end
