//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserNetworkDisplayMgrDelegate.h"
#import "NetworkAwareViewController.h"  // for UpdatingState
#import "NetworkAwareViewControllerDelegate.h"
#import "FavoriteUsersViewController.h"
#import "UserDisplayMgr.h"

@class FavoriteUsersViewController;

@interface UserNetworkDisplayMgr :
    NSObject
    <NetworkAwareViewControllerDelegate, FavoriteUsersViewControllerDelegate>
{
    id<UserNetworkDisplayMgrDelegate> delegate;

    NetworkAwareViewController * networkAwareViewController;
    FavoriteUsersViewController * viewController;

    NSObject<UserDisplayMgr> * userDisplayMgr;
}

@property (nonatomic, retain) id<UserNetworkDisplayMgrDelegate> delegate;

#pragma mark Initialization

- (id)initWithUserDisplayMgr:(NSObject<UserDisplayMgr> *)aUserDisplayMgr;

#pragma mark Updating the display

- (void)setNetwork:(NSArray *)network forUsername:(NSString *)username;
- (void)setUpdatingState:(UpdatingState)updatingState;

- (void)pushDisplay:(UINavigationController *)navigationController;

@end
