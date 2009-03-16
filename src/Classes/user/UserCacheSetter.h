//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@protocol UserCacheSetter

- (void)setPrimaryUser:(UserInfo *)user;
- (void)addRecentlyViewedUser:(UserInfo *)user
    withUsername:(NSString *)username;

@end
