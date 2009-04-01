//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "GitHubUserSearchService.h"

@interface GitHubUserSearchService (Private)

- (void)dequeueRequest;

@end

@implementation GitHubUserSearchService

@synthesize delegate;
@synthesize nextRequest;

- (void)dealloc
{
    [delegate release];
    [gitHubService release];
    [nextRequest release];
    [super dealloc];
}

- (id)initWithGitHubService:(GitHubService *)aGitHubService
{
    if (self = [super init])
        gitHubService = [aGitHubService retain];

    return self;
}

- (void)searchForText:(NSString *)text
{
    if (!requestOutstanding) {
        requestOutstanding = YES;
        [gitHubService fetchInfoForUsername:text];
    } else
        self.nextRequest = text;
}

#pragma mark GitHubServiceDelegate implementation

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username
{
    [self dequeueRequest];
    NSArray * usernameArray = [NSArray arrayWithObject:username];
    NSDictionary * usernameDict =
        [NSDictionary dictionaryWithObject:usernameArray forKey:@"username"];
    [delegate processSearchResults:usernameDict fromSearchService:self];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    // not found, so return an empty array
    [self dequeueRequest];
    [delegate processSearchResults:[NSDictionary dictionary]
        fromSearchService:self];
}

#pragma mark Helper methods

- (void)dequeueRequest
{
    if (self.nextRequest) {
        [gitHubService fetchInfoForUsername:self.nextRequest];
        self.nextRequest = nil;
    } else
        requestOutstanding = NO;
}

@end
