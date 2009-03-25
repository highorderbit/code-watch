//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHubService.h"
#import "GitHub.h"
#import "CommitInfo.h"

#import "UIApplication+NetworkActivityIndicatorAdditions.h"

@interface GitHubService (Private)
- (void)setPrimaryUser:(NSString *)username token:(NSString *)token;
- (void)cacheUserInfo:(UserInfo *)info forUsername:(NSString *)username;
- (void)cacheRepos:(NSDictionary *)repos forUsername:(NSString *)username;
- (void)cacheRepoInfo:(RepoInfo *)repoInfo forUsername:(NSString *)username
    repoName:(NSString *)repoName;
- (void)cacheCommits:(NSDictionary *)commits forUsername:(NSString *)username
    repo:(NSString *)repoName;

+ (UserInfo *)extractUserInfo:(NSDictionary *)gitHubInfo;
+ (NSDictionary *)extractUserDetails:(NSDictionary *)gitHubInfo;
+ (NSArray *)extractRepoKeys:(NSDictionary *)gitHubInfo;
+ (NSDictionary *)extractRepoInfos:(NSDictionary *)gitHubInfo;
+ (NSArray *)extractCommitKeys:(NSDictionary *)gitHubInfo;
+ (NSDictionary *)extractCommitInfos:(NSDictionary *)gitHubInfo;

- (RepoInfo *)repoInfoForUser:username repo:(NSString *)repo;
- (BOOL)isPrimaryUser:(NSString *)username;

- (BOOL)isAttemptingLogIn;
- (BOOL)isAttemptingLogInForUsername:(NSString *)username;
- (void)startingLogInAttemptForUsername:(NSString *)username;
- (void)logInAttemptFinished;

- (void)setUsernameForLogInAttempt:(NSString *)s;
@end

@implementation GitHubService

- (void)dealloc
{
    [configReader release];

    [logInStateReader release];
    [userCacheSetter release];
    [userCacheReader release];
    [repoCacheSetter release];
    [repoCacheReader release];

    [usernameForLogInAttempt release];

    [gitHub release];

    [super dealloc];
}

#pragma mark Instantiation

+ (id)service
{
    return [[[[self class] alloc] init] autorelease];
}

#pragma mark Initialization

- (id)init
{
    return (self = [super init]);
}

- (void)awakeFromNib
{
    NSString * url = [configReader valueForKey:@"GitHubApiBaseUrl"];
    NSURL * gitHubApiBaseUrl = [NSURL URLWithString:url];

    GitHubApiFormat apiFormat =
        [[configReader valueForKey:@"GitHubApiFormat"] intValue];

    GitHubApiVersion apiVersion =
        [[configReader valueForKey:@"GitHubApiVersion"] intValue];

    gitHub = [[GitHub alloc] initWithBaseUrl:gitHubApiBaseUrl
                                      format:apiFormat
                                     version:apiVersion
                                    delegate:self];
}

#pragma mark Logging in

- (void)logIn:(NSString *)username
{
    [self logIn:username token:nil];
}

- (void)logIn:(NSString *)username token:(NSString *)token
{
    [[UIApplication sharedApplication] networkActivityIsStarting];

    if (![self isAttemptingLogIn]) {
        [self startingLogInAttemptForUsername:username];
        [gitHub fetchInfoForUsername:username token:token];
    }
}

#pragma mark Fetching user info from GitHub

- (void)fetchInfoForUsername:(NSString *)username
{
    [[UIApplication sharedApplication] networkActivityIsStarting];

    if ([self isPrimaryUser:username])
        [gitHub fetchInfoForUsername:username token:logInStateReader.token];
    else
        [gitHub fetchInfoForUsername:username];
}

- (void)fetchInfoForRepo:(NSString *)repo username:(NSString *)username
{
    [[UIApplication sharedApplication] networkActivityIsStarting];

    NSString * token = nil;
    if ([self isPrimaryUser:username])
        token = logInStateReader.token;

    [gitHub fetchInfoForRepo:repo username:username token:token];
}

#pragma mark GitHubDelegate implementation

- (void)userInfo:(NSDictionary *)info fetchedForUsername:(NSString *)username
    token:(NSString *)token
{
    [[UIApplication sharedApplication] networkActivityDidFinish];

    UserInfo * ui = [[self class] extractUserInfo:info];
    NSDictionary * repos = [[self class] extractRepoInfos:info];

    if ([self isAttemptingLogInForUsername:username]) {
        [self setPrimaryUser:username token:token];
        [self logInAttemptFinished];

        SEL selector = @selector(logInSucceeded:);
        if ([delegate respondsToSelector:selector])
            [delegate logInSucceeded:username];
    }

    [self cacheUserInfo:ui forUsername:username];
    [self cacheRepos:repos forUsername:username];

    SEL selector = @selector(userInfo:repoInfos:fetchedForUsername:);
    if ([delegate respondsToSelector:selector])
        [delegate userInfo:ui repoInfos:repos fetchedForUsername:username];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    [[UIApplication sharedApplication] networkActivityDidFinish];

    if ([self isAttemptingLogInForUsername:username]) {
        SEL selector = @selector(logInFailed:error:);
        if ([delegate respondsToSelector:selector])
            [delegate logInFailed:username error:error];
    } else {
        SEL selector = @selector(failedToFetchInfoForUsername:error:);
        if ([delegate respondsToSelector:selector])
            [delegate failedToFetchInfoForUsername:username error:error];
    }
}

- (void)commits:(NSDictionary *)commits fetchedForRepo:(NSString *)repo
    username:(NSString *)username token:(NSString *)token
{
    [[UIApplication sharedApplication] networkActivityDidFinish];

    RepoInfo * repoInfo = [self repoInfoForUser:username repo:repo];
    NSArray * commitKeys = [[self class] extractCommitKeys:commits];
    NSDictionary * commitInfos = [[self class] extractCommitInfos:commits];
    repoInfo = [[[RepoInfo alloc] initWithDetails:repoInfo.details
                                       commitKeys:commitKeys] autorelease];

    [self cacheRepoInfo:repoInfo forUsername:username repoName:repo];
    [self cacheCommits:commitInfos forUsername:username repo:repo];

    SEL selector = @selector(commits:fetchedForRepo:username:);
    if ([delegate respondsToSelector:selector])
        [delegate commits:commitInfos fetchedForRepo:repo username:username];
}

- (void)failedToFetchInfoForRepo:(NSString *)repo
                        username:(NSString *)username
                           error:(NSError *)error
{
    [[UIApplication sharedApplication] networkActivityDidFinish];

    // TODO: Do something meaningful here
    NSLog(@"Failed to fetch info for repo: user: '%@', repo: '%@', error: '%@'",
        username, repo, error);
}

#pragma mark Persisting received data

- (void)setPrimaryUser:(NSString *)username token:(NSString *)token
{
    [logInStateSetter setLogin:username token:token prompt:NO];
}

- (void)cacheUserInfo:(UserInfo *)info forUsername:(NSString *)username
{
    if ([self isPrimaryUser:username])
        [userCacheSetter setPrimaryUser:info];
    else
        [userCacheSetter addRecentlyViewedUser:info withUsername:username];
}

- (void)cacheRepos:(NSDictionary *)repos forUsername:(NSString *)username
{
    UserInfo * userInfo = [self isPrimaryUser:username] ?
        userCacheReader.primaryUser :
        [userCacheReader userWithUsername:username];

    for (NSString * repoKey in userInfo.repoKeys)
        [self cacheRepoInfo:[repos objectForKey:repoKey] forUsername:username
            repoName:repoKey];
}

- (void)cacheRepoInfo:(RepoInfo *)repoInfo forUsername:(NSString *)username
    repoName:(NSString *)repoName
{
    RepoInfo * cachedInfo = nil;
    if ([self isPrimaryUser:username])
        cachedInfo = [repoCacheReader primaryUserRepoWithName:repoName];
    else
        cachedInfo =
            [repoCacheReader repoWithUsername:username repoName:repoName];

    if (cachedInfo) {
        NSDictionary * details = nil;
        NSArray * commitKeys = nil;

        details = repoInfo.details ? repoInfo.details : cachedInfo.details;
        commitKeys =
            repoInfo.commitKeys ? repoInfo.commitKeys : cachedInfo.commitKeys;

        repoInfo = [[[RepoInfo alloc]
            initWithDetails:details commitKeys:commitKeys] autorelease];
    }

    if ([self isPrimaryUser:username])
        [repoCacheSetter setPrimaryUserRepo:repoInfo forRepoName:repoName];
    else
        [repoCacheSetter addRecentlyViewedRepo:repoInfo
                                  withRepoName:repoName
                                      username:username];
}

- (void)cacheCommits:(NSDictionary *)commits forUsername:(NSString *)username
    repo:(NSString *)repoName
{
    RepoInfo * repoInfo = nil;
    if ([self isPrimaryUser:username])
        repoInfo = [repoCacheReader primaryUserRepoWithName:repoName];
    else
        repoInfo =
            [repoCacheReader repoWithUsername:username repoName:repoName];

    for (NSString * commitKey in repoInfo.commitKeys) {
        CommitInfo * commit = [commits objectForKey:commitKey];
        [commitCacheSetter setCommit:commit forKey:commitKey];
    }
}

#pragma mark Parsing received data

+ (UserInfo *)extractUserInfo:(NSDictionary *)gitHubInfo
{
    NSDictionary * details = [[self class] extractUserDetails:gitHubInfo];
    NSArray * keys = [[self class] extractRepoKeys:gitHubInfo];

    return
        [[[UserInfo alloc] initWithDetails:details repoKeys:keys] autorelease];
}

+ (NSDictionary *)extractUserDetails:(NSDictionary *)gitHubInfo
{
    NSMutableDictionary * info =
        [[[gitHubInfo objectForKey:@"user"] mutableCopy] autorelease];

    [info removeObjectForKey:@"login"];
    [info removeObjectForKey:@"repositories"];

    return info;
}

+ (NSArray *)extractRepoKeys:(NSDictionary *)gitHubInfo
{
    NSArray * repos =
        [[gitHubInfo objectForKey:@"user"] objectForKey:@"repositories"];
    NSMutableArray * repoNames =
        [NSMutableArray arrayWithCapacity:repos.count];
    for (NSDictionary * repo in repos)
        [repoNames addObject:[repo objectForKey:@"name"]];

    return repoNames;
}

+ (NSDictionary *)extractRepoInfos:(NSDictionary *)gitHubInfo
{
    NSArray * repos =
        [[gitHubInfo objectForKey:@"user"] objectForKey:@"repositories"];

    NSMutableDictionary * repoInfos =
        [NSMutableDictionary dictionaryWithCapacity:repos.count];
    for (NSDictionary * repo in repos) {
        NSString * repoName = [repo objectForKey:@"name"];

        NSMutableDictionary * details = [[repo mutableCopy] autorelease];
        [details removeObjectForKey:@"name"];

        RepoInfo * repoInfo = [[RepoInfo alloc] initWithDetails:details];
        [repoInfos setObject:repoInfo forKey:repoName];
        [repoInfo release];
    }

    return repoInfos;
}

+ (NSArray *)extractCommitKeys:(NSDictionary *)gitHubInfo
{
    NSArray * commits = [gitHubInfo objectForKey:@"commits"];

    NSMutableArray * commitKeys =
        [NSMutableArray arrayWithCapacity:commits.count];
    for (NSDictionary * commit in commits) {
        NSString * key = [commit objectForKey:@"id"];
        [commitKeys addObject:key];
    }

    return commitKeys;
}

+ (NSDictionary *)extractCommitInfos:(NSDictionary *)gitHubInfo
{
    NSMutableDictionary * commitInfos = [NSMutableDictionary dictionary];

    for (NSDictionary * commit in [gitHubInfo objectForKey:@"commits"]) {
        NSMutableDictionary * details = [commit mutableCopy];
        NSString * commitKey = [details objectForKey:@"id"];

        [details removeObjectForKey:@"id"];

        CommitInfo * commitInfo = [[CommitInfo alloc] initWithDetails:details];
        if (commitKey == nil)
            NSLog(@"ABOUT TO CRASH THE PROGRAM");
        [commitInfos setObject:commitInfo forKey:commitKey];
        [commitInfo release];
    }

    return commitInfos;
}

#pragma mark Miscellaneous helpers

- (RepoInfo *)repoInfoForUser:username repo:(NSString *)repo
{
    return [self isPrimaryUser:username] ?
        [repoCacheReader primaryUserRepoWithName:repo] :
        [repoCacheReader repoWithUsername:username repoName:repo];
}

- (BOOL)isPrimaryUser:(NSString *)username
{
    return [username isEqualToString:logInStateReader.login];
}

#pragma mark Tracking log in attempts

- (BOOL)isAttemptingLogIn
{
    return !!usernameForLogInAttempt;
}

- (BOOL)isAttemptingLogInForUsername:(NSString *)username
{
    return
        [self isAttemptingLogIn] &&
        [username isEqualToString:usernameForLogInAttempt];
}

- (void)startingLogInAttemptForUsername:(NSString *)username
{
    [self setUsernameForLogInAttempt:username];
}

- (void)logInAttemptFinished
{
    [self setUsernameForLogInAttempt:nil];
}

#pragma mark Accessors

- (void)setUsernameForLogInAttempt:(NSString *)s
{
    NSString * tmp = [s copy];
    [usernameForLogInAttempt release];
    usernameForLogInAttempt = tmp;
}

@end
