//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchService.h"
#import "GitHubUserSearchService.h"

@interface GitHubSearchService : NSObject <SearchService, SearchServiceDelegate>
{
    NSObject<SearchServiceDelegate> * delegate;
    
    GitHubUserSearchService * userService;
    // TODO: add repo search service

    NSMutableDictionary * searchResults;    
}

@property (nonatomic, retain) NSObject<SearchServiceDelegate> * delegate;

- (id)initWithUserService:(GitHubUserSearchService *)userService;

@end
