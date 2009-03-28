//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "CodeWatchAppController.h"
#import "UserDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "UserViewController.h"
#import "FavoriteUsersDisplayMgr.h"
#import "RepoDisplayMgr.h"
#import "RepoViewController.h"
#import "UIRecentActivityDisplayMgr.h"
#import "CommitDisplayMgr.h"
#import "CommitViewController.h"
#import "FavoriteReposDisplayMgr.h"

@interface CodeWatchAppController (Private)

- (void)loadStateFromPersistenceStores;

- (void)createAndInitFavoriteUsersDisplayMgr;
- (void)createAndInitFavoriteReposDisplayMgr;

- (GitHubService *)createGitHubService;

- (NSObject<UserDisplayMgr> *)
    createUserDisplayMgrWithNavigationContoller:
    (UINavigationController *)navigationController;
- (NSObject<RepoSelector> *)
    createRepoSelectorWithNavigationController:
    (UINavigationController *)navigationController;
- (NSObject<RecentActivityDisplayMgr> *)
    createRecentActivityDisplayMgrWithNavigationController:
    (UINavigationController *)navigationController;
- (NSObject<CommitSelector> *)
    createCommitSelectorWithNavigationController:
    (UINavigationController *)navigationController;

- (UserViewController *)createUserViewController;
- (RepoViewController *)createRepoViewController;
- (CommitViewController *)createCommitViewController;
- (NewsFeedTableViewController *)createNewsFeedTableViewController;
- (NetworkAwareViewController *)createNetworkAwareControllerWithTarget:target;

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
    
    [commitCachePersistenceStore release];
    [commitCache release];
    
    [favoriteUsersPersistenceStore release];
    [favoriteUsersViewController release];
    [favoriteUsersState release];
    
    [favoriteReposPersistenceStore release];
    [favoriteReposViewController release];
    [favoriteReposState release];
    
    [super dealloc];
}

- (void)start
{
    [self loadStateFromPersistenceStores];

    [self createAndInitFavoriteUsersDisplayMgr];
    [self createAndInitFavoriteReposDisplayMgr];

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
    [commitCachePersistenceStore save];
    [favoriteUsersPersistenceStore save];
    [favoriteReposPersistenceStore save];
}

- (void)loadStateFromPersistenceStores
{
    [logInPersistenceStore load];
    [userCachePersistenceStore load];
    [newsFeedPersistenceStore load];
    [repoCachePersistenceStore load];
    [commitCachePersistenceStore load];
    [favoriteUsersPersistenceStore load];
    [favoriteReposPersistenceStore load];
}

#pragma mark Initialization methods

- (void)createAndInitFavoriteUsersDisplayMgr
{
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
}

- (void)createAndInitFavoriteReposDisplayMgr
{
    FavoriteReposDisplayMgr * favoriteReposDisplayMgr =
        [[FavoriteReposDisplayMgr alloc]
        initWithViewController:favoriteReposViewController
        stateReader:favoriteReposState
        stateSetter:favoriteReposState];
    
    favoriteReposViewController.delegate = favoriteReposDisplayMgr;
}

#pragma mark Factory methods

- (GitHubService *)createGitHubService
{
    return [[GitHubService alloc] initWithConfigReader:configReader
        logInState:logInState userCache:userCache repoCache:repoCache
        commitCache:commitCache];
}

#pragma mark Display manager factory methods

- (NSObject<UserDisplayMgr> *)
    createUserDisplayMgrWithNavigationContoller:
    (UINavigationController *)navigationController
{
    UserViewController * userViewController = [self createUserViewController];
    userViewController.recentActivityDisplayMgr =
        [self createRecentActivityDisplayMgrWithNavigationController:
        navigationController];
    
    NetworkAwareViewController * networkAwareViewController =
        [self createNetworkAwareControllerWithTarget:userViewController];
    
    GitHubService * gitHubService = [self createGitHubService];
    
    NSObject<RepoSelector> * repoSelector =
        [self createRepoSelectorWithNavigationController:navigationController];
    
    UIUserDisplayMgr * userDisplayMgr =
        [[UIUserDisplayMgr alloc]
        initWithNavigationController:navigationController
        networkAwareViewController:networkAwareViewController
        userViewController:userViewController userCacheReader:userCache
        repoSelector:repoSelector gitHubService:gitHubService];
        
    userViewController.delegate = userDisplayMgr;
    networkAwareViewController.delegate = userDisplayMgr;
    gitHubService.delegate = userDisplayMgr;
    
    return userDisplayMgr;
}

- (NSObject<RepoSelector> *)
    createRepoSelectorWithNavigationController:
    (UINavigationController *)navigationController
{
    RepoViewController * repoViewController = [self createRepoViewController];

    NetworkAwareViewController * networkAwareViewController =
        [self createNetworkAwareControllerWithTarget:repoViewController];

    GitHubService * gitHubService = [self createGitHubService];
    
    NSObject<CommitSelector> * commitSelector =
        [self createCommitSelectorWithNavigationController:
        navigationController];
    
    RepoDisplayMgr * repoDisplayMgr = 
        [[RepoDisplayMgr alloc] initWithLogInStateReader:logInState
        repoCacheReader:repoCache commitCacheReader:commitCache
        navigationController:navigationController
        networkAwareViewController:networkAwareViewController
        repoViewController:repoViewController gitHubService:gitHubService
        commitSelector:commitSelector];
        
    repoViewController.delegate = repoDisplayMgr;
    gitHubService.delegate = repoDisplayMgr;
        
    return repoDisplayMgr;
}

- (NSObject<CommitSelector> *)
    createCommitSelectorWithNavigationController:
    (UINavigationController *)navigationController
{
    CommitViewController * commitViewController =
        [self createCommitViewController];
        
    NetworkAwareViewController * networkAwareViewController =
        [self createNetworkAwareControllerWithTarget:commitViewController];
    
    GitHubService * gitHubService = [self createGitHubService];
        
    CommitDisplayMgr * commitDisplayMgr =
        [[CommitDisplayMgr alloc]
        initWithNavigationController:navigationController
        networkAwareViewController:networkAwareViewController
        commitViewController:commitViewController
        commitCacheReader:commitCache
        gitHubService:gitHubService];
    
    commitViewController.delegate = commitDisplayMgr;
    gitHubService.delegate = commitDisplayMgr;
    
    return commitDisplayMgr;
}

- (NSObject<RecentActivityDisplayMgr> *)
    createRecentActivityDisplayMgrWithNavigationController:
    (UINavigationController *)navigationController
{
    NewsFeedTableViewController * newsFeedViewController =
        [self createNewsFeedTableViewController];

    NetworkAwareViewController * networkAwareViewController =
        [self createNetworkAwareControllerWithTarget:newsFeedViewController];
        
    GitHubService * gitHubService = [self createGitHubService];
        
    UIRecentActivityDisplayMgr * recentActivityDisplayMgr =
        [[UIRecentActivityDisplayMgr alloc]
        initWithNavigationController:navigationController
        networkAwareViewController:networkAwareViewController
        newsFeedTableViewController:newsFeedViewController
        gitHubService:gitHubService];
    
    return recentActivityDisplayMgr;
}

#pragma mark View controller factory methods

- (UserViewController *)createUserViewController
{
    UserViewController * userViewController =
        [[UserViewController alloc] initWithNibName:@"UserView" bundle:nil];
    userViewController.favoriteUsersStateReader = favoriteUsersState;
    userViewController.favoriteUsersStateSetter = favoriteUsersState;
    
    return userViewController;
}

- (RepoViewController *)createRepoViewController
{
    return [[RepoViewController alloc] initWithNibName:@"RepoView" bundle:nil];
}

- (CommitViewController *)createCommitViewController
{
    return [[CommitViewController alloc]
        initWithNibName:@"CommitView" bundle:nil];
}

- (NewsFeedTableViewController *)createNewsFeedTableViewController
{
    return [[NewsFeedTableViewController alloc] init];
}

- (NetworkAwareViewController *)createNetworkAwareControllerWithTarget:target
{
    return [[NetworkAwareViewController alloc]
        initWithTargetViewController:target];
}

@end
