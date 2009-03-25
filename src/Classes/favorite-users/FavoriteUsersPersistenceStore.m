//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteUsersPersistenceStore.h"
#import "PListUtils.h"

@interface FavoriteUsersPersistenceStore (Private)

+ (NSString *)plistName;

@end

@implementation FavoriteUsersPersistenceStore

- (void)dealloc
{
    [stateReader release];
    [stateSetter release];
    [super dealloc];
}

#pragma mark PersistenceStore implementation

- (void)load
{
    NSArray * favoriteUsers =
        [PlistUtils getArrayFromPlist:[[self class] plistName]];
    
    for (NSString * username in favoriteUsers)
        [stateSetter addFavoriteUser:username];
}

- (void)save
{
    [PlistUtils saveArray:stateReader.favoriteUsers
        toPlist:[[self class] plistName]];
}

#pragma mark Static helper methods

+ (NSString *)plistName
{
    return @"FavoriteUsersState";
}

@end
