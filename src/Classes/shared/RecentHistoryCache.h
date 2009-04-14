//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentHistoryCache : NSObject <NSFastEnumeration>
{
    NSMutableDictionary * recentlyViewed;
    
    // Helpers for managing history
    NSMutableArray * history;
    NSMutableDictionary * historyAppearances;
    
    NSInteger cacheLimit;
}

- (id)initWithCacheLimit:(NSInteger)cacheLimit;

- (void)setObject:(id)anObject forKey:(id)aKey;
- (id)objectForKey:(id)aKey;

- (NSDictionary *)allRecentlyViewed;

- (void)clear;

@end
