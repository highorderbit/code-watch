//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommitCacheReader.h"
#import "CommitCacheSetter.h"
#import "RecentHistoryCache.h"

@interface CommitCache : NSObject <CommitCacheReader, CommitCacheSetter>
{
    RecentHistoryCache * recentHistoryCache;
}

@end
