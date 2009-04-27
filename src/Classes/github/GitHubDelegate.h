//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo, RepoInfo;

@protocol GitHubDelegate <NSObject>

#pragma mark Fetching user information

- (void)userInfo:(NSDictionary *)userInfo
    fetchedForUsername:(NSString *)username token:(NSString *)token;
- (void)failedToFetchInfoForUsername:(NSString *)username
    error:(NSError *)error;

#pragma mark Fetching repo information

- (void)commits:(NSDictionary *)commits fetchedForRepo:(NSString *)repo
    username:(NSString *)username token:(NSString *)token;
- (void)failedToFetchInfoForRepo:(NSString *)repo username:(NSString *)username
    error:(NSError *)error;

#pragma mark Fetching commit information

- (void)commitDetails:(NSDictionary *)details
    fetchedForCommit:(NSString *)commitKey repo:(NSString *)repo
    username:(NSString *)username token:(NSString *)token;
- (void)failedToFetchInfoForCommit:(NSString *)commit repo:(NSString *)repo
    username:(NSString *)username token:(NSString *)token
    error:(NSError *)error;

#pragma mark Fetching followers

- (void)following:(NSDictionary *)following
    fetchedForUsername:(NSString *)username;
- (void)failedToFetchFollowingForUsername:(NSString *)username
    error:(NSError *)error;

- (void)username:(NSString *)follower isFollowing:(NSString *)followee
    token:(NSString *)token;
- (void)failedToFollowUsername:(NSString *)followee
    follower:(NSString *)follower token:(NSString *)token
    error:(NSError *)error;

- (void)username:(NSString *)follower didUnfollow:(NSString *)followee
    token:(NSString *)token;
- (void)failedToUnfollowUsername:(NSString *)followee
    follower:(NSString *)follower token:(NSString *)token
    error:(NSError *)error;

#pragma mark Search results

- (void)userSearchResults:(NSDictionary *)results
    foundForSearchString:(NSString *)searchString;
- (void)failedToSearchUsersForString:(NSString *)searchString
    error:(NSError *)error;

- (void)repoSearchResults:(NSDictionary *)results
    foundForSearchString:(NSString *)searchString;
- (void)failedToSearchReposForString:(NSString *)searchString
    error:(NSError *)error;

@end
