//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteUsersState.h"

@implementation FavoriteUsersState

- (void)dealloc
{
    [favoriteUsers release];
    [super dealloc];
}

- (void)awakeFromNib
{
    favoriteUsers = [[NSMutableArray array] retain];
}

#pragma mark FavoriteUsersStateReader implementation

- (NSArray *)favoriteUsers
{
    return [favoriteUsers copy];
}

#pragma mark FavoriteUsersStateSetter implementation

- (void)addFavoriteUser:(NSString *)username
{
    if (![favoriteUsers containsObject:username])
        [favoriteUsers addObject:username];
}

- (void)removeFavoriteUser:(NSString *)username
{
    [favoriteUsers removeObject:username];
}

@end
