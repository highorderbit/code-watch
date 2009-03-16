//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"
#import "LogInViewControllerDelegate.h"
#import "LogInStateSetter.h"
#import "GitHubDelegate.h"

@class LogInViewController;

@interface UILogInMgr : NSObject
                        <LogInMgr, LogInViewControllerDelegate, GitHubDelegate>
{
    IBOutlet UIViewController * rootViewController;
    LogInViewController * logInViewController;

    UINavigationController * navigationController;

    IBOutlet NSObject<LogInStateSetter> * logInStateSetter;
}

@property (nonatomic, retain) LogInViewController * logInViewController;
@property (nonatomic, retain) UINavigationController * navigationController;
@property (nonatomic, retain) NSObject<LogInStateSetter> * logInStateSetter;

@end
