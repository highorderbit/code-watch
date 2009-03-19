//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceStore.h"
#import "RepoCacheReader.h"
#import "RepoCacheSetter.h"

@interface RepoPersistenceStore : NSObject <PersistenceStore>
{
    IBOutlet NSObject<RepoCacheReader> * cacheReader;
    IBOutlet NSObject<RepoCacheSetter> * cacheSetter;
}

@end
