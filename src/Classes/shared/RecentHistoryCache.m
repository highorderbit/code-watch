//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "RecentHistoryCache.h"

@implementation RecentHistoryCache

- (void)dealloc
{
    [recentlyViewed release];
    [history release];
    [historyAppearances release];
    [super dealloc];
}

- (id)init
{
    return [self initWithCacheLimit:50];
}

- (id)initWithCacheLimit:(NSInteger)aCacheLimit
{
    if (self = [super init]) {
        recentlyViewed = [[NSMutableDictionary alloc] init];
        history = [[NSMutableArray alloc] init];
        historyAppearances = [[NSMutableDictionary alloc] init];
        cacheLimit = aCacheLimit;
    }

    return self;
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
    [recentlyViewed setObject:anObject forKey:aKey];
    
    [history insertObject:aKey atIndex:0];
    
    NSNumber * numAppearances = [historyAppearances objectForKey:aKey];
    if (numAppearances) {
        NSInteger appearancesAsInt = [numAppearances integerValue] + 1;
        numAppearances = [NSNumber numberWithInteger:appearancesAsInt];
        [historyAppearances setObject:numAppearances forKey:aKey];
    } else
        [historyAppearances setObject:[NSNumber numberWithInteger:1]
            forKey:aKey];

    if ([history count] > cacheLimit) {
        id oldestKey = [[history objectAtIndex:cacheLimit] retain];
        [history removeObjectAtIndex:cacheLimit];
        NSInteger oldestNumAppearances =
            [[historyAppearances objectForKey:oldestKey] integerValue] - 1;
        
        if (oldestNumAppearances == 0) {
            [historyAppearances removeObjectForKey:oldestKey];
            [recentlyViewed removeObjectForKey:oldestKey];
        } else
            [historyAppearances
                setObject:[NSNumber numberWithInteger:oldestNumAppearances]
                forKey:oldestKey];

        [oldestKey release];
    }
}

- (id)objectForKey:(id)aKey
{
    return [recentlyViewed objectForKey:aKey];
}

- (NSDictionary *)allRecentlyViewed
{
    return [[recentlyViewed copy] autorelease];
}

- (void)clear
{
    [recentlyViewed removeAllObjects];
    [history removeAllObjects];
    [historyAppearances removeAllObjects];
}

#pragma mark NSFastEnumeration implementation

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id *)stackbuf
                                    count:(NSUInteger)len
{
    return [recentlyViewed
        countByEnumeratingWithState:state objects:stackbuf count:len];
}

@end
