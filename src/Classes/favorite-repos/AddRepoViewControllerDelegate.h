//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddRepoViewControllerDelegate

- (void)userProvidedUsername:(NSString *)username repoName:(NSString *)repoName;
- (void)userDidCancel;
- (void)provideHelp;

@end
