//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "GitHubUserSearchService.h"

@implementation GitHubUserSearchService

@synthesize delegate;

- (void)dealloc
{
    [delegate release];
    [gitHubService release];
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
    [gitHubService fetchInfoForUsername:text];
}

#pragma mark GitHubServiceDelegate implementation

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username
{
    [delegate processSearchResults:[NSArray arrayWithObject:username]
        fromSearchService:self];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    // not found, so return an empty array
    [delegate processSearchResults:[NSArray array] fromSearchService:self];
}

@end
