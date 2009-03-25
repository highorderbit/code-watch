//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteUsersDisplayMgr.h"

@implementation FavoriteUsersDisplayMgr

- (void)dealloc
{
    [viewController release];
    [favoriteUsersStateReader release];
    [super dealloc];
}

#pragma mark FavoriteUsersViewControllerDelegate implementation

- (void)viewWillAppear
{
    [viewController setUsernames:favoriteUsersStateReader.favoriteUsers];
}

@end
