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

#pragma mark Search results

- (void)searchResults:(NSDictionary *)results
    foundForSearchString:(NSString *)searchString;
- (void)failedToSearchForString:(NSString *)searchString
    error:(NSError *)error;

@end
