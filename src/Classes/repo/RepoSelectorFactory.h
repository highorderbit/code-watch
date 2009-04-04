//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceFactory.h"
#import "CommitSelectorFactory.h"
#import "LogInState.h"
#import "RepoCache.h"
#import "CommitCache.h"
#import "RepoSelector.h"
#import "FavoriteReposState.h"

@interface RepoSelectorFactory : NSObject
{
    IBOutlet GitHubServiceFactory * gitHubServiceFactory;
    IBOutlet CommitSelectorFactory * commitSelectorFactory;
    IBOutlet LogInState * logInState;
    IBOutlet RepoCache * repoCache;
    IBOutlet CommitCache * commitCache;
    IBOutlet FavoriteReposState * favoriteReposState;
}

- (NSObject<RepoSelector> *)
    createRepoSelectorWithNavigationController:
    (UINavigationController *)navigationController;

@end
