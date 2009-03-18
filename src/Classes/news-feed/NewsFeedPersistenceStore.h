//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceStore.h"
#import "NewsFeedCacheReader.h"
#import "NewsFeedCacheSetter.h"

@interface NewsFeedPersistenceStore : NSObject <PersistenceStore>
{
    IBOutlet NSObject<NewsFeedCacheReader> * cacheReader;
    IBOutlet NSObject<NewsFeedCacheSetter> * cacheSetter;
}

@end
