//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHubNewsFeedService.h"
#import "GitHubNewsFeed.h"

#import "UIApplication+NetworkActivityIndicatorAdditions.h"

@interface GitHubNewsFeedService (Private)

- (void)cacheNewsFeed:(NSArray *)feed forUsername:(NSString *)username;
- (BOOL)isPrimaryUsername:(NSString *)username;

@end

@implementation GitHubNewsFeedService

@synthesize delegate;

- (void)dealloc
{
    [delegate release];
    [logInStateReader release];
    [newsFeedCacheSetter release];
    [newsFeed release];
    [super dealloc];
}

#pragma mark Initialization

- (id)initWithBaseUrl:(NSString *)baseUrl
     logInStateReader:(NSObject<LogInStateReader> *)aLogInStateReader
  newsFeedCacheSetter:(NSObject<NewsFeedCacheSetter> *)aNewsFeedCacheSetter
{
    if (self = [super init]) {
        newsFeed = [[GitHubNewsFeed alloc] initWithBaseUrl:baseUrl
                                                  delegate:self];

        logInStateReader = [aLogInStateReader retain];
        newsFeedCacheSetter = [aNewsFeedCacheSetter retain];
    }

    return self;
}

#pragma mark Fetching news feeds

- (void)fetchNewsFeedForPrimaryUser
{
    [[UIApplication sharedApplication] networkActivityIsStarting];

    [newsFeed fetchNewsFeedForPrimaryUser:logInStateReader.login
                                    token:logInStateReader.token];
}

- (void)fetchActivityFeedForUsername:(NSString *)username
{
    [[UIApplication sharedApplication] networkActivityIsStarting];

    if ([self isPrimaryUsername:username])
        [newsFeed fetchActivityFeedForUsername:username
                                         token:logInStateReader.token];
    else
        [newsFeed fetchActivityFeedForUsername:username];
}

#pragma mark GitHubNewsFeedDelegate implementation

- (void)newsFeed:(NSArray *)feed fetchedForUsername:(NSString *)username
{
    [self cacheNewsFeed:feed forUsername:username];

    [delegate newsFeed:feed fetchedForUsername:username];

    [[UIApplication sharedApplication] networkActivityDidFinish];
}

- (void)failedToFetchNewsFeedForUsername:(NSString *)username
                                   error:(NSError *)error
{
    [delegate failedToFetchNewsFeedForUsername:username error:error];

    [[UIApplication sharedApplication] networkActivityDidFinish];
}

#pragma mark Caching data

- (void)cacheNewsFeed:(NSArray *)feed forUsername:(NSString *)username
{
    if ([self isPrimaryUsername:username])
        [newsFeedCacheSetter setPrimaryUserNewsFeed:feed];
    else
        [newsFeedCacheSetter setActivityFeed:feed forUsername:username];
}

#pragma mark Helper methods

- (BOOL)isPrimaryUsername:(NSString *)username
{
    return [username isEqualToString:logInStateReader.login];
}

@end
