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
#import "RepoSelector.h"
#import "ContactCacheSetter.h"
#import "AvatarCacheReader.h"

@class GitHubService, GravatarService, GravatarServiceFactory;

@interface PrimaryUserDisplayMgr :
    NSObject
    <NetworkAwareViewControllerDelegate, GitHubServiceDelegate,
    GravatarServiceDelegate, UserViewControllerDelegate>
{
    IBOutlet UINavigationController * navigationController;
    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet UserViewController * userViewController;
    
    IBOutlet NSObject<UserCacheReader> * userCache;
    IBOutlet NSObject<LogInStateReader> * logInState;
    IBOutlet NSObject<ContactCacheSetter> * contactCacheSetter;
    IBOutlet NSObject<AvatarCacheReader> * avatarCache;
    
    IBOutlet NSObject<RepoSelector> * repoSelector;
    
    IBOutlet GitHubService * gitHubService;

    GravatarService * gravatarService;
    IBOutlet GravatarServiceFactory * gravatarServiceFactory;
}

- (void)displayUserInfo;

@end
