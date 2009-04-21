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
        
        // gitHubService fetchFollowingForUsername
        
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

// fetched following list

// failed to fetch following list

@end
