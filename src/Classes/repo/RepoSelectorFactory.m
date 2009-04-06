//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "RepoSelectorFactory.h"
#import "RepoViewController.h"
#import "NetworkAwareViewController.h"
#import "RepoDisplayMgr.h"
#import "GitHubService.h"

@implementation RepoSelectorFactory

- (void)dealloc
{
    [gitHubServiceFactory release];
    [gravatarServiceFactory release];
    [commitSelectorFactory release];
    [logInState release];
    [repoCache release];
    [commitCache release];
    [avatarCache release];
    [favoriteReposState release];
    [super dealloc];
}

- (NSObject<RepoSelector> *)
    createRepoSelectorWithNavigationController:
    (UINavigationController *)navigationController
{
    RepoViewController * repoViewController =
        [[[RepoViewController alloc] initWithNibName:@"RepoView" bundle:nil]
        autorelease];
    repoViewController.favoriteReposStateReader = favoriteReposState;
    repoViewController.favoriteReposStateSetter = favoriteReposState;

    NetworkAwareViewController * networkAwareViewController =
        [[[NetworkAwareViewController alloc]
        initWithTargetViewController:repoViewController] autorelease];
        
    GitHubService * gitHubService = [gitHubServiceFactory createGitHubService];
    
    NSObject<CommitSelector> * commitSelector =
        [commitSelectorFactory
        createCommitSelectorWithNavigationController:navigationController];
    
    RepoDisplayMgr * repoDisplayMgr = 
        [[[RepoDisplayMgr alloc] initWithLogInStateReader:logInState
        repoCacheReader:repoCache commitCacheReader:commitCache
        avatarCacheReader:avatarCache
        navigationController:navigationController
        networkAwareViewController:networkAwareViewController
        repoViewController:repoViewController gitHubService:gitHubService
        gravatarServiceFactory:gravatarServiceFactory
        commitSelector:commitSelector] autorelease];
        
    repoViewController.delegate = repoDisplayMgr;
    gitHubService.delegate = repoDisplayMgr;
        
    return repoDisplayMgr;
}

@end
