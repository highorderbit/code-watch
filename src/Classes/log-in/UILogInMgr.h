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

@class GitHubService;
@class LogInViewController;

@interface UILogInMgr :
    NSObject <LogInMgr, LogInViewControllerDelegate, GitHubServiceDelegate>
{
    IBOutlet UIViewController * rootViewController;

    UINavigationController * navigationController;
    LogInViewController * logInViewController;
    WebViewController * helpViewController;
    
    IBOutlet UIBarButtonItem * homeBarButtonItem;
    IBOutlet UIBarButtonItem * userBarButtonItem;
    IBOutlet UITabBarItem * userTabBarItem;

    IBOutlet NSObject<LogInStateSetter> * logInStateSetter;
    IBOutlet NSObject<LogInStateReader> * logInStateReader;
    IBOutlet NSObject<UserCacheSetter> * userCacheSetter;

    IBOutlet GitHubService * gitHub;

    BOOL connecting;
}

@property (nonatomic, retain) UINavigationController * navigationController;
@property (nonatomic, retain) LogInViewController * logInViewController;
@property (nonatomic, retain) WebViewController * helpViewController;

// Neede re-definition to work in interface builder
- (IBAction)collectCredentials:(id)sender;

@end