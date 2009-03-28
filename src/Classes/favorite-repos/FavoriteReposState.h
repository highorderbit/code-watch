//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteReposStateReader.h"
#import "FavoriteReposStateSetter.h"

@interface FavoriteReposState :
    NSObject <FavoriteReposStateReader, FavoriteReposStateSetter>
{
    NSMutableArray * favoriteRepoKeys;
}

@end
