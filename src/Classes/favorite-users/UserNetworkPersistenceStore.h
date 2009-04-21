//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceStore.h"
#import "UserNetworkCacheReader.h"
#import "UserNetworkCacheSetter.h"

@interface UserNetworkPersistenceStore : NSObject <PersistenceStore>
{
    IBOutlet NSObject<UserNetworkCacheReader> * userNetworkCacheReader;
    IBOutlet NSObject<UserNetworkCacheSetter> * userNetworkCacheSetter;
}

@end
