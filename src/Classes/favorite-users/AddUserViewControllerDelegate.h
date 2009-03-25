//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddUserViewControllerDelegate

- (void)userProvidedUsername:(NSString *)username;
- (void)userDidCancel;
- (void)provideHelp;

@end
