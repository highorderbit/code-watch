//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceDelegate.h"
#import "GitHubDelegate.h"
#import "LogInStateReader.h"
#import "UserCacheSetter.h"
#import "UserCacheReader.h"
#import "RepoCacheSetter.h"
#import "ConfigReader.h"

@class GitHub, GitHubServiceDelegate;

@interface GitHubService : NSObject <GitHubDelegate>
{
    IBOutlet id<GitHubServiceDelegate> delegate;

    GitHub * gitHub;

    IBOutlet NSObject<LogInStateReader> * logInStateReader;
    IBOutlet NSObject<UserCacheSetter> * userCacheSetter;
    IBOutlet NSObject<UserCacheReader> * userCacheReader;
    IBOutlet NSObject<RepoCacheSetter> * repoCacheSetter;

    IBOutlet NSObject<ConfigReader> * configReader;
}

#pragma mark Instantiation

+ (id)service;
- (id)init;

#pragma mark Fetching user info from GitHub

- (void)fetchInfoForUsername:(NSString *)username;

#pragma mark Fetching repository information from GitHub

- (void)fetchInfoForRepo:(NSString *)repo username:(NSString *)username;

@end
