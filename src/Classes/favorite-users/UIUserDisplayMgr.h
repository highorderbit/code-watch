//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/ABNewPersonViewController.h>
#import "NetworkAwareViewController.h"
#import "UserViewController.h"
#import "UserViewControllerDelegate.h"
#import "UserCacheReader.h"
#import "AvatarCacheReader.h"
#import "LogInStateReader.h"
#import "NetworkAwareViewControllerDelegate.h"
#import "NewsFeedDisplayMgrDelegate.h"
#import "RepoSelector.h"
#import "UserDisplayMgr.h"
#import "ContactCacheSetter.h"
#import "GitHubServiceDelegate.h"
#import "GravatarServiceDelegate.h"

@class NewsFeedDisplayMgrFactory, NewsFeedDisplayMgr;
@class GitHubService, GitHubServiceFactory, GravatarService;
@class UserDisplayMgrFactory, FollowersDisplayMgr, FollowingDisplayMgr;

@interface UIUserDisplayMgr :
    NSObject
    <GitHubServiceDelegate, GravatarServiceDelegate,
    UserViewControllerDelegate, UserDisplayMgr, NewsFeedDisplayMgrDelegate>
{
    UINavigationController * navigationController;
    NetworkAwareViewController * networkAwareViewController;
    UserViewController * userViewController;
    
    NSObject<UserCacheReader> * userCacheReader;
    NSObject<RepoSelector> * repoSelector;

    NSObject<AvatarCacheReader> * avatarCacheReader;

    GitHubService * gitHubService;
    GravatarService * gravatarService;
    
    NSObject<ContactCacheSetter> * contactCacheSetter;

    NewsFeedDisplayMgrFactory * newsFeedDisplayMgrFactory;
    NewsFeedDisplayMgr * newsFeedDisplayMgr;
    
    GitHubServiceFactory * gitHubServiceFactory;
    UserDisplayMgrFactory * userDisplayMgrFactory;
    FollowersDisplayMgr * followersDisplayMgr;
    FollowingDisplayMgr * followingDisplayMgr;

    NSString * username;
    
    BOOL gitHubFailure;
    BOOL avatarFailure;
}

- (id)initWithNavigationController:
    (UINavigationController *)navigationController
    networkAwareViewController:
    (NetworkAwareViewController *)aNetworkAwareViewController
    userViewController:
    (UserViewController *)aUserViewController
    userCacheReader:
    (NSObject<UserCacheReader> *)aUserCacheReader
    avatarCacheReader:
    (NSObject<AvatarCacheReader> *)anAvatarCacheReader
    repoSelector:
    (NSObject<RepoSelector> *)aRepoSelector
    gitHubService:
    (GitHubService *)aGitHubService
    gravatarService:
    (GravatarService *)aGravatarService
    contactCacheSetter:
    (NSObject<ContactCacheSetter> *)aContactCacheSetter
    newsFeedDisplayMgrFactory:
    (NewsFeedDisplayMgrFactory *)aNewsFeedDisplayMgrFactory
    gitHubServiceFactory:
    (GitHubServiceFactory *)aGitHubServiceFactory
    userDisplayMgrFactory:
    (UserDisplayMgrFactory *)aUserDisplayMgrFactory;
    
- (void)displayUserInfo;
    
@end
