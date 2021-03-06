//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigReader.h"

@class LogInState, UserCache, RepoCache, CommitCache, UserNetworkCache;
@class GitHubService;

@interface GitHubServiceFactory : NSObject
{
    IBOutlet NSObject<ConfigReader> * configReader;
    IBOutlet LogInState * logInState;
    IBOutlet UserCache * userCache;
    IBOutlet RepoCache * repoCache;
    IBOutlet CommitCache * commitCache;
    IBOutlet UserNetworkCache * userNetworkCache;
}

- (GitHubService *)createGitHubService;

@end
