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
#import "ContactCacheSetter.h"

@interface PrimaryUserDisplayMgr :
    NSObject
    <NetworkAwareViewControllerDelegate, GitHubServiceDelegate,
    UserViewControllerDelegate, ABNewPersonViewControllerDelegate>
{
    IBOutlet UINavigationController * navigationController;
    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet UserViewController * userViewController;
    
    IBOutlet NSObject<UserCacheReader> * userCache;
    IBOutlet NSObject<LogInStateReader> * logInState;
    IBOutlet NSObject<ContactCacheSetter> * contactCacheSetter;
    
    IBOutlet NSObject<RepoSelector> * repoSelector;
    
    IBOutlet GitHubService * gitHub;
}

@property (readonly) UIViewController * tabViewController;

@end
