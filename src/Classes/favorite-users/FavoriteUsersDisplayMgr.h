//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteUsersViewControllerDelegate.h"
#import "FavoriteUsersViewController.h"
#import "UserViewController.h"
#import "NetworkAwareViewController.h"
#import "UIUserDisplayMgr.h"
#import "GitHubService.h"
#import "UserNetworkCacheReader.h"

@interface FavoriteUsersDisplayMgr :
    NSObject
    <FavoriteUsersViewControllerDelegate, NetworkAwareViewControllerDelegate,
    GitHubServiceDelegate>
{
    FavoriteUsersViewController * viewController;
    NetworkAwareViewController * networkAwareViewController;
    
    NSObject<UserDisplayMgr> * userDisplayMgr;
    NSObject<LogInStateReader> * logInState;
    GitHubService * gitHubService;
    NSObject<UserNetworkCacheReader> * userNetworkCacheReader;

    BOOL gitHubFailure;
}

- (id)initWithViewController:
    (FavoriteUsersViewController *)viewController
    networkAwareViewController:
    (NetworkAwareViewController *)networkAwareViewController
    userDisplayMgr:
    (NSObject<UserDisplayMgr> *)userDisplayMgr
    logInState:
    (NSObject<LogInStateReader> *)logInState
    gitHubService:
    (GitHubService *)gitHubService
    userNetworkCacheReader:
    (NSObject<UserNetworkCacheReader> *)userNetworkCacheReader;

@end
