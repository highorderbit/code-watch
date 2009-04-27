//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserNetworkCacheSetter

- (void)setFollowingForPrimaryUser:(NSArray *)following;
- (void)setFollowersForPrimaryUser:(NSArray *)followers;

@end
