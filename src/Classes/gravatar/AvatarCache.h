//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvatarCacheReader.h"
#import "AvatarCacheSetter.h"

@class RecentHistoryCache;

@interface AvatarCache : NSObject <AvatarCacheReader, AvatarCacheSetter>
{
    RecentHistoryCache * cache;
}

@end
