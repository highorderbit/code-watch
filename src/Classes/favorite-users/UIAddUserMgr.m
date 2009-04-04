//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UIAddUserMgr.h"
#import "WebViewController.h"

@interface UIAddUserMgr (Private)

@property (readonly) AddUserViewController * addUserViewController;
@property (readonly) WebViewController * helpViewController;
@property (readonly) UINavigationController * navigationController;

@end

@implementation UIAddUserMgr

- (void)dealloc
{
    [rootViewController release];
    
    [navigationController release];
    [addUserViewController release];
    [helpViewController release];
    
    [gitHub release];
    [favoriteUsersStateSetter release];
    [favoriteUsersStateReader release];
    
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
{
    NSLog(@"Attempting add user with username: '%@'.", username);
    connecting = YES;
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
            pushViewController:self.helpViewController animated:YES];
}

#pragma mark GitHubServiceDelegate implementation

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username
{
    [favoriteUsersStateSetter addFavoriteUser:username];
    [rootViewController dismissModalViewControllerAnimated:YES];
    connecting = NO;
    [addUserViewController usernameAccepted];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    NSString * title =
        NSLocalizedString(@"github.adduser.failed.alert.title", @"");
    NSString * cancelTitle =
        NSLocalizedString(@"github.adduser.failed.alert.ok", @"");
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
    [addUserViewController promptForUsername];
}

#pragma mark Accessors

- (AddUserViewController *)addUserViewController
{
    if (!addUserViewController) {
        addUserViewController =
            [[AddUserViewController alloc]
            initWithNibName:@"AddUserView" bundle:nil];
        addUserViewController.delegate = self;
        addUserViewController.favoriteUsersStateReader =
            favoriteUsersStateReader;
    }

    return addUserViewController;
}

- (WebViewController *)helpViewController
{
    if (!helpViewController) {
        helpViewController =
            [[WebViewController alloc] initWithHtmlFilename:@"new-user-help"];
        helpViewController.title =
            NSLocalizedString(@"adduser.help.view.title", @"");
    }

    return helpViewController;
}

- (UINavigationController *)navigationController
{
    if (!navigationController)
        navigationController = [[UINavigationController alloc]
            initWithRootViewController:self.addUserViewController];

    return navigationController;
}

@end
