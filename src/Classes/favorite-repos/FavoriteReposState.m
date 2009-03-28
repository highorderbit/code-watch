//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteReposState.h"

@implementation FavoriteReposState

- (void)dealloc
{
    [favoriteRepoKeys release];
    [super dealloc];
}

- (void)awakeFromNib
{
    favoriteRepoKeys = [[NSMutableArray array] retain];
}

#pragma mark FavoriteReposStateReader implementation

- (NSArray *)favoriteRepoKeys
{
    return [[favoriteRepoKeys copy] autorelease];
}

#pragma mark FavoriteReposStateSetter implementation

- (void)addFavoriteRepoKey:(RepoKey *)repoKey
{
    if (![favoriteRepoKeys containsObject:repoKey])
        [favoriteRepoKeys addObject:repoKey];
}

- (void)removeFavoriteRepoKey:(RepoKey *)repoKey
{
    [favoriteRepoKeys removeObject:repoKey];
}

@end
