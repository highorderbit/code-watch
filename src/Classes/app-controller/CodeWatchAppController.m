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
- (GitHubService *)createGitHubService;

@end

@implementation CodeWatchAppController

- (void)dealloc
{
    [configReader release];
    [logInMgr release];
    [logInState release];
    [logInPersistenceStore release];
    
    [userCachePersistenceStore release];
    [userCache release];
    
    [newsFeedPersistenceStore release];
    
    [repoCachePersistenceStore release];
    [repoCache release];
    
    [commitCache release];
    
    [favoriteUsersPersistenceStore release];
    [favoriteUsersViewController release];
    [favoriteUsersState release];
    
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
        stateReader:favoriteUsersState
        stateSetter:favoriteUsersState
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
    
    GitHubService * gitHubService = [self createGitHubService];
    
    UIUserDisplayMgr * userDisplayMgr = [[UIUserDisplayMgr alloc]
        initWithNavigationController:navigationController
        networkAwareViewController:networkAwareViewController
        userViewController:userViewController
        userCacheReader:userCache
        repoSelector:nil
        gitHubService:gitHubService];
        
    userViewController.delegate = userDisplayMgr;
    networkAwareViewController.delegate = userDisplayMgr;
    gitHubService.delegate = userDisplayMgr;
    
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

- (GitHubService *)createGitHubService
{
    return [[GitHubService alloc] initWithConfigReader:configReader
        logInState:logInState userCache:userCache repoCache:repoCache
        commitCache:commitCache];
}

@end
