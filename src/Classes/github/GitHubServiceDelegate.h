//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo, RepoInfo;

@protocol GitHubServiceDelegate <NSObject>

@optional

#pragma mark Fetching user information

- (void)userInfo:(UserInfo *)info fetchedForUsername:(NSString *)username;
- (void)failedToFetchInfoForUsername:(NSString *)username
                               error:(NSError *)error;

@optional

#pragma mark Fetching repository information

- (void)commits:(NSArray *)commitsInfo fetchedForRepo:(NSString *)repo
    username:(NSString *)username;
- (void)failedToFetchInfoForRepo:(NSString *)repo
                        username:(NSString *)username
                           error:(NSError *)error;

@end
