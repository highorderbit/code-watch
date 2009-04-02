//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "GitHubSearchService.h"

@interface GitHubSearchService (Private)

+ (NSArray *)mergeResults:(NSDictionary *)results;

+ (NSString *)userServiceKey;
+ (NSString *)repoServiceKey;

@end

@implementation GitHubSearchService

@synthesize delegate;

@synthesize searchText;

- (void)dealloc
{
    [searchResults release];
    [userService release];
    [repoService release];
    [searchText release];
    [super dealloc];
}

- (id)initWithUserService:(GitHubUserSearchService *)aUserService
    repoService:(GitHubRepoSearchService *)aRepoService
{
    if (self = [super init]) {
        userService = [aUserService retain];
        repoService = [aRepoService retain];
        
        searchResults = [[NSMutableDictionary dictionary] retain];
        [searchResults setObject:[NSArray array]
            forKey:[[self class] userServiceKey]];
        [searchResults setObject:[NSArray array]
            forKey:[[self class] repoServiceKey]];
    }

    return self;
}

#pragma mark SearchService implementation

- (void)searchForText:(NSString *)text
{
    self.searchText = text;
    [userService searchForText:text];
    [repoService searchForText:text];
}

#pragma mark SearchServiceDelegate implementation

- (void)processSearchResults:(NSDictionary *)results
    withSearchText:(NSString *)text
    fromSearchService:(NSObject<SearchService> *)searchService
{
    if ([text isEqual:self.searchText]) {
        NSArray * mergedResults = [[self class] mergeResults:results];
        if (searchService == userService)
            [searchResults setObject:mergedResults
                forKey:[[self class] userServiceKey]];
        else // repo search service
            [searchResults setObject:mergedResults
                forKey:[[self class] repoServiceKey]];

        [delegate processSearchResults:searchResults withSearchText:text
            fromSearchService:self];
    }
}

#pragma mark Static helpers

+ (NSArray *)mergeResults:(NSDictionary *)results
{
    NSMutableArray * mergedResults = [NSMutableArray array];
    for (NSArray * array in [results allValues])
        [mergedResults addObjectsFromArray:array];
    
    return mergedResults;
}

#pragma mark Search result keys

+ (NSString *)userServiceKey
{
    return @"User";
}

+ (NSString *)repoServiceKey
{
    return @"Repositories";
}

@end
