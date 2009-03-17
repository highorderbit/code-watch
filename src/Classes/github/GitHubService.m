//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHubService.h"
#import "GitHub.h"

@interface GitHubService (Private)
- (void)saveInfo:(UserInfo *)info forUsername:(NSString *)username;
@end

@implementation GitHubService

- (void)dealloc
{
    [gitHub release];
    [logInStateReader release];
    [userCacheSetter release];
    [super dealloc];
}

#pragma mark Instantiation

+ (id)service
{
    return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
    if (self = [super init])
        gitHub = [[GitHub alloc] initWithBaseUrl:@"http://github.com/api/"
                                          format:JsonGitHubApiFormat
                                        delegate:self];

    return self;
}

#pragma mark Fetching user info from GitHub

- (void)fetchInfoForUsername:(NSString *)username
{
    if ([username isEqual:logInStateReader.login])
        [gitHub fetchInfoForUsername:username token:logInStateReader.token];
    else
        [gitHub fetchInfoForUsername:username];
}

- (void)fetchInfoForUsername:(NSString *)username token:(NSString *)token
{
    [gitHub fetchInfoForUsername:username token:token];
}

#pragma mark GitHubDelegate implementation

- (void)info:(UserInfo *)info fetchedForUsername:(NSString *)username
{
    [self info:info fetchedForUsername:username token:nil];
}

- (void)info:(UserInfo *)info fetchedForUsername:(NSString *)username
    token:(NSString *)token
{
    [self saveInfo:info forUsername:username];

    [delegate info:info fetchedForUsername:username];
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
