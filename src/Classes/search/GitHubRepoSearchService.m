//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "GitHubRepoSearchService.h"
#import "RepoKey.h"

@interface GitHubRepoSearchService (Private)

+ (RepoKey *)repoKeyFromDictionary:(NSDictionary *)dict;

@end

@implementation GitHubRepoSearchService

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
    [gitHubService searchRepos:text];
}

#pragma mark GitHubServiceDelegate implementation

- (void)repos:(NSArray *)repos foundForSearchString:(NSString *)searchString
{
    NSMutableArray * repoKeys = [NSMutableArray array];
    for (NSDictionary * dict in repos)
        [repoKeys addObject:[[self class] repoKeyFromDictionary:dict]];

    NSDictionary * repoDict =
        [NSDictionary dictionaryWithObject:repoKeys forKey:@"repos"];
    [delegate processSearchResults:repoDict withSearchText:searchString
        fromSearchService:self];
}

- (void)failedToSearchReposForString:(NSString *)searchString
    error:(NSError *)error
{
    // not found, so return an empty array
    [delegate processSearchResults:[NSDictionary dictionary]
        withSearchText:searchString fromSearchService:self];
}

+ (RepoKey *)repoKeyFromDictionary:(NSDictionary *)dict
{
    NSString * username = [dict objectForKey:@"username"];
    NSString * repoName = [dict objectForKey:@"name"];

    return [[[RepoKey alloc]
        initWithUsername:username repoName:repoName] autorelease];
}

@end
