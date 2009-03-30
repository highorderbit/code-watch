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
#import "FavoriteReposViewController.h"
#import "FavoriteReposState.h"
#import "GitHubServiceFactory.h"

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
    
    IBOutlet NSObject<PersistenceStore> * commitCachePersistenceStore;
    IBOutlet CommitCache * commitCache;
    
    IBOutlet NSObject<PersistenceStore> * favoriteUsersPersistenceStore;
    IBOutlet UINavigationController * favoriteUsersNavController;
    IBOutlet FavoriteUsersViewController * favoriteUsersViewController;
    IBOutlet FavoriteUsersState * favoriteUsersState;

    IBOutlet NSObject<PersistenceStore> * favoriteReposPersistenceStore;    
    IBOutlet FavoriteReposViewController * favoriteReposViewController;
    IBOutlet FavoriteReposState * favoriteReposState;
    IBOutlet UINavigationController * favoriteReposNavController;
    
    IBOutlet GitHubServiceFactory * gitHubServiceFactory;
}

- (void) start;
- (void) persistState;

@end
