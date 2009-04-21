//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserNetworkCacheReader.h"
#import "UserNetworkCacheSetter.h"

@interface UserNetworkCache :
    NSObject <UserNetworkCacheReader, UserNetworkCacheSetter>
{
    NSArray * primaryUserFollowing;
}

@property (nonatomic, copy) NSArray * primaryUserFollowing;

@end
