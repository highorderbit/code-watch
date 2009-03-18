//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeedCacheReader.h"
#import "NewsFeedCacheSetter.h"

@interface NewsFeedCache : NSObject <NewsFeedCacheReader, NewsFeedCacheSetter>
{
    NSArray * rssItems;
}

@end
