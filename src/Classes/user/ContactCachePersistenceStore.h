//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceStore.h"
#import "ContactCacheReader.h"
#import "ContactCacheSetter.h"

@interface ContactCachePersistenceStore : NSObject <PersistenceStore>
{
    IBOutlet NSObject<ContactCacheReader> * cacheReader;
    IBOutlet NSObject<ContactCacheSetter> * cacheSetter;
}

@end
