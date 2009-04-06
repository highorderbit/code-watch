//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UIAddRepoMgr.h"
#import "RepoKey.h"
#import "WebViewController.h"

@interface UIAddRepoMgr (Private)

@property (readonly) AddRepoViewController * addRepoViewController;
@property (readonly) WebViewController * helpViewController;
@property (readonly) UINavigationController * navigationController;

- (void)foundUsername:(NSString *)username repoName:(NSString *)repoName;
- (void)presentErrorAlert:(NSString *)message;

@end

@implementation UIAddRepoMgr

@synthesize repoName;
@synthesize expectedUsername;

- (void)dealloc
{
    [rootViewController release];
    
    [navigationController release];
    [addRepoViewController release];
    [helpViewController release];
    
    [gitHubService release];
    [favoriteReposStateSetter release];
    [favoriteReposStateReader release];
    
    [repoName release];
    [expectedUsername release];
    
    [super dealloc];
}

#pragma mark AddRepoMgr implementation

- (IBAction)addRepo:(id)sender
{
    [rootViewController presentModalViewController:self.navigationController
        animated:YES];
}

#pragma mark AddUserControllerDelegate implementation

- (void)userProvidedUsername:(NSString *)username repoName:(NSString *)aRepoName
{
    NSLog(@"Attempting add repo: %@ / %@.", username, aRepoName);
    self.repoName = aRepoName;
    self.expectedUsername = username;
    [gitHubService fetchInfoForUsername:username];
}

- (void)userDidCancel
{
    self.expectedUsername = nil;
    [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void)provideHelp
{
    if (!self.expectedUsername)
        [self.navigationController
            pushViewController:self.helpViewController animated:YES];
}

#pragma mark GitHubServiceDelegate implementation

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username
{
    if ([self.expectedUsername isEqual:username]) {
        if ([repos objectForKey:self.repoName]) {
            [self foundUsername:username repoName:self.repoName];
            [addRepoViewController repoAccepted];
        } else {
            NSString * formatString =
                NSLocalizedString(@"addrepo.reponotfound.format.string", @"");
            NSString * message =
                [NSString stringWithFormat:formatString, self.repoName, username];
            [self presentErrorAlert:message];
        }
    }
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    if ([self.expectedUsername isEqual:username])
        [self presentErrorAlert:error.localizedDescription];
}

#pragma mark Accessors

- (AddRepoViewController *)addRepoViewController
{
    if (!addRepoViewController) {
        addRepoViewController =
            [[AddRepoViewController alloc]
            initWithNibName:@"AddRepoView" bundle:nil];
        addRepoViewController.delegate = self;
        addRepoViewController.favoriteReposStateReader =
            favoriteReposStateReader;
    }

    return addRepoViewController;
}

- (WebViewController *)helpViewController
{
    if (!helpViewController) {
        helpViewController =
            [[WebViewController alloc] initWithHtmlFilename:@"new-repo-help"];
        helpViewController.title =
            NSLocalizedString(@"addrepo.help.view.title", @"");
    }

    return helpViewController;
}

- (UINavigationController *)navigationController
{
    if (!navigationController)
        navigationController = [[UINavigationController alloc]
            initWithRootViewController:self.addRepoViewController];

    return navigationController;
}

#pragma mark Helper methods

- (void)foundUsername:(NSString *)username repoName:(NSString *)aRepoName
{
    RepoKey * repoKey =
        [[RepoKey alloc] initWithUsername:username repoName:aRepoName];
    [favoriteReposStateSetter addFavoriteRepoKey:repoKey];
    [rootViewController dismissModalViewControllerAnimated:YES];
    self.expectedUsername = nil;
}

- (void)presentErrorAlert:(NSString *)message
{
    NSString * title =
        NSLocalizedString(@"github.addrepo.failed.alert.title", @"");
    NSString * cancelTitle =
        NSLocalizedString(@"github.addrepo.failed.alert.ok", @"");

    UIAlertView * alertView =
        [[[UIAlertView alloc]
        initWithTitle:title message:message delegate:self
        cancelButtonTitle:cancelTitle otherButtonTitles:nil]
        autorelease];

    [alertView show];
 
    self.expectedUsername = nil;
    [self.addRepoViewController promptForRepo];
}

@end
