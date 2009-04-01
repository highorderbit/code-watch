//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceFactory.h"
#import "RepoSelectorFactory.h"
#import "UserCache.h"
#import "FavoriteUsersState.h"
#import "UserDisplayMgr.h"

@interface UserDisplayMgrFactory : NSObject
{
    IBOutlet GitHubServiceFactory * gitHubServiceFactory;
    IBOutlet RepoSelectorFactory * repoSelectorFactory;
    IBOutlet UserCache * userCache;
    IBOutlet FavoriteUsersState * favoriteUsersState;
}

- (NSObject<UserDisplayMgr> *)
    createUserDisplayMgrWithNavigationContoller:
    (UINavigationController *)navigationController;

@end
