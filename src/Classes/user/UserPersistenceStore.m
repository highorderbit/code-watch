//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserPersistenceStore.h"
#import "UserInfo.h"
#import "PListUtils.h"

@interface UserPersistenceStore (Private)

+ (NSDictionary *)dictionaryFromUserInfo:(UserInfo *)userInfo;
+ (UserInfo *)userInfoFromDictionary:(NSDictionary *)dict;

+ (NSString *)detailsKey;
+ (NSString *)reposKey;

+ (NSString *)plistName;
+ (NSString *)primaryUserKey;
+ (NSString *)userHistoryKey;

@end

@implementation UserPersistenceStore

- (void)dealloc
{
    [userCacheReader release];
    [userCacheSetter release];
    [super dealloc];
}

- (void)load
{
    NSDictionary * dict =
        [PlistUtils getDictionaryFromPlist:[[self class] plistName]];

    NSDictionary * primaryUserInfoDict =
        [dict objectForKey :[[self class] primaryUserKey]];
    UserInfo * primaryUserInfo =
        [[self class] userInfoFromDictionary:primaryUserInfoDict];
    
    [userCacheSetter setPrimaryUser:primaryUserInfo];
    
    NSDictionary * recentlyViewedUsers =
        [dict objectForKey:[[self class] userHistoryKey]];
    
    for (NSString * username in [recentlyViewedUsers allKeys]) {
        NSDictionary * userInfoDict =
            [recentlyViewedUsers objectForKey:username];
        UserInfo * userInfo =
            [[self class] userInfoFromDictionary:userInfoDict];
        [userCacheSetter addRecentlyViewedUser:userInfo withUsername:username];
    }
}

- (void)save
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSDictionary * primaryUserDict =
        [[self class] dictionaryFromUserInfo:userCacheReader.primaryUser];
    if (primaryUserDict)
        [dict setObject:primaryUserDict forKey:[[self class] primaryUserKey]];
    
    NSMutableDictionary * userHistoryDict =
        [[[NSMutableDictionary alloc] init] autorelease];
    NSDictionary * allUsers = userCacheReader.allUsers;
    for (NSString * username in [allUsers allKeys]) {
        UserInfo * userInfo = [allUsers objectForKey:username];
        NSDictionary * userInfoDict =
            [[self class] dictionaryFromUserInfo:userInfo];
        [userHistoryDict setObject:userInfoDict forKey:username];
    }
    [dict setObject:userHistoryDict forKey:[[self class] userHistoryKey]];

    [PlistUtils saveDictionary:dict toPlist:[[self class] plistName]];
}

#pragma mark Static helper methods

+ (NSDictionary *)dictionaryFromUserInfo:(UserInfo *)userInfo
{
    NSMutableDictionary * dict;
    if (userInfo) {
        dict = [[[NSMutableDictionary alloc] init] autorelease];
    
        if (userInfo.details)
            [dict setObject:userInfo.details forKey:[[self class] detailsKey]];
        if (userInfo.repoKeys)
            [dict setObject:userInfo.repoKeys forKey:[[self class] reposKey]];
    } else
        dict = nil;
    
    return dict;
}

+ (UserInfo *)userInfoFromDictionary:(NSDictionary *)dict
{
    UserInfo * userInfo;
    if (dict) {
        NSDictionary * details = [dict objectForKey:[[self class] detailsKey]];
        NSArray * repoKeys = [dict objectForKey:[[self class] reposKey]];
    
        userInfo =
            [[[UserInfo alloc]
            initWithDetails:details repoKeys:repoKeys] autorelease];
    } else
        userInfo = nil;
    
    return userInfo;
}

+ (NSString *)detailsKey
{
    return @"details";
}

+ (NSString *)reposKey
{
    return @"repoKeys";
}

+ (NSString *)plistName
{
    return @"UserCache";
}

+ (NSString *)primaryUserKey
{
    return @"primaryUser";
}

+ (NSString *)userHistoryKey
{
    return @"userHistory";
}

@end
