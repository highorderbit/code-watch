//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserDisplayMgrFactory.h"
#import "RecentActivityDisplayMgr.h"
#import "UserViewController.h"
#import "NetworkAwareViewController.h"
#import "UIUserDisplayMgr.h"
#import "NewsFeedTableViewController.h"
#import "UIRecentActivityDisplayMgr.h"
#import "GitHubService.h"
#import "GravatarService.h"

@interface UserDisplayMgrFactory (Private)

- (NSObject<RecentActivityDisplayMgr> *)
    createRecentActivityDisplayMgrWithNavigationController:
    (UINavigationController *)navigationController;
- (UserViewController *)createUserViewController;

@end

@implementation UserDisplayMgrFactory

- (void)dealloc
{
    [gitHubServiceFactory release];
    [gravatarServiceFactory release];
    [repoSelectorFactory release];
    [userCache release];
    [favoriteUsersState release];
    [super dealloc];
}

- (NSObject<UserDisplayMgr> *)
    createUserDisplayMgrWithNavigationContoller:
    (UINavigationController *)navigationController
{
    UserViewController * userViewController = [self createUserViewController];
    userViewController.recentActivityDisplayMgr =
        [self createRecentActivityDisplayMgrWithNavigationController:
        navigationController];
    
    NetworkAwareViewController * networkAwareViewController =
        [[NetworkAwareViewController alloc]
        initWithTargetViewController:userViewController];
    
    GitHubService * gitHubService = [gitHubServiceFactory createGitHubService];

    GravatarService * gravatarService =
        [gravatarServiceFactory createGravatarService];
    
    NSObject<RepoSelector> * repoSelector =
        [repoSelectorFactory
        createRepoSelectorWithNavigationController:navigationController];
    
    UIUserDisplayMgr * userDisplayMgr =
        [[UIUserDisplayMgr alloc]
        initWithNavigationController:navigationController
        networkAwareViewController:networkAwareViewController
        userViewController:userViewController userCacheReader:userCache
        repoSelector:repoSelector gitHubService:gitHubService
        gravatarService:gravatarService contactCacheSetter:contactCache];
        
    userViewController.delegate = userDisplayMgr;
    networkAwareViewController.delegate = userDisplayMgr;
    gitHubService.delegate = userDisplayMgr;
    gravatarService.delegate = userDisplayMgr;
    
    return userDisplayMgr;
}

- (NSObject<RecentActivityDisplayMgr> *)
    createRecentActivityDisplayMgrWithNavigationController:
    (UINavigationController *)navigationController
{
    NewsFeedTableViewController * newsFeedViewController =
        [[NewsFeedTableViewController alloc] init];

    NetworkAwareViewController * networkAwareViewController =
        [[NetworkAwareViewController alloc]
        initWithTargetViewController:newsFeedViewController];
        
    GitHubService * gitHubService = [gitHubServiceFactory createGitHubService];
        
    UIRecentActivityDisplayMgr * recentActivityDisplayMgr =
        [[UIRecentActivityDisplayMgr alloc]
        initWithNavigationController:navigationController
        networkAwareViewController:networkAwareViewController
        newsFeedTableViewController:newsFeedViewController
        gitHubService:gitHubService];
    
    return recentActivityDisplayMgr;
}

- (UserViewController *)createUserViewController
{
    UserViewController * userViewController =
        [[UserViewController alloc] initWithNibName:@"UserView" bundle:nil];
    userViewController.favoriteUsersStateReader = favoriteUsersState;
    userViewController.favoriteUsersStateSetter = favoriteUsersState;
    userViewController.contactCacheReader = contactCache;
    
    return userViewController;
}

@end
