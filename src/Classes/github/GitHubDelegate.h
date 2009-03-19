//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo, RepoInfo;

@protocol GitHubDelegate <NSObject>

#pragma mark Fetching user information

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username token:(NSString *)token;
- (void)failedToFetchInfoForUsername:(NSString *)username
                               error:(NSError *)error;

#pragma mark Fetching repo information

@optional

- (void)commits:(NSArray *)commitInfos fetchedForRepo:(NSString *)repo
    username:(NSString *)username;
- (void)failedToFetchInfoForRepo:(NSString *)repo
                        username:(NSString *)username
                           error:(NSError *)error;

@end
