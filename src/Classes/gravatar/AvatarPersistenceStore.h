//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceStore.h"
#import "AvatarCacheReader.h"
#import "AvatarCacheSetter.h"

@interface AvatarPersistenceStore : NSObject <PersistenceStore>
{
    IBOutlet id<AvatarCacheReader> cacheReader;
    IBOutlet id<AvatarCacheSetter> cacheSetter;
}

@end
