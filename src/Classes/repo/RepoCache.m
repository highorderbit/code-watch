//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "RepoCache.h"

@implementation RepoCache

- (void)dealloc
{
    [recentlyViewedRepos release];
    [primaryUserRepos release];
    [super dealloc];
}

- (void)awakeFromNib
{
    recentlyViewedRepos = [[NSMutableDictionary alloc] init];
    primaryUserRepos = [[NSMutableDictionary alloc] init];
}

#pragma mark RepoCacheReader implementation

- (NSDictionary *)allRepos
{
    return [[recentlyViewedRepos copy] autorelease];
}

- (NSDictionary *)allPrimaryUserRepos
{
    return [[primaryUserRepos copy] autorelease];
}

- (RepoInfo *)primaryUserRepoWithName:(NSString *)repoName
{
    return [[[primaryUserRepos objectForKey:repoName] copy] autorelease];
}

- (RepoInfo *)repoWithUsername:(NSString *)username
    repoName:(NSString *)repoName
{
    return [[[[recentlyViewedRepos objectForKey:username]
        objectForKey:repoName] copy] autorelease];
}

#pragma mark RepoCacheSetter implementation

- (void)setPrimaryUserRepo:(RepoInfo *)repo forRepoName:(NSString *)repoName
{
    repo = [[repo copy] autorelease];
    [primaryUserRepos setObject:repo forKey:repoName];
}

- (void)removePrimaryUserRepoForName:(NSString *)repoName
{
    [primaryUserRepos removeObjectForKey:repoName];
}

- (void)addRecentlyViewedRepo:(RepoInfo *)repo withRepoName:(NSString *)repoName
    username:(NSString *)username
{
    repo = [[repo copy] autorelease];
    
    NSMutableDictionary * usersRepos =
        [recentlyViewedRepos objectForKey:username];
    if (!usersRepos) {
        usersRepos = [NSMutableDictionary dictionary];
        [recentlyViewedRepos setObject:usersRepos forKey:username];
    }
    [usersRepos setObject:repo forKey:repoName];
}

@end
