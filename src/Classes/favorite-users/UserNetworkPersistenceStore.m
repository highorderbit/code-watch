//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserNetworkPersistenceStore.h"
#import "PListUtils.h"

@interface UserNetworkPersistenceStore (Private)

+ (NSString *)plistName;
+ (NSString *)primaryUserFollowingKey;
+ (NSString *)primaryUserFollowersKey;

@end

@implementation UserNetworkPersistenceStore

- (void)dealloc
{
    [userNetworkCacheReader release];
    [userNetworkCacheSetter release];
    [super dealloc];
}

- (void)load
{
    NSDictionary * dict =
        [PlistUtils getDictionaryFromPlist:[[self class] plistName]];

    NSArray * primaryUserFollowing =
        [dict objectForKey:[[self class] primaryUserFollowingKey]];
    [userNetworkCacheSetter setFollowingForPrimaryUser:primaryUserFollowing];

    NSArray * primaryUserFollowers =
        [dict objectForKey:[[self class] primaryUserFollowersKey]];
    [userNetworkCacheSetter setFollowersForPrimaryUser:primaryUserFollowers];
}

- (void)save
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    NSArray * primaryUserFollowing =
        [userNetworkCacheReader followingForPrimaryUser];

    if (primaryUserFollowing)
        [dict setObject:primaryUserFollowing
            forKey:[[self class] primaryUserFollowingKey]];

    NSArray * primaryUserFollowers =
        [userNetworkCacheReader followersForPrimaryUser];
    if (primaryUserFollowers)
        [dict setObject:primaryUserFollowers
             forKey:[[self class] primaryUserFollowersKey]];

    [PlistUtils saveDictionary:dict toPlist:[[self class] plistName]];
}

+ (NSString *)plistName
{
    return @"UserNetworkCache";
}

+ (NSString *)primaryUserFollowingKey
{
    return @"primaryUserFollowing";
}

+ (NSString *)primaryUserFollowersKey
{
    return @"primaryUserFollowers";
}

@end
