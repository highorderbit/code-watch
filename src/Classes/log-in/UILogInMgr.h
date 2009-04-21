//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"
#import "LogInViewControllerDelegate.h"
#import "LogInStateSetter.h"
#import "LogInStateReader.h"
#import "UserCacheSetter.h"
#import "GitHubServiceDelegate.h"
#import "WebViewController.h"
#import "RepoCacheSetter.h"
#import "CommitCacheSetter.h"
#import "NewsFeedCacheSetter.h"

@class GitHubService;
@class LogInViewController;

@interface UILogInMgr :
    NSObject
    <LogInMgr, LogInViewControllerDelegate, GitHubServiceDelegate,
    UIActionSheetDelegate>
{
    IBOutlet UIViewController * rootViewController;

    UINavigationController * navigationController;
    LogInViewController * logInViewController;
    WebViewController * helpViewController;
    
    IBOutlet UIBarButtonItem * homeBarButtonItem;
    IBOutlet UIBarButtonItem * userBarButtonItem;
    IBOutlet UIBarButtonItem * followedUsersBarButtonItem;
    IBOutlet UITabBarItem * userTabBarItem;
    IBOutlet UINavigationItem * homeNavigationItem;
    IBOutlet UINavigationItem * userNavigationItem;
    IBOutlet UINavigationItem * followedUsersNavigationItem;
    
    IBOutlet UINavigationController * homeNavigationController;
    IBOutlet UINavigationController * userNavigationController;
    IBOutlet UINavigationController * favoriteUsersNavigationController;
    IBOutlet UINavigationController * favoriteReposNavigationController;
    IBOutlet UINavigationController * searchNavigationController;
    
    UIBarButtonItem * homeRefreshButton;
    UIBarButtonItem * userRefreshButton;
    UIBarButtonItem * followedUsersRefreshButton;
    
    IBOutlet NSObject<LogInStateSetter> * logInStateSetter;
    IBOutlet NSObject<LogInStateReader> * logInStateReader;
    IBOutlet NSObject<UserCacheSetter> * userCacheSetter;
    IBOutlet NSObject<RepoCacheSetter> * repoCacheSetter;
    IBOutlet NSObject<CommitCacheSetter> * commitCacheSetter;
    IBOutlet NSObject<NewsFeedCacheSetter> * newsFeedCacheSetter;

    IBOutlet GitHubService * gitHub;

    NSString * expectedUsername;
}

@property (nonatomic, retain) UINavigationController * navigationController;
@property (nonatomic, retain) LogInViewController * logInViewController;
@property (nonatomic, retain) WebViewController * helpViewController;
@property (nonatomic, copy) NSString * expectedUsername;
@property (nonatomic, retain) UIBarButtonItem * homeRefreshButton;
@property (nonatomic, retain) UIBarButtonItem * userRefreshButton;
@property (nonatomic, retain) UIBarButtonItem * followedUsersRefreshButton;

// Neede re-definition to work in interface builder
- (IBAction)collectCredentials:(id)sender;

@end