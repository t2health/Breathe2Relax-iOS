//
//  ViewWebSiteController.h
//  Breathe2Relax
//
//  Created by Roger Reeder on 5/23/11.
//  Copyright 2011 National Center for Telehealth & Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewWebSiteController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activity;
    NSString *url;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) NSString *url;
@end
