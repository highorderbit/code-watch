//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceDelegate.h"
#import "GitHubDelegate.h"
#import "LogInStateReader.h"
#import "LogInStateSetter.h"
#import "UserCacheSetter.h"
#import "UserCacheReader.h"
#import "RepoCacheSetter.h"
#import "RepoCacheReader.h"
#import "CommitCacheSetter.h"
#import "CommitCacheReader.h"
#import "ConfigReader.h"

@class GitHub, GitHubServiceDelegate;

@interface GitHubService : NSObject <GitHubDelegate>
{
    IBOutlet id<GitHubServiceDelegate> delegate;

    IBOutlet NSObject<ConfigReader> * configReader;

    IBOutlet NSObject<LogInStateReader> * logInStateReader;
    IBOutlet NSObject<LogInStateSetter> * logInStateSetter;
    IBOutlet NSObject<UserCacheSetter> * userCacheSetter;
    IBOutlet NSObject<UserCacheReader> * userCacheReader;
    IBOutlet NSObject<RepoCacheSetter> * repoCacheSetter;
    IBOutlet NSObject<RepoCacheReader> * repoCacheReader;
    IBOutlet NSObject<CommitCacheSetter> * commitCacheSetter;
    IBOutlet NSObject<CommitCacheReader> * commitCacheReader;

    NSString * usernameForLogInAttempt;

    GitHub * gitHub;
}

#pragma mark Instantiation

+ (id)service;
- (id)init;

#pragma mark Logging in

//
// Only one log in attempt is permitted at a time.
//

- (void)logIn:(NSString *)username;
- (void)logIn:(NSString *)username token:(NSString *)token;

#pragma mark Fetching user info

- (void)fetchInfoForUsername:(NSString *)username;

#pragma mark Fetching repository information

- (void)fetchInfoForRepo:(NSString *)repo username:(NSString *)username;

#pragma mark Fetching commit information

- (void)fetchInfoForCommit:(NSString *)commitKey
                      repo:(NSString *)repo
                  username:(NSString *)username;

@end
