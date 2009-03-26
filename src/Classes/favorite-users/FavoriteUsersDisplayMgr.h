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
#import "UIUserDisplayMgr.h"

@interface FavoriteUsersDisplayMgr :
    NSObject <FavoriteUsersViewControllerDelegate>
{
    FavoriteUsersViewController * viewController;
    
    NSObject<FavoriteUsersStateReader> * favoriteUsersStateReader;
    NSObject<FavoriteUsersStateSetter> * favoriteUsersStateSetter;
    
    NSObject<UserDisplayMgr> * userDisplayMgr;
}

- (id)initWithViewController:(FavoriteUsersViewController *)viewController
    stateReader:(NSObject<FavoriteUsersStateReader> *)stateReader
    stateSetter:(NSObject<FavoriteUsersStateSetter> *)stateSetter
    userDisplayMgr:(NSObject<UserDisplayMgr> *)userDisplayMgr;

@end
