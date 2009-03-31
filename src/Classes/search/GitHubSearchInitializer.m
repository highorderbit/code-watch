//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "GitHubSearchInitializer.h"
#import "GitHubUserSearchService.h"

@interface GitHubSearchInitializer (Private)

- (NSDictionary *)createSearchServices;

@end

@implementation GitHubSearchInitializer

- (void)dealloc
{
    [searchViewController release];
    [super dealloc];
}

- (void)awakeFromNib
{
    NSDictionary * searchServices = [self createSearchServices];
    [searchViewController initWithSearchServices:searchServices];
}

- (NSDictionary *)createSearchServices
{
    NSMutableDictionary * searchServices = [NSMutableDictionary dictionary];
    
    GitHubService * gitHubService = [gitHubServiceFactory createGitHubService];

    GitHubUserSearchService * userService =
        [[[GitHubUserSearchService alloc]
        initWithGitHubService:gitHubService]
        autorelease];
    userService.delegate = searchViewController;
    gitHubService.delegate = userService;
    [searchServices setObject:@"Users (exact matches)" forKey:userService];
    
    return searchServices;
}

@end
