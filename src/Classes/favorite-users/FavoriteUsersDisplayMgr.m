//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteUsersDisplayMgr.h"

@interface FavoriteUsersDisplayMgr (Private)

@property (readonly) NetworkAwareViewController * networkAwareViewController;
@property (readonly) UserDisplayMgr * userDisplayMgr;

@end

@implementation FavoriteUsersDisplayMgr

- (void)dealloc
{
    [viewController release];
    [navigationController release];
    [networkAwareViewController release];
    
    [favoriteUsersStateReader release];
    [favoriteUsersStateSetter release];
    
    [userCacheReader release];
    
    [super dealloc];
}

#pragma mark FavoriteUsersViewControllerDelegate implementation

- (void)viewWillAppear
{
    [viewController setUsernames:favoriteUsersStateReader.favoriteUsers];
}

- (void)removedUsername:(NSString *)username;
{
    [favoriteUsersStateSetter removeFavoriteUser:username];
    [viewController setUsernames:favoriteUsersStateReader.favoriteUsers];
}

- (void)setUsernameSortOrder:(NSArray *)sortedUsernames
{
    for (NSString * username in sortedUsernames) {
        [favoriteUsersStateSetter removeFavoriteUser:username];
        [favoriteUsersStateSetter addFavoriteUser:username];
    }
}

- (void)selectedUsername:(NSString *)username
{
    self.userDisplayMgr.username = username;
    [navigationController pushViewController:self.networkAwareViewController
        animated:YES];
    // delegate to some user display manager
    // [userDisplayMgr displayUserInfoForUser:username];
    // concrete type is UIUserDisplayMgr
    // This class shouldn't have to create the display manager
    // Does this type have to be instantiated in the MainWindow.xib?
    //   NO - Only some view controllers must be instantiated in the nib
    // Instantiate this in the app controller with cache, viewController, etc.
    //   arguments in the initializer
}

#pragma mark Accessor methods

- (NetworkAwareViewController *)networkAwareViewController
{
    if (!networkAwareViewController) {
        networkAwareViewController =
            [[NetworkAwareViewController alloc]
            initWithTargetViewController:nil];
    }
    
    return networkAwareViewController;
}

- (UserDisplayMgr *)userDisplayMgr
{
    if (!userDisplayMgr) {
        UserViewController * userViewController =
           [[UserViewController alloc] initWithNibName:@"UserView" bundle:nil];

        userDisplayMgr =
            [[UserDisplayMgr alloc]
            initWithNetworkAwareViewController:self.networkAwareViewController
            userViewController:userViewController
            userCacheReader:userCacheReader repoSelector:nil gitHubService:nil];
        // UserDisplayMgrFactory createDisplayMgr
            
        userViewController.delegate = userDisplayMgr;
        networkAwareViewController.delegate = userDisplayMgr;
    }
    
    return userDisplayMgr;
}

@end
