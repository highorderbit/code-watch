//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkAwareViewController.h"
#import "UserViewController.h"
#import "UserViewControllerDelegate.h"
#import "UserCacheReader.h"
#import "LogInStateReader.h"
#import "GitHubService.h"
#import "NetworkAwareViewControllerDelegate.h"
#import "RepoSelector.h"
#import "UserDisplayMgr.h"

@interface UIUserDisplayMgr :
    NSObject
    <NetworkAwareViewControllerDelegate, GitHubServiceDelegate,
    UserViewControllerDelegate, UserDisplayMgr>
{
    UINavigationController * navigationController;
    NetworkAwareViewController * networkAwareViewController;
    UserViewController * userViewController;
    
    NSObject<UserCacheReader> * userCacheReader;
    NSObject<RepoSelector> * repoSelector;
    GitHubService * gitHubService;
    
    NSString * username;
}

- (id)initWithNavigationController:
    (UINavigationController *)navigationController
    networkAwareViewController:
    (NetworkAwareViewController *)aNetworkAwareViewController
    userViewController:
    (UserViewController *)aUserViewController
    userCacheReader:
    (NSObject<UserCacheReader> *)aUserCacheReader
    repoSelector:
    (NSObject<RepoSelector> *)aRepoSelector
    gitHubService:
    (GitHubService *)aGitHubService;
    
@end
