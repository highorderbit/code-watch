//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "GitHubSearchInitializer.h"
#import "GitHubUserSearchService.h"
#import "GitHubSearchService.h"

@interface GitHubSearchInitializer (Private)

- (GitHubUserSearchService *)createUserService;
- (GitHubRepoSearchService *)createRepoService;

@end

@implementation GitHubSearchInitializer

- (void)dealloc
{
    [searchViewController release];
    [super dealloc];
}

- (void)awakeFromNib
{
    GitHubUserSearchService * userService = [self createUserService];
    GitHubRepoSearchService * repoService = [self createRepoService];
        
    GitHubSearchService * gitHubSearchService =
        [[GitHubSearchService alloc] initWithUserService:userService
        repoService:repoService];
    userService.delegate = gitHubSearchService;
    repoService.delegate = gitHubSearchService;
    
    gitHubSearchService.delegate = searchViewController;
    
    [searchViewController initWithSearchService:gitHubSearchService];
}

- (GitHubUserSearchService *)createUserService
{
    GitHubService * gitHubService = [gitHubServiceFactory createGitHubService];

    GitHubUserSearchService * userService =
        [[[GitHubUserSearchService alloc]
        initWithGitHubService:gitHubService]
        autorelease];

    gitHubService.delegate = userService;
    
    return userService;
}

- (GitHubRepoSearchService *)createRepoService
{
    GitHubService * gitHubService = [gitHubServiceFactory createGitHubService];

    GitHubRepoSearchService * repoService =
        [[[GitHubRepoSearchService alloc]
        initWithGitHubService:gitHubService]
        autorelease];

    gitHubService.delegate = repoService;
    
    return repoService;
}

@end
