//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;

@protocol GitHubServiceDelegate

#pragma mark Fetching user information

- (void)info:(UserInfo *)info fetchedForUsername:(NSString *)username;
- (void)failedToFetchInfoForUsername:(NSString *)username
                               error:(NSError *)error;

@end
