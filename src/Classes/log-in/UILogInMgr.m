//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "UILogInMgr.h"
#import "LogInViewController.h"
#import "GitHub.h"

// TODO: Remove once merged with user info
@class UserInfo;

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

    NSURL * url = [NSURL URLWithString:@"http://github.com/api/"];
    GitHub * gitHub = [[GitHub alloc] initWithBaseUrl:url
                                               format:JsonApiFormat
                                             delegate:self];

    [gitHub fetchInfoForUsername:username];

    [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void)userDidCancel
{
    [rootViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark GitHubDelegate implementation

- (void)username:(NSString *)username hasInfo:(UserInfo *)info;
{
    NSLog(@"Received response for username: '%@'.", username);
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
