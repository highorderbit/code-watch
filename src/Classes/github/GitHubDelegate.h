//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;

@protocol GitHubDelegate

- (void)info:(UserInfo *)info fetchedForUsername:(NSString *)username;
- (void)info:(UserInfo *)info fetchedForUsername:(NSString *)username
    token:(NSString *)token;

@end
