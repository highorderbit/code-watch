//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteReposDisplayMgr.h"

@implementation FavoriteReposDisplayMgr

- (id)initWithViewController:(FavoriteReposViewController *)aViewController
{
    if (self = [super init]) {
        viewController = [aViewController retain];
    }
    
    return self;
}

#pragma mark FavoriteReposViewControllerDelegate implementation

- (void)viewWillAppear
{
    // [viewController setRepoKeys:favoriteReposStateReader.favoriteRepos];
    
    // TEMPORARY
    NSMutableArray * repoKeys = [NSMutableArray array];
    RepoKey * repoKey1 =
        [[[RepoKey alloc]
        initWithUsername:@"highorderbit" repoName:@"code-watch"] autorelease];
    RepoKey * repoKey2 =
        [[[RepoKey alloc]
        initWithUsername:@"mrtrumbe" repoName:@"meliman"] autorelease];
    [repoKeys addObject:repoKey1];
    [repoKeys addObject:repoKey2];
    [viewController setRepoKeys:repoKeys];
    // TEMPORARY
}

- (void)removedRepoKey:(RepoKey *)repoKey;
{
//    [favoriteReposStateSetter removeFavoriteRepo:repoKey];
//    [viewController setRepoKeys:favoriteUsersStateReader.favoriteRepos];
}

- (void)setRepoKeySortOrder:(NSArray *)sortedRepoKeys
{
    for (NSString * repoKey in sortedRepoKeys) {
//        [favoriteReposStateSetter removeFavoriteUser:repoKey];
//        [favoriteReposStateSetter addFavoriteUser:repoKey];
    }
}

- (void)selectedRepoKey:(RepoKey *)repoKey
{    
//    [userDisplayMgr displayUserInfoForUsername:username];
}

@end
