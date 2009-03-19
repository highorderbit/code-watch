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

@class GitHubService;
@class LogInViewController;
@class LogInHelpViewController;

@interface UILogInMgr :
    NSObject <LogInMgr, LogInViewControllerDelegate, GitHubServiceDelegate>
{
    IBOutlet UIViewController * rootViewController;

    UINavigationController * navigationController;
    LogInViewController * logInViewController;
    LogInHelpViewController * logInHelpViewController;
    
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
@property (nonatomic, retain) LogInHelpViewController * logInHelpViewController;

// Neede re-definition to work in interface builder
- (IBAction)collectCredentials:(id)sender;

@end