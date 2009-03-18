//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UILogInMgr.h"
#import "LogInViewController.h"
#import "LogInHelpViewController.h"
#import "GitHubService.h"
#import "UserInfo.h"

@interface UILogInMgr (Private)

- (void)setButtonText;

@end

@implementation UILogInMgr

@synthesize navigationController;
@synthesize logInViewController;
@synthesize logInHelpViewController;
@synthesize gitHub;
@synthesize logInStateSetter;

- (void)dealloc
{
    [rootViewController release];

    [navigationController release];
    [logInViewController release];
    [logInHelpViewController release];

    [homeBarButtonItem release];
    [userBarButtonItem release];
    [userTabBarItem release];
    
    [gitHub release];
    [logInStateSetter release];
    [logInStateReader release];
    [userCacheSetter release];
    
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
        [gitHub fetchInfoForUsername:username token:token];
    else
        [gitHub fetchInfoForUsername:username];
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

#pragma mark GitHubServiceDelegate implementation

- (void)info:(UserInfo *)info fetchedForUsername:(NSString *)username
{
    NSLog(@"Username: '%@' has info: '%@'.", username, info);

    [logInStateSetter setLogin:username token:nil prompt:NO];

    [rootViewController dismissModalViewControllerAnimated:YES];
    
    connecting = NO;
    [self setButtonText];
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
