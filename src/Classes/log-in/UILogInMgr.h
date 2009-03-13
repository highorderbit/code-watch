//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"
#import "LogInViewControllerDelegate.h"

@class LogInViewController;

@interface UILogInMgr : NSObject
                        <LogInMgr, LogInViewControllerDelegate>
{
    IBOutlet UIViewController * rootViewController;
    LogInViewController * logInViewController;

    UINavigationController * navigationController;
}

@property (nonatomic, retain) LogInViewController * logInViewController;
@property (nonatomic, retain) UINavigationController * navigationController;

@end
