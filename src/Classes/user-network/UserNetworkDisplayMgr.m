//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UserNetworkDisplayMgr.h"
#import "FavoriteUsersViewController.h"
#import "NetworkAwareViewController.h"
#import "UserDisplayMgr.h"

@implementation UserNetworkDisplayMgr

@synthesize delegate;

- (void)dealloc
{
    [viewController release];
    [networkAwareViewController release];
    [userDisplayMgr release];
    [delegate release];
    [super dealloc];
}

- (id)initWithUserDisplayMgr:(NSObject<UserDisplayMgr> *)aUserDisplayMgr
{
    if (self = [super init]) {
        viewController = [[FavoriteUsersViewController alloc]
            initWithNibName:@"FavoriteUsersView" bundle:nil];
        viewController.delegate = self;

        networkAwareViewController =
            [[NetworkAwareViewController alloc]
            initWithTargetViewController:viewController];
        networkAwareViewController.delegate = self;

        userDisplayMgr = [aUserDisplayMgr retain];
    }

    return self;
}

- (void)setNetwork:(NSArray *)network forUsername:(NSString *)username
{
    [viewController setUsernames:network];
    [networkAwareViewController setCachedDataAvailable:!!network];
}

- (void)setUpdatingState:(UpdatingState)updatingState
{
    [networkAwareViewController setUpdatingState:updatingState];
}

- (void)pushDisplay:(UINavigationController *)navigationController
{
    NSString * title = [delegate titleForNavigationItem];
    networkAwareViewController.navigationItem.title = title;

    UIBarButtonItem * item = [delegate rightBarButtonItem];
    networkAwareViewController.navigationItem.rightBarButtonItem = item;

    [navigationController
        pushViewController:networkAwareViewController animated:YES];
}

#pragma mark NetworkViewControllerDelegate implementation

- (void)viewWillAppear
{
}

#pragma mark FavoriteUsersViewControllerDelegate implementation

- (void)selectedUsername:(NSString *)username
{
    [userDisplayMgr displayUserInfoForUsername:username];
}

@end
