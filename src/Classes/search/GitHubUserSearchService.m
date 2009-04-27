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
    [gitHubService searchUsers:text];
}

#pragma mark GitHubServiceDelegate implementation

- (void)users:(NSArray *)users foundForSearchString:(NSString *)searchString
{
    NSMutableArray * usernames = [NSMutableArray arrayWithCapacity:users.count];
    for (NSDictionary * user in users)
        [usernames addObject:[user objectForKey:@"username"]];

    NSDictionary * usernameDict =
        [NSDictionary dictionaryWithObject:usernames forKey:@"usernames"];
    [delegate processSearchResults:usernameDict withSearchText:searchString
        fromSearchService:self];
}

- (void)failedToSearchUsersForString:(NSString *)searchString
    error:(NSError *)error
{
    // not found, so return an empty array
    [delegate processSearchResults:[NSDictionary dictionary]
        withSearchText:searchString fromSearchService:self];
}

@end
