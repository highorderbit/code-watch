//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "GitHubSearchInitializer.h"
#import "GitHubUserSearchService.h"
#import "GitHubSearchService.h"

@interface GitHubSearchInitializer (Private)

- (GitHubUserSearchService *)createUserService;

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
        
    GitHubSearchService * gitHubSearchService =
        [[GitHubSearchService alloc] initWithUserService:userService];
    userService.delegate = gitHubSearchService;
    
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

@end
