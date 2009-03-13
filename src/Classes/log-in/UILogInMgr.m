//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UILogInMgr.h"
#import "LogInViewController.h"

@implementation UILogInMgr

@synthesize logInViewController;
@synthesize navigationController;

- (void) dealloc
{
    [rootViewController release];
    [logInViewController release];
    [navigationController release];
    [super dealloc];
}

- (void) collectCredentials
{
    [rootViewController
        presentModalViewController:self.navigationController
        animated:YES];
}

#pragma mark LogInViewControllerDelegate implementation

- (void)userProvidedUsername:(NSString *)username token:(NSString *)token
{
    NSLog(@"Attempting login with username: '%@', token: '%@'.", username,
        token);

    [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void)userDidCancel
{
    [rootViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark Accessors

- (LogInViewController *) logInViewController
{
    if (!logInViewController) {
        logInViewController =
            [[[LogInViewController alloc]
              initWithNibName:@"LogInView"
                       bundle:nil]
             autorelease];
        logInViewController.delegate = self;
    }

    return logInViewController;
}

- (UINavigationController *) navigationController
{
    if (!navigationController)
        navigationController = [[UINavigationController alloc]
            initWithRootViewController:self.logInViewController];

    return navigationController;
}

@end
