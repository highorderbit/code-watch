//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceStore.h"
#import "CommitCacheReader.h"
#import "CommitCacheSetter.h"

@interface CommitPersistenceStore : NSObject <PersistenceStore>
{
    IBOutlet NSObject<CommitCacheReader> * cacheReader;
    IBOutlet NSObject<CommitCacheSetter> * cacheSetter;
}

@end
