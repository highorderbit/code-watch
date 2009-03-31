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
    [delegate processSearchResults:[NSArray arrayWithObject:username]
        fromSearchService:self];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    // not found, so return an empty array
    [self dequeueRequest];
    [delegate processSearchResults:[NSArray array] fromSearchService:self];
}

#pragma mark NSCopying implementation

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
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
