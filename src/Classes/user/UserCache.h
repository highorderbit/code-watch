//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "UserCacheReader.h"
#import "UserCacheSetter.h"

@interface UserCache : NSObject <UserCacheReader, UserCacheSetter> {
    UserInfo * primaryUser;
    NSMutableDictionary * recentlyViewedUsers;
    
    // Helpers for managing history
    NSMutableArray * userHistory;
    NSMutableDictionary * historyAppearances;
}

@end
