//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserCache.h"

static const NSInteger RECENTLY_VIEWED_HISTORY_MAX = 100;

@implementation UserCache

- (void)dealloc
{
    [primaryUser release];
    [recentlyViewedUsers release];
    [super dealloc];
}

- (void)awakeFromNib
{
    recentlyViewedUsers = [[NSMutableDictionary alloc] init];
    userHistory = [[NSMutableArray alloc] init];
    historyAppearances = [[NSMutableDictionary alloc] init];
}

#pragma mark User cache reader methods

- (UserInfo *)primaryUser
{
    return [[primaryUser copy] autorelease];
}

- (UserInfo *)userWithUsername:(NSString *)username
{
    return [[[recentlyViewedUsers objectForKey:username] copy] autorelease];
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
    user = [[user copy] autorelease];
    [recentlyViewedUsers setObject:user forKey:username];
    
    [userHistory insertObject:user atIndex:0];
    
    NSNumber * numAppearances = [historyAppearances objectForKey:username];
    if (numAppearances) {
        NSInteger appearancesAsInt = [numAppearances integerValue] + 1;
        numAppearances = [NSNumber numberWithInteger:appearancesAsInt];
        [historyAppearances setObject:numAppearances forKey:username];
    } else
        [historyAppearances setObject:[NSNumber numberWithInteger:1]
            forKey:username];

    if ([userHistory count] > RECENTLY_VIEWED_HISTORY_MAX) {
        NSString * oldestUsername =
            [userHistory objectAtIndex:RECENTLY_VIEWED_HISTORY_MAX];
        [userHistory removeObjectAtIndex:RECENTLY_VIEWED_HISTORY_MAX];
        NSInteger oldestNumAppearances =
            [[historyAppearances objectForKey:oldestUsername] integerValue] - 1;
        
        if (oldestNumAppearances == 0)
            [historyAppearances removeObjectForKey:oldestUsername];
        else
            [historyAppearances
                setObject:[NSNumber numberWithInteger:oldestNumAppearances]
                forKey:oldestUsername];
    }
}

@end
