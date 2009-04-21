//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"
#import "LogInState.h"
#import "PersistenceStore.h"
#import "NewsFeedDisplayMgrFactory.h"
#import "NewsFeedDisplayMgr.h"
#import "NewsFeedDisplayMgrDelegate.h"
#import "FavoriteUsersViewController.h"
#import "ConfigReader.h"
#import "FavoriteReposViewController.h"
#import "FavoriteReposState.h"
#import "GitHubServiceFactory.h"
#import "UserDisplayMgrFactory.h"
#import "RepoSelectorFactory.h"
#import "UIState.h"
#import "UIStatePersistenceStore.h"
#import "UserNetworkCache.h"

@interface CodeWatchAppController :
    NSObject <UITabBarDelegate, NewsFeedDisplayMgrDelegate>
{
    IBOutlet NSObject<ConfigReader> * configReader;
    
    IBOutlet NSObject<LogInMgr> * logInMgr;
    IBOutlet LogInState * logInState;
    IBOutlet NSObject<PersistenceStore> * logInPersistenceStore;
    
    IBOutlet NSObject<PersistenceStore> * userCachePersistenceStore;
    IBOutlet NSObject<PersistenceStore> * newsFeedPersistenceStore;
    IBOutlet NSObject<PersistenceStore> * userNetworkPersistenceStore;
    IBOutlet NSObject<PersistenceStore> * repoCachePersistenceStore;
    IBOutlet NSObject<PersistenceStore> * commitCachePersistenceStore;
    IBOutlet NSObject<PersistenceStore> * contactCachePersistenceStore;
    IBOutlet NSObject<PersistenceStore> * avatarCachePersistenceStore;
    
    IBOutlet NewsFeedDisplayMgrFactory * newsFeedDisplayMgrFactory;
    NewsFeedDisplayMgr * newsFeedDisplayMgr;

    IBOutlet UINavigationController * favoriteUsersNavController;
    IBOutlet FavoriteUsersViewController * favoriteUsersViewController;
    IBOutlet NetworkAwareViewController * favoriteUserNetworkAwareController;
    IBOutlet UserNetworkCache * userNetworkCache;

    IBOutlet NSObject<PersistenceStore> * favoriteReposPersistenceStore;    
    IBOutlet FavoriteReposViewController * favoriteReposViewController;
    IBOutlet FavoriteReposState * favoriteReposState;
    IBOutlet UINavigationController * favoriteReposNavController;
    
    IBOutlet GitHubServiceFactory * gitHubServiceFactory;

    IBOutlet UserDisplayMgrFactory * userDisplayMgrFactory;
    IBOutlet RepoSelectorFactory * repoSelectorFactory;
    
    IBOutlet UIState * uiState;
    IBOutlet UITabBarController * tabBarController;
    IBOutlet UIStatePersistenceStore * uiStatePersistenceStore;
}

- (void) start;
- (void) persistState;

@end
