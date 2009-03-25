//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteUsersDisplayMgr.h"

@implementation FavoriteUsersDisplayMgr

- (void)dealloc
{
    [viewController release];
    [favoriteUsersStateReader release];
    [favoriteUsersStateSetter release];
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

@end
