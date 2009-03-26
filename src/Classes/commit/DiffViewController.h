//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiffViewController : UIViewController
{
    IBOutlet UIWebView * webView;
}

- (void)updateWithDiff:(NSDictionary *)diff;

@end
