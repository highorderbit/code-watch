//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UILogInMgr.h"
#import "LogInViewController.h"
#import "LogInHelpViewController.h"
#import "UIApplication+NetworkActivityIndicatorAdditions.h"
#import "GitHubService.h"
#import "UserInfo.h"

@interface UILogInMgr (Private)

- (void)setButtonText;

@end

@implementation UILogInMgr

@synthesize navigationController;
@synthesize logInViewController;
@synthesize logInHelpViewController;

- (void)dealloc
{
    [rootViewController release];

    [navigationController release];
    [logInViewController release];
    [logInHelpViewController release];

    [homeBarButtonItem release];
    [userBarButtonItem release];
    [userTabBarItem release];
    
    [logInStateSetter release];
    [logInStateReader release];
    [userCacheSetter release];

    [gitHub release];
    
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        [self setButtonText];
        connecting = NO;
    }

    return self;
}

- (IBAction)collectCredentials:(id)sender
{
    if (logInStateReader.login) { // if logged in, log out
        BOOL prompt = logInStateReader.prompt;
        [logInStateSetter setLogin:nil token:nil prompt:prompt];
        [userCacheSetter setPrimaryUser:nil];
    }

    [rootViewController
        presentModalViewController:self.navigationController
        animated:YES];

    [self setButtonText];
}

#pragma mark LogInViewControllerDelegate implementation

- (void)userProvidedUsername:(NSString *)username token:(NSString *)token
{
    NSLog(@"Attempting login with username: '%@', token: '%@'.", username,
        token);

    connecting = YES;

    if (token)
        [gitHub logIn:username token:token];
    else
        [gitHub logIn:username];
}

- (void)userDidCancel
{
    [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void)provideHelp
{
    if (!connecting)
        [self.navigationController
            pushViewController:self.logInHelpViewController animated:YES];
}

#pragma mark GitHubDelegate implementation

- (void)logInSucceeded:(NSString *)username
{
    [rootViewController dismissModalViewControllerAnimated:YES];
    
    connecting = NO;
    [self setButtonText];
}

- (void)logInFailed:(NSString *)username error:(NSError *)error
{
    NSString * title =
        NSLocalizedString(@"github.login.failed.alert.title", @"");
    NSString * cancelTitle =
        NSLocalizedString(@"github.login.failed.alert.ok", @"");
    NSString * message = error.localizedDescription;

    UIAlertView * alertView =
        [[[UIAlertView alloc]
          initWithTitle:title
                message:message
               delegate:self
      cancelButtonTitle:cancelTitle
      otherButtonTitles:nil]
         autorelease];

    [alertView show];
 
    connecting = NO;
    [self.logInViewController viewWillAppear:NO];
}

#pragma mark Accessors

- (LogInViewController *)logInViewController
{
    if (!logInViewController) {
        logInViewController =
            [[LogInViewController alloc]
             initWithNibName:@"LogInView" bundle:nil];
        logInViewController.delegate = self;
    }

    return logInViewController;
}

- (LogInHelpViewController *)logInHelpViewController
{
    if (!logInHelpViewController)
        logInHelpViewController =
            [[LogInHelpViewController alloc]
             initWithNibName:@"LogInHelpView" bundle:nil];

    return logInHelpViewController;
}

- (UINavigationController *)navigationController
{
    if (!navigationController)
        navigationController = [[UINavigationController alloc]
            initWithRootViewController:self.logInViewController];

    return navigationController;
}

#pragma mark Helper methods

- (void)setButtonText
{
    if (logInStateReader.login) {
        homeBarButtonItem.title =
            NSLocalizedString(@"loginmgr.logout.text", @"");
        userBarButtonItem.title =
            NSLocalizedString(@"loginmgr.logout.text", @"");
        userTabBarItem.title = logInStateReader.login;
    } else {
        homeBarButtonItem.title =
            NSLocalizedString(@"loginmgr.login.text", @"");
        userBarButtonItem.title =
            NSLocalizedString(@"loginmgr.login.text", @"");
        userTabBarItem.title =
            NSLocalizedString(@"loginmgr.user.text", @"");
    }
}

@end