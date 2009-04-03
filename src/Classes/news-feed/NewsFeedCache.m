//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "NewsFeedCache.h"
#import "RecentHistoryCache.h"

static NSString * PRIMARY_USER_NEWS_FEED_KEY = @"news-feed";

@implementation NewsFeedCache

- (void)dealloc
{
    [primaryUserItems release];
    [userItems release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        primaryUserItems = [[RecentHistoryCache alloc] init];
        userItems = [[RecentHistoryCache alloc] init];
    }

    return self;
}

#pragma mark CommitCacheReader implementation

- (NSArray *)primaryUserNewsFeed
{
    return [primaryUserItems objectForKey:PRIMARY_USER_NEWS_FEED_KEY];
}

- (NSArray *)newsFeedForUsername:(NSString *)username
{
    return [userItems objectForKey:username];
}

#pragma mark CommitCacheSetter implementation

- (void)setPrimaryUserNewsFeed:(NSArray *)newsFeed
{
    [primaryUserItems setObject:newsFeed forKey:PRIMARY_USER_NEWS_FEED_KEY];
}

- (void)setNewsFeed:(NSArray *)newsFeed forUsername:(NSString *)username
{
    [userItems setObject:newsFeed forKey:username];
}

@end
