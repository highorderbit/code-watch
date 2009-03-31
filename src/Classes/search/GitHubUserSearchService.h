//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchServiceDelegate.h"
#import "GitHubService.h"

@interface GitHubUserSearchService :
    NSObject <SearchService, GitHubServiceDelegate, NSCopying>
{
    NSObject<SearchServiceDelegate> * delegate;
    GitHubService * gitHubService;
    NSString * nextRequest;
    BOOL requestOutstanding;
}

@property (nonatomic, retain) NSObject<SearchServiceDelegate> * delegate;
@property (nonatomic, copy) NSString * nextRequest;

- (id)initWithGitHubService:(GitHubService *)gitHubService;

@end
