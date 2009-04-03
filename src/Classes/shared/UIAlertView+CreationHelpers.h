//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertView (CreationHelpers)

+ (UIAlertView *)simpleAlertViewWithTitle:(NSString *)title
                                  message:(NSString *)message;

+ (UIAlertView *)notImplementedAlertView;

@end
