//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UIAlertView+CreationHelpers.h"

@implementation UIAlertView (CreationHelpers)

+ (UIAlertView *)simpleAlertViewWithTitle:(NSString *)title
                             errorMessage:(NSString *)message
{
    NSString * cancelTitle = NSLocalizedString(@"alert.dismiss", @"");

    UIAlertView * alertView =
        [[[UIAlertView alloc]
          initWithTitle:title
                message:message
               delegate:nil
      cancelButtonTitle:cancelTitle
      otherButtonTitles:nil]
         autorelease];

    return alertView;
}

@end
