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
    [commitSelectorFactory release];
    [logInState release];
    [repoCache release];
    [commitCache release];
    [super dealloc];
}

- (NSObject<RepoSelector> *)
    createRepoSelectorWithNavigationController:
    (UINavigationController *)navigationController
{
    RepoViewController * repoViewController =
        [[RepoViewController alloc] initWithNibName:@"RepoView" bundle:nil];

    NetworkAwareViewController * networkAwareViewController =
        [[NetworkAwareViewController alloc]
        initWithTargetViewController:repoViewController];
        
    GitHubService * gitHubService = [gitHubServiceFactory createGitHubService];
    
    NSObject<CommitSelector> * commitSelector =
        [commitSelectorFactory
        createCommitSelectorWithNavigationController:navigationController];
    
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

@end
