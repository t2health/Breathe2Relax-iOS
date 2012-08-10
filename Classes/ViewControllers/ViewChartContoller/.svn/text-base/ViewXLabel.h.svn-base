//
//  ViewXLabel.h
//  iBreathe130
//
//  Created by Roger Reeder on 9/1/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewXLabel : UIView {
	UIImageView *ivBackground;
	UILabel *titleText;
	UILabel *monthText;
	UILabel *dayText;
	UIFont *fTitle;
	UIFont *fSub;
	UILabel *yearText;
}
@property (nonatomic, retain) UILabel *titleText;
@property (nonatomic, retain) UILabel *monthText;
@property (nonatomic, retain) UILabel *dayText;
@property (nonatomic, retain) UILabel *yearText;



- (id)initWithFrame:(CGRect)frame
		   andTitle:(NSString *)title
			 andDay:(NSString *)day
		   andMonth:(NSString *)month
			andYear:(NSString *)year;

-(int)getSubviewIndex;

-(void)bringToFront;
-(void)sendToBack;

-(void)bringOneLevelUp;
-(void)sendOneLevelDown;

-(BOOL)isInFront;
-(BOOL)isAtBack;

-(void)swapDepthsWithView:(ViewXLabel *)swapView;


-(void)scaleLabel:(UIView *)v andCenter:(CGPoint)newCenter andAlpha:(CGFloat)newAlpha;
@end
