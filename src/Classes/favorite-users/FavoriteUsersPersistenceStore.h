//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceStore.h"
#import "FavoriteUsersStateReader.h"
#import "FavoriteUsersStateSetter.h"

@interface FavoriteUsersPersistenceStore : NSObject <PersistenceStore>
{
    IBOutlet NSObject<FavoriteUsersStateReader> * stateReader;
    IBOutlet NSObject<FavoriteUsersStateSetter> * stateSetter;
}

@end
