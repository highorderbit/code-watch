//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LogInViewControllerDelegate

- (void)userProvidedUsername:(NSString *)username token:(NSString *)token;
- (void)userDidCancel;

- (void)provideHelp;
- (void)provideUpgradeHelp;

@end
