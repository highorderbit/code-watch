//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedItemDetailsViewController : UIViewController
{
    IBOutlet UIWebView * webView;

    NSString * details;
}

#pragma mark Updating the display

- (void)updateWithDetails:(NSString *)htmlDetails;

@end
