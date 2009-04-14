//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "CommitCache.h"

@implementation CommitCache

- (void)dealloc
{
    [recentHistoryCache release];
    [super dealloc];
}

- (void)awakeFromNib
{
    // We receive 30 commits per repo; 30 x 4 = 120 lets us keep around 4 repos
    // in memory. Adjust upwards further if necessary.
    recentHistoryCache = [[RecentHistoryCache alloc] initWithCacheLimit:120];
}

#pragma mark CommitCacheReader implementation

- (CommitInfo *)commitWithKey:(NSString *)key
{
    return [recentHistoryCache objectForKey:key];
}

- (NSDictionary *)allCommits
{
    return [recentHistoryCache allRecentlyViewed];
}

#pragma mark CommitCacheSetter implementation

- (void)setCommit:(CommitInfo*)commit forKey:(NSString *)key
{
    [recentHistoryCache setObject:commit forKey:key];
}

- (void)clear
{
    [recentHistoryCache clear];
}

@end
