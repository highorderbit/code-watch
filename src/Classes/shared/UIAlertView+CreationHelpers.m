//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UIAlertView+CreationHelpers.h"

@implementation UIAlertView (CreationHelpers)

+ (UIAlertView *)simpleAlertViewWithTitle:(NSString *)title
                                  message:(NSString *)message
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

+ (UIAlertView *)notImplementedAlertView
{
    return [[self class]
        simpleAlertViewWithTitle:@"Not Implemented"
                         message:@"This feature has not yet been implemented."];
}

@end
