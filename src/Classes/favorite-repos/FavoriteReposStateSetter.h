//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepoKey.h"

@protocol FavoriteReposStateSetter

- (void)addFavoriteRepoKey:(RepoKey *)repoKey;
- (void)removeFavoriteRepoKey:(RepoKey *)repoKey;

@end
