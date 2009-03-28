//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepoKey.h"

@protocol FavoriteReposViewControllerDelegate

- (void)viewWillAppear;
- (void)removedRepoKey:(RepoKey *)repoKey;
- (void)setRepoKeySortOrder:(NSArray *)sortedRepoKeys;
- (void)selectedRepoKey:(RepoKey *)repoKey;

@end
