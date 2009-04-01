//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "GitHubSearchService.h"

@interface GitHubSearchService (Private)

+ (NSArray *)filterResults:(NSArray *)results byText:(NSString *)text;
+ (NSArray *)mergeResults:(NSDictionary *)results;

+ (NSString *)userServiceKey;
+ (NSString *)repoServiceKey;

@end

@implementation GitHubSearchService

@synthesize delegate;

- (void)dealloc
{
    [searchResults release];
    [userService release];
    [lastSearchedText release];
    [super dealloc];
}

- (id)initWithUserService:(GitHubUserSearchService *)aUserService
{
    if (self = [super init]) {
        userService = [aUserService retain];
        searchResults = [[NSMutableDictionary dictionary] retain];
        [searchResults setObject:[NSArray array]
            forKey:[[self class] userServiceKey]];
    }

    return self;
}

#pragma mark SearchService implementation

- (void)searchForText:(NSString *)text
{
    [lastSearchedText release];
    lastSearchedText = [text copy];
    
    NSArray * userResults =
        [searchResults objectForKey:[[self class] userServiceKey]];
    NSArray * filteredUserResults =
        [[self class] filterResults:userResults byText:text];
    [searchResults setObject:filteredUserResults
        forKey:[[self class] userServiceKey]];

    // TODO: filter repo search results

    [delegate processSearchResults:searchResults fromSearchService:self];

    [userService searchForText:text];
}

#pragma mark SearchServiceDelegate implementation

- (void)processSearchResults:(NSDictionary *)results
    fromSearchService:(NSObject<SearchService> *)searchService
{
    NSArray * mergedResults = [[self class] mergeResults:results];
    NSArray * filteredResults =
        [[self class] filterResults:mergedResults byText:lastSearchedText];
    if (searchService == userService)
        [searchResults setObject:filteredResults
            forKey:[[self class] userServiceKey]];
    else // repo search service
        [searchResults setObject:filteredResults
            forKey:[[self class] repoServiceKey]];

    [delegate processSearchResults:searchResults fromSearchService:self];
}

#pragma mark Static helpers

+ (NSArray *)filterResults:(NSArray *)results byText:(NSString *)text
{
    const NSRange notFoundRange = NSMakeRange(NSNotFound, 0);
    
    NSMutableArray * filteredResults = [NSMutableArray array];
    
    for (NSString * result in results)
        if (!NSEqualRanges([result rangeOfString:text], notFoundRange))
            [filteredResults addObject:result];
    
    return filteredResults;
}

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
    return @"Users (exact matches)";
}

+ (NSString *)repoServiceKey
{
    return @"Repositories";
}

@end
