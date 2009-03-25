//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddUserMgr.h"
#import "AddUserViewControllerDelegate.h"
#import "AddUserViewController.h"
#import "LogInHelpViewController.h"

@interface UIAddUserMgr : NSObject <AddUserMgr, AddUserViewControllerDelegate>
{
    IBOutlet UIViewController * rootViewController;
    
    UINavigationController * navigationController;
    AddUserViewController * addUserViewController;
}

- (IBAction)addUser:(id)sender;

@end
