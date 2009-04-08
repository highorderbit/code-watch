//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserCache.h"

@implementation UserCache

@synthesize primaryUser;

- (void)dealloc
{
    [primaryUser release];
    [recentHistoryCache release];
    [super dealloc];
}

- (void)awakeFromNib
{
    recentHistoryCache = [[RecentHistoryCache alloc] init];
}

#pragma mark User cache reader methods

- (UserInfo *)userWithUsername:(NSString *)username
{
    return [[[recentHistoryCache objectForKey:username] copy] autorelease];
}

- (NSDictionary *)allUsers
{
    return [recentHistoryCache allRecentlyViewed];
}

#pragma mark User cache setter methods

- (void)setPrimaryUser:(UserInfo *)user
{
    user = [user copy];
    [primaryUser release];
    primaryUser = user;
}

- (void)addRecentlyViewedUser:(UserInfo *)user withUsername:(NSString *)username
{
    [recentHistoryCache setObject:user forKey:username];
}

@end
