//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceStore.h"
#import "UserCacheReader.h"
#import "UserCacheSetter.h"

@interface UserPersistenceStore : NSObject <PersistenceStore>
{
    IBOutlet NSObject<UserCacheReader> * userCacheReader;
    IBOutlet NSObject<UserCacheSetter> * userCacheSetter;
}

@end
