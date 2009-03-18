//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo, RepoInfo;

@protocol GitHubDelegate <NSObject>

#pragma mark Fetching user information

- (void)userInfo:(UserInfo *)info fetchedForUsername:(NSString *)username;
/*
- (void)          info:(UserInfo *)info
    fetchedForUsername:(NSString *)username
                 token:(NSString *)token;
 */
- (void)failedToFetchInfoForUsername:(NSString *)username
                               error:(NSError *)error;

#pragma mark Fetching repo information

- (void)repoInfo:(RepoInfo *)info fetchedForUsername:(NSString *)username;
- (void)failedToFetchInfoForRepo:(NSString *)repo
                        username:(NSString *)username
                           error:(NSError *)error;

@end