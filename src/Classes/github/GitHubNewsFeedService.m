//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHubNewsFeedService.h"
#import "GitHubNewsFeed.h"

#import "UIApplication+NetworkActivityIndicatorAdditions.h"

@interface GitHubNewsFeedService (Private)

- (BOOL)isPrimaryUsername:(NSString *)username;

@end

@implementation GitHubNewsFeedService

@synthesize delegate;

- (void)dealloc
{
    [delegate release];
    [logInStateReader release];
    [newsFeed release];
    [super dealloc];
}

#pragma mark Initialization

- (id)initWithBaseUrl:(NSString *)baseUrl
     logInStateReader:(NSObject<LogInStateReader> *)aLogInStateReader
{
    if (self = [super init]) {
        newsFeed = [[GitHubNewsFeed alloc] initWithBaseUrl:baseUrl
                                                  delegate:self];

        logInStateReader = [logInStateReader retain];
    }

    return self;
}

#pragma mark Fetching news feeds

- (void)fetchNewsFeedForUsername:(NSString *)username
{
    [[UIApplication sharedApplication] networkActivityIsStarting];

    if ([self isPrimaryUsername:username])
        [newsFeed
            fetchNewsFeedForUsername:username token:logInStateReader.token];
    else
        [newsFeed fetchNewsFeedForUsername:username];
}

#pragma mark GitHubNewsFeedDelegate implementation

- (void)newsFeed:(NSArray *)feed fetchedForUsername:(NSString *)username
{
    [delegate newsFeed:feed fetchedForUsername:username];

    [[UIApplication sharedApplication] networkActivityDidFinish];
}

- (void)failedToFetchNewsFeedForUsername:(NSString *)username
                                   error:(NSError *)error
{
    [delegate failedToFetchNewsFeedForUsername:username error:error];

    [[UIApplication sharedApplication] networkActivityDidFinish];
}

#pragma mark Helper methods

- (BOOL)isPrimaryUsername:(NSString *)username
{
    return [username isEqualToString:logInStateReader.login];
}

@end
