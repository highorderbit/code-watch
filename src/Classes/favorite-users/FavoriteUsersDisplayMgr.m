//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteUsersDisplayMgr.h"

@implementation FavoriteUsersDisplayMgr

- (void)dealloc
{
    [viewController release];
    [networkAwareViewController release];
    [userDisplayMgr release];
    [logInState release];
    [gitHubService release];
    [super dealloc];
}

- (id)initWithViewController:
    (FavoriteUsersViewController *)aViewController
    networkAwareViewController:
    (NetworkAwareViewController *)aNetworkAwareViewController
    userDisplayMgr:
    (NSObject<UserDisplayMgr> *)aUserDisplayMgr
    logInState:
    (NSObject<LogInStateReader> *)aLogInState
    gitHubService:
    (GitHubService *)aGitHubService
{
    if (self = [super init]) {
        viewController = [aViewController retain];
        networkAwareViewController = [aNetworkAwareViewController retain];
        userDisplayMgr = [aUserDisplayMgr retain];
        logInState = [aLogInState retain];
        gitHubService = [aGitHubService retain];
        
        UIBarButtonItem * refreshButton =
            [[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
            target:self
            action:@selector(viewWillAppear)] autorelease];

        [networkAwareViewController.navigationItem
            setRightBarButtonItem:refreshButton animated:NO];
    }

    return self;
}

#pragma mark FavoriteUsersViewControllerDelegate implementation

- (void)selectedUsername:(NSString *)username
{    
    [userDisplayMgr displayUserInfoForUsername:username];
}

#pragma mark NetworkAwareViewControllerDelegate implementation

- (void)viewWillAppear
{
    gitHubFailure = NO;
    
    if (logInState && logInState.login) {
        [networkAwareViewController
            setNoConnectionText:
            NSLocalizedString(@"nodata.noconnection.text", @"")];
        
        [gitHubService fetchFollowersForUsername:logInState.login];
        
        NSArray * followedUsers = nil;
        // followedUsers = networkCache ...

        // viewController.following = ...

        [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
        [networkAwareViewController setCachedDataAvailable:!!followedUsers];
    } else {
        // This is a bit of a hack, but a relatively simple solution:
        // Configure the network-aware controller to 'disconnected' and set the
        // disconnected text accordingly
        [networkAwareViewController
            setNoConnectionText:
            NSLocalizedString(@"favoriteuserdisplaymgr.login.text", @"")];
        [networkAwareViewController setUpdatingState:kDisconnected];
        [networkAwareViewController setCachedDataAvailable:NO];
    }
}

#pragma mark GitHubServiceDelegate implementation

- (void)followers:(NSArray *)followers fetchedForUsername:(NSString *)username
{
    [viewController setUsernames:followers];
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToFetchFollowersForUsername:(NSString *)username
    error:(NSError *)error
{
    if (!gitHubFailure) {
        gitHubFailure = YES;
        NSLog(@"Failed to retrieve following list for user: '%@' error: '%@'.",
            username, error);

        NSString * title =
            NSLocalizedString(@"github.followingupdate.failed.alert.title",
            @"");
        NSString * cancelTitle =
            NSLocalizedString(@"github.followingupdate.failed.alert.ok", @"");
        NSString * message = error.localizedDescription;

        UIAlertView * alertView =
            [[[UIAlertView alloc]
            initWithTitle:title message:message delegate:self
            cancelButtonTitle:cancelTitle otherButtonTitles:nil]
            autorelease];

        [alertView show];

        [networkAwareViewController setUpdatingState:kDisconnected];
    }
}

@end
