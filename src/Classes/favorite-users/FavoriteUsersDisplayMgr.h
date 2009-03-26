//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteUsersViewControllerDelegate.h"
#import "FavoriteUsersViewController.h"
#import "FavoriteUsersStateReader.h"
#import "FavoriteUsersStateSetter.h"
#import "UserViewController.h"
#import "NetworkAwareViewController.h"
#import "UserDisplayMgr.h"

@interface FavoriteUsersDisplayMgr :
    NSObject <FavoriteUsersViewControllerDelegate>
{
    IBOutlet FavoriteUsersViewController * viewController;
    IBOutlet UINavigationController * navigationController;
    NetworkAwareViewController * networkAwareViewController;
    
    IBOutlet NSObject<FavoriteUsersStateReader> * favoriteUsersStateReader;
    IBOutlet NSObject<FavoriteUsersStateSetter> * favoriteUsersStateSetter;
    
    // TODO: remove this in favor of a factory that creates the
    // networkAwareViewController, which will also allow the removal of the
    // navigationController field
    IBOutlet NSObject<UserCacheReader> * userCacheReader;
    
    UserDisplayMgr * userDisplayMgr;
}

@end
