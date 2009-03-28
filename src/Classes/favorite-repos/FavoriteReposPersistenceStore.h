//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceStore.h"
#import "FavoriteReposStateReader.h"
#import "FavoriteReposStateSetter.h"

@interface FavoriteReposPersistenceStore : NSObject <PersistenceStore>
{
    IBOutlet NSObject<FavoriteReposStateReader> * stateReader;
    IBOutlet NSObject<FavoriteReposStateSetter> * stateSetter;
}

@end
