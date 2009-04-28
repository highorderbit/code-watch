//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserNetworkCache.h"

@implementation UserNetworkCache

@synthesize primaryUserFollowing, primaryUserFollowers;

- (void)dealloc
{
    [primaryUserFollowing release];
    [primaryUserFollowers release];
    [super dealloc];
}

- (NSArray *)followingForPrimaryUser
{
    return self.primaryUserFollowing;
}

- (NSArray *)followersForPrimaryUser
{
    return self.primaryUserFollowers;
}

- (void)setFollowingForPrimaryUser:(NSArray *)following
{
    self.primaryUserFollowing = following;
}

- (void)setFollowersForPrimaryUser:(NSArray *)followers
{
    self.primaryUserFollowers = followers;
}

@end
