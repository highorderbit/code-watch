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
    NSArray * usernameArray = [NSArray arrayWithObject:username];
    NSDictionary * usernameDict =
        [NSDictionary dictionaryWithObject:usernameArray forKey:@"username"];
    [delegate processSearchResults:usernameDict withSearchText:username
        fromSearchService:self];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    // not found, so return an empty array
    [delegate processSearchResults:[NSDictionary dictionary]
        withSearchText:username fromSearchService:self];
}

@end
