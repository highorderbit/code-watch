//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "RepoCache.h"

@implementation RepoCache

#pragma mark RepoCacheReader implementation

@synthesize allRepos;
@synthesize allPrimaryUserRepos;

- (RepoInfo *)primaryUserRepoWithName:(NSString *)repoName
{
    return nil;
}

- (RepoInfo *)repoWithUsername:(NSString *)username
    repoName:(NSString *)repoName
{
    return nil;
}

#pragma mark RepoCacheSetter implementation

- (void)setPrimaryUserRepo:(RepoInfo *)repo forRepoName:(NSString *)repoName
{
}

- (void)removePrimaryUserRepoForName:(NSString *)repoName
{
}

- (void)addRecentlyViewedRepo:(RepoInfo *)repo withRepoName:(NSString *)repoName
    username:(NSString *)username
{
}

@end
