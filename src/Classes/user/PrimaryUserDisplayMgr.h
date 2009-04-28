//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkAwareViewController.h"
#import "UserViewController.h"
#import "UserViewControllerDelegate.h"
#import "UserCacheReader.h"
#import "LogInStateReader.h"
#import "GitHubServiceDelegate.h"
#import "GravatarServiceDelegate.h"
#import "NetworkAwareViewControllerDelegate.h"
#import "NewsFeedDisplayMgrDelegate.h"
#import "RepoSelector.h"
#import "ContactCacheSetter.h"
#import "AvatarCacheReader.h"
#import "RepoCacheReader.h"

@class NewsFeedDisplayMgrFactory, NewsFeedDisplayMgr;
@class GitHubService, GitHubServiceFactory;
@class GravatarService, GravatarServiceFactory;
@class FollowersDisplayMgr, FollowingDisplayMgr;
@class UserDisplayMgrFactory;

@interface PrimaryUserDisplayMgr :
    NSObject
    <NetworkAwareViewControllerDelegate, GitHubServiceDelegate,
    GravatarServiceDelegate, UserViewControllerDelegate,
    NewsFeedDisplayMgrDelegate>
{
    IBOutlet UINavigationController * navigationController;
    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet UserViewController * userViewController;
    
    IBOutlet NSObject<UserCacheReader> * userCache;
    IBOutlet NSObject<RepoCacheReader> * repoCache;
    IBOutlet NSObject<LogInStateReader> * logInState;
    IBOutlet NSObject<ContactCacheSetter> * contactCacheSetter;
    IBOutlet NSObject<AvatarCacheReader> * avatarCache;
    
    IBOutlet NSObject<RepoSelector> * repoSelector;

    IBOutlet NewsFeedDisplayMgrFactory * newsFeedDisplayMgrFactory;
    NewsFeedDisplayMgr * newsFeedDisplayMgr;
    
    IBOutlet GitHubService * gitHubService;
    IBOutlet GitHubServiceFactory * gitHubServiceFactory;

    GravatarService * gravatarService;
    IBOutlet GravatarServiceFactory * gravatarServiceFactory;

    IBOutlet UserDisplayMgrFactory * userDisplayMgrFactory;

    FollowersDisplayMgr * followersDisplayMgr;
    FollowingDisplayMgr * followingDisplayMgr;
    
    BOOL gitHubFailure;
    BOOL avatarFailure;
}

- (void)displayUserInfo;

@end
