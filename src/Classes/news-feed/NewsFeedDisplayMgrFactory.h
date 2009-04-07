//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInStateReader.h"
#import "NewsFeedCacheReader.h"
#import "UserCacheReader.h"
#import "AvatarCacheReader.h"

@class NetworkAwareViewController, NewsFeedViewController;
@class UserDisplayMgrFactory, RepoSelectorFactory;
@class GitHubNewsFeedServiceFactory, GitHubServiceFactory;
@class GravatarServiceFactory;

@interface NewsFeedDisplayMgrFactory : NSObject
{
    // only used when creating a primary user instance of the display manager
    IBOutlet UINavigationController * navigationController;
    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet NewsFeedViewController * newsFeedViewController;

    IBOutlet UserDisplayMgrFactory * userDisplayMgrFactory;
    IBOutlet RepoSelectorFactory * repoSelectorFactory;

    IBOutlet NSObject<LogInStateReader> * logInStateReader;
    IBOutlet NSObject<NewsFeedCacheReader> * newsFeedCacheReader;
    IBOutlet NSObject<UserCacheReader> * userCacheReader;
    IBOutlet NSObject<AvatarCacheReader> * avatarCacheReader;

    IBOutlet GitHubNewsFeedServiceFactory * gitHubNewsFeedServiceFactory;
    IBOutlet GitHubServiceFactory * gitHubServiceFactory;
    IBOutlet GravatarServiceFactory * gravatarServiceFactory;
}

#pragma mark Creating autoreleased instances

- (id)createPrimaryUserNewsFeedDisplayMgr;
- (id)createNewsFeedDisplayMgr:(UINavigationController *)nc;

@end
