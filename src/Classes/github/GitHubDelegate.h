//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo, RepoInfo;

@protocol GitHubDelegate <NSObject>

#pragma mark Fetching user information

- (void)userInfo:(UserInfo *)info repos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username;
- (void)failedToFetchInfoForUsername:(NSString *)username
                               error:(NSError *)error;

#pragma mark Fetching repo information

- (void)commits:(NSArray *)commitInfos fetchedForRepo:(NSString *)repo
    username:(NSString *)username;
- (void)failedToFetchInfoForRepo:(NSString *)repo
                        username:(NSString *)username
                           error:(NSError *)error;

@end
