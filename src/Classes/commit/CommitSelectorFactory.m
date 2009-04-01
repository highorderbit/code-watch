//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "CommitSelectorFactory.h"
#import "CommitViewController.h"
#import "NetworkAwareViewController.h"
#import "CommitDisplayMgr.h"

@implementation CommitSelectorFactory

- (void)dealloc
{
    [gitHubServiceFactory release];
    [commitCache release];
    [super dealloc];
}

- (NSObject<CommitSelector> *)
    createCommitSelectorWithNavigationController:
    (UINavigationController *)navigationController
{
    CommitViewController * commitViewController =
        [[CommitViewController alloc]
        initWithNibName:@"CommitView" bundle:nil];
        
    NetworkAwareViewController * networkAwareViewController =
        [[NetworkAwareViewController alloc]
        initWithTargetViewController:commitViewController];
    
    GitHubService * gitHubService = [gitHubServiceFactory createGitHubService];
        
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

@end
