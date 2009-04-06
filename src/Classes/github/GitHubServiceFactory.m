//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "GitHubServiceFactory.h"
#import "LogInState.h"
#import "UserCache.h"
#import "RepoCache.h"
#import "CommitCache.h"
#import "GitHubService.h"

@implementation GitHubServiceFactory

- (void)dealloc
{
    [configReader release];
    [logInState release];
    [userCache release];
    [repoCache release];
    [commitCache release];
    [super dealloc];
}

- (GitHubService *)createGitHubService
{
    return [[[GitHubService alloc] initWithConfigReader:configReader
        logInState:logInState userCache:userCache repoCache:repoCache
        commitCache:commitCache] autorelease];
}

@end
