//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"
#import "LogInViewControllerDelegate.h"
#import "LogInStateSetter.h"
#import "GitHubServiceDelegate.h"

@class GitHubService;
@class LogInViewController;

@interface UILogInMgr :
    NSObject <LogInMgr, LogInViewControllerDelegate, GitHubServiceDelegate>
{
    IBOutlet UIViewController * rootViewController;
    LogInViewController * logInViewController;

    UINavigationController * navigationController;

    IBOutlet GitHubService * gitHub;
    IBOutlet NSObject<LogInStateSetter> * logInStateSetter;
}

@property (nonatomic, retain) LogInViewController * logInViewController;
@property (nonatomic, retain) UINavigationController * navigationController;
@property (nonatomic, retain) GitHubService * gitHub;
@property (nonatomic, retain) NSObject<LogInStateSetter> * logInStateSetter;

// Neede re-definition to work in interface builder
- (IBAction)collectCredentials:(id)sender;

@end
