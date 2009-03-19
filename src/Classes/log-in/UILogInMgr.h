//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"
#import "LogInViewControllerDelegate.h"
#import "ConfigReader.h"
#import "LogInStateSetter.h"
#import "LogInStateReader.h"
#import "GitHubDelegate.h"
#import "UserCacheSetter.h"
#import "RepoCacheSetter.h"

@class GitHub;
@class LogInViewController;
@class LogInHelpViewController;

@interface UILogInMgr :
    NSObject <LogInMgr, LogInViewControllerDelegate, GitHubDelegate>
{
    IBOutlet UIViewController * rootViewController;

    UINavigationController * navigationController;
    LogInViewController * logInViewController;
    LogInHelpViewController * logInHelpViewController;
    
    IBOutlet UIBarButtonItem * homeBarButtonItem;
    IBOutlet UIBarButtonItem * userBarButtonItem;
    IBOutlet UITabBarItem * userTabBarItem;

    IBOutlet NSObject<ConfigReader> * configReader;
    IBOutlet NSObject<LogInStateSetter> * logInStateSetter;
    IBOutlet NSObject<LogInStateReader> * logInStateReader;
    IBOutlet NSObject<UserCacheSetter> * userCacheSetter;
    IBOutlet NSObject<RepoCacheSetter> * repoCacheSetter;

    GitHub * gitHub;

    BOOL connecting;
}

@property (nonatomic, retain) UINavigationController * navigationController;
@property (nonatomic, retain) LogInViewController * logInViewController;
@property (nonatomic, retain) LogInHelpViewController * logInHelpViewController;
@property (nonatomic, retain) NSObject<LogInStateSetter> * logInStateSetter;

// Neede re-definition to work in interface builder
- (IBAction)collectCredentials:(id)sender;

@end
