//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiffViewController : UIViewController
{
    IBOutlet UIWebView * webView;

    NSDictionary * diff;
}

@property (nonatomic, copy, readonly) NSDictionary * diff;

- (void)updateWithDiff:(NSDictionary *)diff;

@end
