//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteUsersStateReader.h"
#import "FavoriteUsersStateSetter.h"

@interface FavoriteUsersState :
    NSObject <FavoriteUsersStateReader, FavoriteUsersStateSetter>
{
    NSMutableArray * favoriteUsers;
}

@end
