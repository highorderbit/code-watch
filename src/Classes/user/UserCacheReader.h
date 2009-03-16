//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@protocol UserCacheReader

- (UserInfo *)primaryUser;
- (UserInfo *)userWithUsername:(NSString *)username;

@end
