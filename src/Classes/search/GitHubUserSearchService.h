//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchServiceDelegate.h"
#import "GitHubService.h"

@interface GitHubUserSearchService :
    NSObject <SearchService, GitHubServiceDelegate>
{
    NSObject<SearchServiceDelegate> * delegate;
    GitHubService * gitHubService;
}

@property (nonatomic, retain) NSObject<SearchServiceDelegate> * delegate;

- (id)initWithGitHubService:(GitHubService *)gitHubService;

@end
