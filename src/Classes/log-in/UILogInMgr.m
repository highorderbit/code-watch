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
@synthesize upgradeViewController;
@synthesize expectedUsername;
@synthesize homeRefreshButton;
@synthesize userRefreshButton;
@synthesize followedUsersRefreshButton;

- (void)dealloc
{
    [rootViewController release];

    [navigationController release];
    [logInViewController release];
    [helpViewController release];
    [upgradeViewController release];

    [homeBarButtonItem release];
    [userBarButtonItem release];
    [followedUsersBarButtonItem release];
    [userTabBarItem release];
    [homeNavigationItem release];
    [userNavigationItem release];
    [followedUsersNavigationItem release];
    [homeRefreshButton release];
    [userRefreshButton release];
    [followedUsersRefreshButton release];
    
    [homeNavigationController release];
    [userNavigationController release];
    [favoriteUsersNavigationController release];
    [favoriteReposNavigationController release];
    [searchNavigationController release];
    
    [logInStateSetter release];
    [logInStateReader release];
    [userCacheSetter release];
    [repoCacheSetter release];
    [commitCacheSetter release];
    [newsFeedCacheSetter release];
    [userNetworkCacheSetter release];

    [gitHub release];
    
    [expectedUsername release];
    
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        self.homeRefreshButton = homeNavigationItem.rightBarButtonItem;
        self.userRefreshButton = userNavigationItem.rightBarButtonItem;
        self.followedUsersRefreshButton =
            followedUsersNavigationItem.rightBarButtonItem;
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

- (void)provideUpgradeHelp
{
    if (!expectedUsername)
        [self.navigationController
            pushViewController:self.upgradeViewController animated:YES];
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
    NSLog(@"Log in failed: username: '%@', error: '%@'.", username, error);
    if ([self.expectedUsername isEqual:username]) {
        NSString * title =
            NSLocalizedString(@"github.login.failed.alert.title", @"");
        NSString * cancelTitle =
            NSLocalizedString(@"github.login.failed.alert.ok", @"");
        NSString * message =
            NSLocalizedString(@"github.login.failed.alert.message", @"");

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

- (WebViewController *)upgradeViewController
{
    if (!upgradeViewController) {
        upgradeViewController =
            [[WebViewController alloc] initWithHtmlFilename:@"upgrade-help"];
        upgradeViewController.title =
            NSLocalizedString(@"upgradehelp.view.title", @"");
    }

    return upgradeViewController;
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
        followedUsersBarButtonItem.title =
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
        [followedUsersNavigationItem
            setRightBarButtonItem:self.followedUsersRefreshButton animated:NO];
    } else {
        homeBarButtonItem.title =
            NSLocalizedString(@"loginmgr.login.text", @"");
        userBarButtonItem.title =
            NSLocalizedString(@"loginmgr.login.text", @"");
        followedUsersBarButtonItem.title =
            NSLocalizedString(@"loginmgr.login.text", @"");
        userTabBarItem.title =
            NSLocalizedString(@"loginmgr.user.text", @"");
            
        [homeNavigationItem setRightBarButtonItem:nil animated:NO];
        [userNavigationItem setRightBarButtonItem:nil animated:NO];
        [followedUsersNavigationItem setRightBarButtonItem:nil animated:NO];
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
    if (buttonIndex == 0) { // Log out
        BOOL prompt = logInStateReader.prompt;
        [logInStateSetter setLogin:nil token:nil prompt:prompt];
        [userCacheSetter setPrimaryUser:nil];
        [userCacheSetter clear];
        [repoCacheSetter clear];
        [commitCacheSetter clear];
        [newsFeedCacheSetter clear];
        [userNetworkCacheSetter setFollowingForPrimaryUser:nil];

        // pop all nav controllers' stacks to top
        [homeNavigationController popToRootViewControllerAnimated:NO];
        [userNavigationController popToRootViewControllerAnimated:NO];
        [favoriteUsersNavigationController popToRootViewControllerAnimated:NO];
        [favoriteReposNavigationController popToRootViewControllerAnimated:NO];
        [searchNavigationController popToRootViewControllerAnimated:NO];

        [self presentView];
    }
}

@end
