//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "CodeWatchAppController.h"
#import "UserDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "UserViewController.h"
#import "FavoriteUsersDisplayMgr.h"

@interface CodeWatchAppController (Private)

- (void)loadStateFromPersistenceStores;

- (NSObject<UserDisplayMgr> *)
    createUserDisplayMgrWithNavigationContoller:
    (UINavigationController *)navigationController;
- (NetworkAwareViewController *)createNetworkAwareControllerWithTarget:target;
- (UserViewController *)createUserViewController;

@end

@implementation CodeWatchAppController

- (void)dealloc
{
    [logInMgr release];
    [logInState release];
    [logInPersistenceStore release];
    
    [userCachePersistenceStore release];
    [userCacheReader release];
    [userCacheSetter release];
    
    [newsFeedPersistenceStore release];
    
    [repoCachePersistenceStore release];
    
    [favoriteUsersPersistenceStore release];
    [favoriteUsersViewController release];
    [favoriteUsersStateReader release];
    [favoriteUsersStateSetter release];
    
    [super dealloc];
}

- (void)start
{
    [self loadStateFromPersistenceStores];
    
    NSObject<UserDisplayMgr> * userDisplayMgr =
        [self
        createUserDisplayMgrWithNavigationContoller:favoriteUsersNavController];
    FavoriteUsersDisplayMgr * favoriteUsersDisplayMgr =
        [[FavoriteUsersDisplayMgr alloc]
        initWithViewController:favoriteUsersViewController
        stateReader:favoriteUsersStateReader
        stateSetter:favoriteUsersStateSetter
        userDisplayMgr:userDisplayMgr];

    favoriteUsersViewController.delegate = favoriteUsersDisplayMgr;
    
    if ([logInState prompt])
        [logInMgr collectCredentials:self];
    else
        [logInMgr init];
}

- (void)persistState
{
    [logInPersistenceStore save];
    [userCachePersistenceStore save];
    [newsFeedPersistenceStore save];
    [repoCachePersistenceStore save];
    [favoriteUsersPersistenceStore save];
}

- (void)loadStateFromPersistenceStores
{
    [logInPersistenceStore load];
    [userCachePersistenceStore load];
    [newsFeedPersistenceStore load];
    [repoCachePersistenceStore load];
    [favoriteUsersPersistenceStore load];
}

- (NSObject<UserDisplayMgr> *)
    createUserDisplayMgrWithNavigationContoller:
    (UINavigationController *)navigationController;
{
    UserViewController * userViewController = [self createUserViewController];
    
    NetworkAwareViewController * networkAwareViewController =
        [self createNetworkAwareControllerWithTarget:userViewController];
        
    UIUserDisplayMgr * userDisplayMgr = [[UIUserDisplayMgr alloc]
        initWithNavigationController:navigationController
        networkAwareViewController:networkAwareViewController
        userViewController:userViewController
        userCacheReader:userCacheReader
        repoSelector:nil
        gitHubService:nil];
        
    userViewController.delegate = userDisplayMgr;
    networkAwareViewController.delegate = userDisplayMgr;
    
    return userDisplayMgr;
}

- (NetworkAwareViewController *)createNetworkAwareControllerWithTarget:target
{
    return [[NetworkAwareViewController alloc]
        initWithTargetViewController:target];
}

- (UserViewController *)createUserViewController
{
    return [[UserViewController alloc] initWithNibName:@"UserView" bundle:nil];
}

@end
