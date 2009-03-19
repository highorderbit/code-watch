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
    recentHistoryCache = [[RecentHistoryCache alloc] init];
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

@end
