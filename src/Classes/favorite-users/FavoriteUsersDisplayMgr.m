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

- (id)initWithViewController:(FavoriteUsersViewController *)aViewController
    stateReader:(NSObject<FavoriteUsersStateReader> *)stateReader
    stateSetter:(NSObject<FavoriteUsersStateSetter> *)stateSetter
    userDisplayMgr:(NSObject<UserDisplayMgr> *)aUserDisplayMgr
{
    if (self = [super init]) {
        viewController = [aViewController retain];
        favoriteUsersStateReader = [stateReader retain];
        favoriteUsersStateSetter = [stateSetter retain];
        userDisplayMgr = [aUserDisplayMgr retain];
    }
    
    return self;
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
    [userDisplayMgr displayUserInfoForUsername:username];
}

@end
