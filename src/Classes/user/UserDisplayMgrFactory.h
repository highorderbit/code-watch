//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceFactory.h"
#import "GravatarServiceFactory.h"
#import "RepoSelectorFactory.h"
#import "UserCache.h"
#import "AvatarCache.h"
#import "UserDisplayMgr.h"
#import "ContactCache.h"
#import "ContactMgr.h"
#import "NewsFeedDisplayMgrFactory.h"
#import "RepoCache.h"

@interface UserDisplayMgrFactory : NSObject
{
    IBOutlet GitHubServiceFactory * gitHubServiceFactory;
    IBOutlet GravatarServiceFactory * gravatarServiceFactory;
    IBOutlet RepoSelectorFactory * repoSelectorFactory;
    IBOutlet UserCache * userCache;
    IBOutlet RepoCache * repoCache;
    IBOutlet AvatarCache * avatarCache;
    IBOutlet ContactCache * contactCache;
    IBOutlet ContactMgr * contactMgr;
    IBOutlet NewsFeedDisplayMgrFactory * newsFeedDisplayMgrFactory;
}

- (NSObject<UserDisplayMgr> *)
    createUserDisplayMgrWithNavigationContoller:
    (UINavigationController *)navigationController;

@end
