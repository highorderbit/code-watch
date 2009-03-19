//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo, RepoInfo;

@protocol GitHubServiceDelegate <NSObject>

#pragma mark Logging in

@optional

- (void)logInSucceeded:(NSString *)username;
- (void)logInFailed:(NSString *)username error:(NSError *)error;

@optional

#pragma mark Fetching user information

@optional

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username;
- (void)failedToFetchInfoForUsername:(NSString *)username
                               error:(NSError *)error;

#pragma mark Fetching repository information

@optional

- (void)commits:(NSArray *)commitsInfo fetchedForRepo:(NSString *)repo
    username:(NSString *)username;
- (void)failedToFetchInfoForRepo:(NSString *)repo
                        username:(NSString *)username
                           error:(NSError *)error;

@end
