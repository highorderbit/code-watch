//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo, RepoInfo, CommitInfo;

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

- (void)commits:(NSDictionary *)commitInfos fetchedForRepo:(NSString *)repo
    username:(NSString *)username;
- (void)failedToFetchInfoForRepo:(NSString *)repo
                        username:(NSString *)username
                           error:(NSError *)error;

#pragma mark Fetching commit information

@optional

- (void)commitInfo:(CommitInfo *)commitInfo
  fetchedForCommit:(NSString *)commitKey
              repo:(NSString *)repo
          username:(NSString *)username;
- (void)failedToFetchInfoForCommit:(NSString *)commitKey
                              repo:(NSString *)repo
                          username:(NSString *)username
                             error:(NSError *)error;

#pragma mark Searching repositories

- (void)repos:(NSArray *)repos foundForSearchString:(NSString *)searchString;
- (void)failedToSearchReposForString:(NSString *)searchString
                               error:(NSError *)error;

@end
