//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteUsersViewControllerDelegate.h"
#import "FavoriteUsersViewController.h"
#import "FavoriteUsersStateReader.h"

@interface FavoriteUsersDisplayMgr :
    NSObject <FavoriteUsersViewControllerDelegate>
{
    IBOutlet FavoriteUsersViewController * viewController;
    IBOutlet NSObject<FavoriteUsersStateReader> * favoriteUsersStateReader;
}

@end
