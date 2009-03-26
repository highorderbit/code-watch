//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"
#import "LogInState.h"
#import "PersistenceStore.h"
#import "FavoriteUsersViewController.h"
#import "UserCache.h"
#import "FavoriteUsersState.h"
#import "ConfigReader.h"
#import "RepoCache.h"
#import "CommitCache.h"

@interface CodeWatchAppController : NSObject
{
    IBOutlet NSObject<ConfigReader> * configReader;
    
    IBOutlet NSObject<LogInMgr> * logInMgr;
    IBOutlet LogInState * logInState;
    IBOutlet NSObject<PersistenceStore> * logInPersistenceStore;
    
    IBOutlet NSObject<PersistenceStore> * userCachePersistenceStore;
    IBOutlet UserCache * userCache;
    
    IBOutlet NSObject<PersistenceStore> * newsFeedPersistenceStore;
    
    IBOutlet NSObject<PersistenceStore> * repoCachePersistenceStore;
    IBOutlet RepoCache * repoCache;
    
    IBOutlet CommitCache * commitCache;
    
    IBOutlet NSObject<PersistenceStore> * favoriteUsersPersistenceStore;
    IBOutlet UINavigationController * favoriteUsersNavController;
    IBOutlet FavoriteUsersViewController * favoriteUsersViewController;
    IBOutlet FavoriteUsersState * favoriteUsersState;
}

- (void) start;
- (void) persistState;

@end
