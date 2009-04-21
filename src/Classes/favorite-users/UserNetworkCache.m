//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserNetworkCache.h"

@implementation UserNetworkCache

@synthesize primaryUserFollowing;

- (void)dealloc
{
    [primaryUserFollowing release];
    [super dealloc];
}

- (NSArray *)followingForPrimaryUser
{
    return self.primaryUserFollowing;
}

- (void)setFollowingForPrimaryUser:(NSArray *)following
{
    self.primaryUserFollowing = following;
}

@end
