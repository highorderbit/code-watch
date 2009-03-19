//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UILogInMgr.h"
#import "LogInViewController.h"
#import "LogInHelpViewController.h"
#import "UIApplication+NetworkActivityIndicatorAdditions.h"
#import "GitHub.h"
#import "UserInfo.h"

@interface UILogInMgr (Private)

- (void)setButtonText;

@end

@implementation UILogInMgr

@synthesize navigationController;
@synthesize logInViewController;
@synthesize logInHelpViewController;
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
    
    [configReader release];
    [logInStateSetter release];
    [logInStateReader release];
    [userCacheSetter release];
    [repoCacheSetter release];

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

- (void)awakeFromNib
{
    NSString * url = [configReader valueForKey:@"GitHubApiBaseUrl"];
    NSURL * gitHubApiBaseUrl = [NSURL URLWithString:url];

    GitHubApiFormat apiFormat =
        [[configReader valueForKey:@"GitHubApiFormat"] intValue];

    GitHubApiVersion apiVersion =
        [[configReader valueForKey:@"GitHubApiVersion"] intValue];

    gitHub = [[GitHub alloc] initWithBaseUrl:gitHubApiBaseUrl
                                      format:apiFormat
                                     version:apiVersion
                                    delegate:self];
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

    [[UIApplication sharedApplication] networkActivityIsStarting];
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

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username token:(NSString *)token
{
    NSLog(@"Username: '%@' has info: '%@'.", username, info);

    [logInStateSetter setLogin:username token:token prompt:NO];
    [userCacheSetter setPrimaryUser:info];
    for (NSString * repo in info.repoKeys)
        [repoCacheSetter setPrimaryUserRepo:[repos objectForKey:repo]
                                forRepoName:repo];

    [rootViewController dismissModalViewControllerAnimated:YES];
    
    connecting = NO;
    [self setButtonText];

    [[UIApplication sharedApplication] networkActivityDidFinish];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
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

    [[UIApplication sharedApplication] networkActivityDidFinish];
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
