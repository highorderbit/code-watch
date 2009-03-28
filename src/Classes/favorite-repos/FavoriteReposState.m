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
    
    // TEMPORARY
    RepoKey * repoKey1 =
        [[[RepoKey alloc]
        initWithUsername:@"highorderbit" repoName:@"code-watch"] autorelease];
    RepoKey * repoKey2 =
        [[[RepoKey alloc]
        initWithUsername:@"mrtrumbe" repoName:@"meliman"] autorelease];
    [self addFavoriteRepoKey:repoKey1];
    [self addFavoriteRepoKey:repoKey2];
    // TEMPORARY
}

#pragma mark FavoriteReposStateReader implementation

- (NSArray *)favoriteRepoKeys
{
    return [favoriteRepoKeys copy];
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
