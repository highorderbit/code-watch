//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserPersistenceStore.h"
#import "UserInfo.h"

@interface UserPersistenceStore (Private)

+ (NSDictionary *)dictionaryFromUserInfo:(UserInfo *)userInfo;
+ (UserInfo *)userInfoFromDictionary:(NSDictionary *)dict;

@end

@implementation UserPersistenceStore

- (void)dealloc
{
    [userCacheReader release];
    [userCacheSetter release];
    [super dealloc];
}

- (void) load
{}

- (void) save
{}

#pragma mark Static helper methods

+ (NSDictionary *)dictionaryFromUserInfo:(UserInfo *)userInfo
{
    return nil;
}

+ (UserInfo *)userInfoFromDictionary:(NSDictionary *)dict
{
    return nil;
}

@end
