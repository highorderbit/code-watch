//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/ABNewPersonViewController.h>
#import "NetworkAwareViewController.h"
#import "UserViewController.h"
#import "UserViewControllerDelegate.h"
#import "UserCacheReader.h"
#import "LogInStateReader.h"
#import "GitHubService.h"
#import "NetworkAwareViewControllerDelegate.h"
#import "RepoSelector.h"
#import "UserDisplayMgr.h"
#import "ContactCacheSetter.h"

@interface UIUserDisplayMgr :
    NSObject
    <NetworkAwareViewControllerDelegate, GitHubServiceDelegate,
    UserViewControllerDelegate, UserDisplayMgr,
    ABNewPersonViewControllerDelegate>
{
    UINavigationController * navigationController;
    NetworkAwareViewController * networkAwareViewController;
    UserViewController * userViewController;
    
    NSObject<UserCacheReader> * userCacheReader;
    NSObject<RepoSelector> * repoSelector;
    GitHubService * gitHubService;
    
    NSObject<ContactCacheSetter> * contactCacheSetter;
    
    NSString * username;
}

@property (readonly) UIViewController * tabViewController;

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
    (GitHubService *)aGitHubService
    contactCacheSetter:
    (NSObject<ContactCacheSetter> *)aContactCacheSetter;
    
- (void)displayUserInfo;
    
@end
