//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "NewsFeedCache.h"
#import "RecentHistoryCache.h"

static NSString * PRIMARY_USER_NEWS_FEED_KEY = @"code-watch-news-feed";

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
        userItems = [[RecentHistoryCache alloc] initWithCacheLimit:3];
    }

    return self;
}

#pragma mark CommitCacheReader implementation

- (NSArray *)primaryUserNewsFeed
{
    return [primaryUserItems objectForKey:PRIMARY_USER_NEWS_FEED_KEY];
}

- (NSArray *)activityFeedForUsername:(NSString *)username
{
    return [userItems objectForKey:username];
}

- (NSDictionary *)allActivityFeeds
{
    return [userItems allRecentlyViewed];
}

#pragma mark CommitCacheSetter implementation

- (void)setPrimaryUserNewsFeed:(NSArray *)newsFeed
{
    [primaryUserItems setObject:newsFeed forKey:PRIMARY_USER_NEWS_FEED_KEY];
}

- (void)setActivityFeed:(NSArray *)activityFeed forUsername:(NSString *)username
{
    [userItems setObject:activityFeed forKey:username];
}

- (void)clear
{
    [primaryUserItems clear];
    [userItems clear];
}

@end
