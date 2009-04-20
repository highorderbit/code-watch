//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteUsersViewControllerDelegate.h"
#import "FavoriteUsersViewController.h"
#import "UserViewController.h"
#import "NetworkAwareViewController.h"
#import "UIUserDisplayMgr.h"

@interface FavoriteUsersDisplayMgr :
    NSObject <FavoriteUsersViewControllerDelegate>
{
    FavoriteUsersViewController * viewController;
    
    NSObject<UserDisplayMgr> * userDisplayMgr;
}

- (id)initWithViewController:(FavoriteUsersViewController *)viewController
    userDisplayMgr:(NSObject<UserDisplayMgr> *)userDisplayMgr;

@end
