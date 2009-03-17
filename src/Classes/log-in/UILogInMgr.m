//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UILogInMgr.h"
#import "LogInViewController.h"
#import "GitHubService.h"
#import "UserInfo.h"

@implementation UILogInMgr

@synthesize logInViewController;
@synthesize navigationController;
@synthesize gitHub;
@synthesize logInStateSetter;

- (void)dealloc
{
    [rootViewController release];
    [logInViewController release];
    [navigationController release];
    [gitHub release];
    [logInStateSetter release];
    [super dealloc];
}

- (IBAction)collectCredentials:(id)sender
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

    if (token)
        [gitHub fetchInfoForUsername:username token:token];
    else
        [gitHub fetchInfoForUsername:username];
}

- (void)userDidCancel
{
    [rootViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark GitHubServiceDelegate implementation

- (void)info:(UserInfo *)info fetchedForUsername:(NSString *)username
{
    NSLog(@"Username: '%@' has info: '%@'.", username, info);

    [logInStateSetter setLogin:username token:nil prompt:NO];

    [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    NSString * title =
        NSLocalizedString(@"github.login.failed.alert.title", @"");
    NSString * cancelTitle =
        NSLocalizedString(@"github.login.failed.alert.ok", @"");

    UIAlertView * alertView =
        [[[UIAlertView alloc]
          initWithTitle:title
                message:error.localizedDescription
               delegate:self
      cancelButtonTitle:cancelTitle
      otherButtonTitles:nil]
         autorelease];

    [alertView show];

    [self.logInViewController viewWillAppear:NO];
    
}

#pragma mark Accessors

- (LogInViewController *)logInViewController
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

- (UINavigationController *)navigationController
{
    if (!navigationController)
        navigationController = [[UINavigationController alloc]
            initWithRootViewController:self.logInViewController];

    return navigationController;
}

@end
