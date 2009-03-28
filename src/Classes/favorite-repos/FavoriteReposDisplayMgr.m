//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteReposDisplayMgr.h"

@implementation FavoriteReposDisplayMgr

- (void)dealloc
{
    [viewController release];
    [favoriteReposStateReader release];
    [favoriteReposStateSetter release];
    [super dealloc];
}

- (id)initWithViewController:(FavoriteReposViewController *)aViewController
    stateReader:(NSObject<FavoriteReposStateReader> *)aFavoriteReposStateReader
    stateSetter:(NSObject<FavoriteReposStateSetter> *)aFavoriteReposStateSetter
{
    if (self = [super init]) {
        viewController = [aViewController retain];
        favoriteReposStateReader = [aFavoriteReposStateReader retain];
        favoriteReposStateSetter = [aFavoriteReposStateSetter retain];
    }
    
    return self;
}

#pragma mark FavoriteReposViewControllerDelegate implementation

- (void)viewWillAppear
{
    [viewController setRepoKeys:favoriteReposStateReader.favoriteRepoKeys];
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
