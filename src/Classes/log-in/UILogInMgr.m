//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UILogInMgr.h"
#import "LogInViewController.h"
#import "GitHubService.h"
#import "UserInfo.h"

@interface UILogInMgr (Private)

- (void)setButtonText;

@end

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
    
    [homeBarButtonItem release];
    [userBarButtonItem release];
    
    [gitHub release];
    [logInStateSetter release];
    [logInStateReader release];
    [userCacheSetter release];
    
    [super dealloc];
}

- (id)init
{
    [super init];
    
    [self setButtonText];
    
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

#pragma mark Helper methods

- (void)setButtonText
{
    if (logInStateReader.login) {
        homeBarButtonItem.title = @"Log Out";
        userBarButtonItem.title = @"Log Out";
    } else {
        homeBarButtonItem.title = @"Log In";
        userBarButtonItem.title = @"Log In";
    }
}

@end
