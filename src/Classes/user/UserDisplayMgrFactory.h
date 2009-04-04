//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceFactory.h"
#import "GravatarServiceFactory.h"
#import "RepoSelectorFactory.h"
#import "UserCache.h"
#import "AvatarCache.h"
#import "FavoriteUsersState.h"
#import "UserDisplayMgr.h"
#import "ContactCache.h"

@interface UserDisplayMgrFactory : NSObject
{
    IBOutlet GitHubServiceFactory * gitHubServiceFactory;
    IBOutlet GravatarServiceFactory * gravatarServiceFactory;
    IBOutlet RepoSelectorFactory * repoSelectorFactory;
    IBOutlet UserCache * userCache;
    IBOutlet AvatarCache * avatarCache;
    IBOutlet FavoriteUsersState * favoriteUsersState;
    IBOutlet ContactCache * contactCache;
}

- (NSObject<UserDisplayMgr> *)
    createUserDisplayMgrWithNavigationContoller:
    (UINavigationController *)navigationController;

@end
