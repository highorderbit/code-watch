//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHubService.h"
#import "GitHub.h"

#import "UIApplication+NetworkActivityIndicatorAdditions.h"

@interface GitHubService (Private)
- (void)saveInfo:(UserInfo *)info forUsername:(NSString *)username;
@end

@implementation GitHubService

- (void)dealloc
{
    [gitHub release];
    [logInStateReader release];
    [userCacheSetter release];
    [configReader release];
    [super dealloc];
}

#pragma mark Instantiation

+ (id)service
{
    return [[[[self class] alloc] init] autorelease];
}

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

    if ([username isEqual:logInStateReader.login])
        [gitHub fetchInfoForUsername:username token:logInStateReader.token];
    else
        [gitHub fetchInfoForUsername:username];
}

- (void)fetchInfoForUsername:(NSString *)username token:(NSString *)token
{
    [[UIApplication sharedApplication] networkActivityIsStarting];

    [gitHub fetchInfoForUsername:username token:token];
}

#pragma mark GitHubDelegate implementation

- (void)userInfo:(UserInfo *)info fetchedForUsername:(NSString *)username
{
    [[UIApplication sharedApplication] networkActivityDidFinish];

    //[self info:info fetchedForUsername:username token:nil];

    [self saveInfo:info forUsername:username];

    if ([delegate respondsToSelector:@selector(info:fetchedForUsername:)])
        [delegate userInfo:info fetchedForUsername:username];
}

/*
- (void)info:(UserInfo *)info fetchedForUsername:(NSString *)username
    token:(NSString *)token
{
    [[UIApplication sharedApplication] networkActivityDidFinish];

    [self saveInfo:info forUsername:username];

    [delegate info:info fetchedForUsername:username];
}
*/

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    [[UIApplication sharedApplication] networkActivityDidFinish];

    SEL selector = @selector(failedToFetchInfoForUsername:error:);
    if ([delegate respondsToSelector:selector])
        [delegate failedToFetchInfoForUsername:username error:error];
}

- (void)fetchInfoForRepo:(NSString *)repo username:(NSString *)username
{
    NSString * token = nil;
    if ([username isEqual:logInStateReader.login])
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

- (void)repoInfo:(RepoInfo *)info fetchedForUsername:(NSString *)username
{
    [[UIApplication sharedApplication] networkActivityDidFinish];

    if ([delegate respondsToSelector:@selector(repoInfo:fetchedForUsername:)])
        [delegate repoInfo:info fetchedForUsername:username];
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
    if ([username isEqual:logInStateReader.login])
        [userCacheSetter setPrimaryUser:info];
    else
        [userCacheSetter addRecentlyViewedUser:info withUsername:username];
}

@end
