//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHubService.h"
#import "GitHub.h"

#import "UIApplication+NetworkActivityIndicatorAdditions.h"

@interface GitHubService (Private)
- (void)saveInfo:(UserInfo *)info forUsername:(NSString *)username;
- (void)saveRepos:(NSDictionary *)repos forUsername:(NSString *)username;
- (BOOL)isPrimaryUser:(NSString *)username;
@end

@implementation GitHubService

- (void)dealloc
{
    [gitHub release];
    [logInStateReader release];
    [userCacheSetter release];
    [userCacheReader release];
    [repoCacheSetter release];
    [configReader release];
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

#pragma mark Fetching user info from GitHub

- (void)fetchInfoForUsername:(NSString *)username
{
    [[UIApplication sharedApplication] networkActivityIsStarting];

    if ([self isPrimaryUser:username])
        [gitHub fetchInfoForUsername:username token:logInStateReader.token];
    else
        [gitHub fetchInfoForUsername:username];
}

- (void)fetchInfoForUsername:(NSString *)username token:(NSString *)token
{
    [[UIApplication sharedApplication] networkActivityIsStarting];

    [gitHub fetchInfoForUsername:username token:token];
}

- (void)fetchInfoForRepo:(NSString *)repo username:(NSString *)username
{
    NSString * token = nil;
    if ([self isPrimaryUser:username])
        token = logInStateReader.token;

    [self fetchInfoForRepo:repo username:username token:token];
}

- (void)fetchInfoForRepo:(NSString *)repo
                username:(NSString *)username
                   token:(NSString *)token
{
    [[UIApplication sharedApplication] networkActivityIsStarting];

    [gitHub fetchInfoForRepo:repo username:username token:token];
}

#pragma mark GitHubDelegate implementation

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username
{
    [[UIApplication sharedApplication] networkActivityDidFinish];

    [self saveInfo:info forUsername:username];
    [self saveRepos:repos forUsername:username];

    SEL selector = @selector(userInfo:repoInfos:fetchedForUsername:);
    if ([delegate respondsToSelector:selector])
        [delegate userInfo:info repoInfos:repos fetchedForUsername:username];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    [[UIApplication sharedApplication] networkActivityDidFinish];

    SEL selector = @selector(failedToFetchInfoForUsername:error:);
    if ([delegate respondsToSelector:selector])
        [delegate failedToFetchInfoForUsername:username error:error];
}

- (void)commits:(NSArray *)commits fetchedForRepo:(NSString *)repo
    username:(NSString *)username
{
    [[UIApplication sharedApplication] networkActivityDidFinish];

    SEL selector = @selector(commits:fetchedForRepo:username:);
    if ([delegate respondsToSelector:selector])
        [delegate commits:commits fetchedForRepo:repo username:username];
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

#pragma mark Persisting retrieved data

- (void)saveInfo:(UserInfo *)info forUsername:(NSString *)username
{
    if ([self isPrimaryUser:username])
        [userCacheSetter setPrimaryUser:info];
    else
        [userCacheSetter addRecentlyViewedUser:info withUsername:username];
}

- (void)saveRepos:(NSDictionary *)repos forUsername:(NSString *)username
{
    BOOL primaryUser = [self isPrimaryUser:username];

    UserInfo * userInfo = primaryUser ?
        userCacheReader.primaryUser :
        [userCacheReader userWithUsername:username];

    for (NSString * repoKey in userInfo.repoKeys) {
        RepoInfo * repoInfo = [repos objectForKey:repoKey];
        if (primaryUser)
            [repoCacheSetter setPrimaryUserRepo:repoInfo forRepoName:repoKey];
        else
            [repoCacheSetter addRecentlyViewedRepo:repoInfo
                                      withRepoName:repoKey
                                          username:username];
    }
}

- (BOOL)isPrimaryUser:(NSString *)username
{
    return [username isEqualToString:logInStateReader.login];
}

@end
