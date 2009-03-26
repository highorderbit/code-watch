//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"
#import "LogInStateReader.h"
#import "PersistenceStore.h"
#import "FavoriteUsersViewController.h"
#import "UserCacheReader.h"
#import "UserCacheSetter.h"
#import "FavoriteUsersStateReader.h"
#import "FavoriteUsersStateSetter.h"

@interface CodeWatchAppController : NSObject
{
    IBOutlet NSObject<LogInMgr> * logInMgr;
    IBOutlet NSObject<LogInStateReader> * logInState;
    IBOutlet NSObject<PersistenceStore> * logInPersistenceStore;
    
    IBOutlet NSObject<PersistenceStore> * userCachePersistenceStore;
    IBOutlet NSObject<UserCacheReader> * userCacheReader;
    IBOutlet NSObject<UserCacheSetter> * userCacheSetter;
    
    IBOutlet NSObject<PersistenceStore> * newsFeedPersistenceStore;
    
    IBOutlet NSObject<PersistenceStore> * repoCachePersistenceStore;
    
    IBOutlet NSObject<PersistenceStore> * favoriteUsersPersistenceStore;
    IBOutlet UINavigationController * favoriteUsersNavController;
    IBOutlet FavoriteUsersViewController * favoriteUsersViewController;
    IBOutlet NSObject<FavoriteUsersStateReader> * favoriteUsersStateReader;
    IBOutlet NSObject<FavoriteUsersStateSetter> * favoriteUsersStateSetter;
}

- (void) start;
- (void) persistState;

@end
