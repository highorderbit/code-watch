//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchService.h"
#import "GitHubUserSearchService.h"
#import "GitHubRepoSearchService.h"

@interface GitHubSearchService : NSObject <SearchService, SearchServiceDelegate>
{
    NSObject<SearchServiceDelegate> * delegate;
    
    GitHubUserSearchService * userService;
    GitHubRepoSearchService * repoService;
    
    NSMutableDictionary * searchResults;
    
    NSString * searchText;
}

@property (nonatomic, retain) NSObject<SearchServiceDelegate> * delegate;
@property (nonatomic, copy) NSString * searchText;

- (id)initWithUserService:(GitHubUserSearchService *)userService
    repoService:(GitHubRepoSearchService *)repoService;

@end
