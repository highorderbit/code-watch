//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@protocol UserCacheReader

@property (readonly, copy) UserInfo * primaryUser;
@property (readonly, copy) NSDictionary * allUsers;
- (UserInfo *)userWithUsername:(NSString *)username;

@end
