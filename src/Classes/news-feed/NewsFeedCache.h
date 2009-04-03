//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeedCacheReader.h"
#import "NewsFeedCacheSetter.h"

@class RecentHistoryCache;

@interface NewsFeedCache : NSObject <NewsFeedCacheReader, NewsFeedCacheSetter>
{
    RecentHistoryCache * primaryUserItems;
    RecentHistoryCache * userItems;
}

@end
