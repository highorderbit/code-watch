//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UIAddUserMgr.h"

@interface UIAddUserMgr (Private)

@property (readonly) AddUserViewController * addUserViewController;
@property (readonly) LogInHelpViewController * logInHelpViewController;
@property (readonly) UINavigationController * navigationController;

@end

@implementation UIAddUserMgr

- (void)dealloc
{
    [rootViewController release];
    [navigationController release];
    [addUserViewController release];
    [super dealloc];
}

#pragma mark AddUserMgr implementation

- (IBAction)addUser:(id)sender
{
    [rootViewController presentModalViewController:self.navigationController
        animated:YES];
}

#pragma mark AddUserControllerDelegate implementation

- (void)userProvidedUsername:(NSString *)username
{}

- (void)userDidCancel
{}

- (void)provideHelp
{}

#pragma mark Accessors

- (AddUserViewController *)addUserViewController
{
    if (!addUserViewController) {
        addUserViewController =
            [[AddUserViewController alloc]
            initWithNibName:@"AddUserView" bundle:nil];
        addUserViewController.delegate = self;
    }

    return addUserViewController;
}

- (UINavigationController *)navigationController
{
    if (!navigationController)
        navigationController = [[UINavigationController alloc]
            initWithRootViewController:self.addUserViewController];

    return navigationController;
}

@end
