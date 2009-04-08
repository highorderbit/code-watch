//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UILogInMgr.h"
#import "LogInViewController.h"
#import "WebViewController.h"
#import "UIApplication+NetworkActivityIndicatorAdditions.h"
#import "GitHubService.h"
#import "UserInfo.h"

@interface UILogInMgr (Private)

- (void)presentView;
- (void)updateUI;

@end

@implementation UILogInMgr

@synthesize navigationController;
@synthesize logInViewController;
@synthesize helpViewController;
@synthesize expectedUsername;
@synthesize homeRefreshButton;
@synthesize userRefreshButton;

- (void)dealloc
{
    [rootViewController release];

    [navigationController release];
    [logInViewController release];
    [helpViewController release];

    [homeBarButtonItem release];
    [userBarButtonItem release];
    [userTabBarItem release];
    [homeNavigationItem release];
    [userNavigationItem release];
    [homeRefreshButton release];
    [userRefreshButton release];
    
    [logInStateSetter release];
    [logInStateReader release];
    [userCacheSetter release];

    [gitHub release];
    
    [expectedUsername release];
    
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        self.homeRefreshButton = homeNavigationItem.rightBarButtonItem;
        self.userRefreshButton = userNavigationItem.rightBarButtonItem;
        [self updateUI];
    }

    return self;
}

- (IBAction)collectCredentials:(id)sender
{
    if (logInStateReader.login) { // if logged in, log out
        UIActionSheet * actionSheet =
            [[[UIActionSheet alloc]
            initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
            destructiveButtonTitle:@"Log Out" otherButtonTitles:nil]
            autorelease];

        [actionSheet showInView:rootViewController.view];
    } else
        [self presentView];
}

#pragma mark LogInViewControllerDelegate implementation

- (void)userProvidedUsername:(NSString *)username token:(NSString *)token
{
    NSLog(@"Attempting login with username: '%@', token: '%@'.", username,
        token);

    self.expectedUsername = username;

    if (token)
        [gitHub logIn:username token:token];
    else
        [gitHub logIn:username];
}

- (void)userDidCancel
{
    self.expectedUsername = nil;
    [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void)provideHelp
{
    if (!expectedUsername)
        [self.navigationController
            pushViewController:self.helpViewController animated:YES];
}

#pragma mark GitHubDelegate implementation

- (void)logInSucceeded:(NSString *)username
{
    if ([self.expectedUsername isEqual:username]) {
        [rootViewController dismissModalViewControllerAnimated:YES];
    
        self.expectedUsername = nil;
        [self updateUI];
        [logInViewController logInAccepted];
    }
}

- (void)logInFailed:(NSString *)username error:(NSError *)error
{
    if ([self.expectedUsername isEqual:username]) {
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
 
        self.expectedUsername = nil;
        [logInViewController promptForLogIn];
    }
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

- (WebViewController *)helpViewController
{
    if (!helpViewController) {
        helpViewController =
            [[WebViewController alloc] initWithHtmlFilename:@"log-in-help"];
        helpViewController.title =
            NSLocalizedString(@"loginhelp.view.title", @"");
    }

    return helpViewController;
}

- (UINavigationController *)navigationController
{
    if (!navigationController)
        navigationController = [[UINavigationController alloc]
            initWithRootViewController:self.logInViewController];

    return navigationController;
}

#pragma mark Helper methods

- (void)updateUI
{
    if (logInStateReader.login) {
        homeBarButtonItem.title =
            NSLocalizedString(@"loginmgr.logout.text", @"");
        userBarButtonItem.title =
            NSLocalizedString(@"loginmgr.logout.text", @"");
        static const NSInteger MAX_USER_TAB_NAME_LENGTH = 12;
        userTabBarItem.title =
            [logInStateReader.login length] > MAX_USER_TAB_NAME_LENGTH ?
            [NSString stringWithFormat:@"%@...",
            [logInStateReader.login
            substringToIndex:MAX_USER_TAB_NAME_LENGTH - 3]] :
            logInStateReader.login;
        [homeNavigationItem setRightBarButtonItem:self.homeRefreshButton
            animated:NO];
        [userNavigationItem setRightBarButtonItem:self.userRefreshButton
            animated:NO];
    } else {
        homeBarButtonItem.title =
            NSLocalizedString(@"loginmgr.login.text", @"");
        userBarButtonItem.title =
            NSLocalizedString(@"loginmgr.login.text", @"");
        userTabBarItem.title =
            NSLocalizedString(@"loginmgr.user.text", @"");
            
        [homeNavigationItem setRightBarButtonItem:nil animated:NO];
        [userNavigationItem setRightBarButtonItem:nil animated:NO];
    }
}

- (void)presentView
{
    [rootViewController presentModalViewController:self.navigationController
        animated:YES];

    [self updateUI];
}

#pragma mark UIActionSheetDelegate implementation

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        BOOL prompt = logInStateReader.prompt;
        [logInStateSetter setLogin:nil token:nil prompt:prompt];
        [userCacheSetter setPrimaryUser:nil];
        
        [self presentView];
    }
}

@end