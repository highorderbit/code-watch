//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeedDisplayMgr.h"
#import "NetworkAwareViewControllerDelegate.h"
#import "NetworkAwareViewController.h"
#import "NewsFeedCacheReader.h"
#import "LogInStateReader.h"
#import "UserCacheReader.h"
#import "AvatarCacheReader.h"
#import "GitHubNewsFeedServiceDelegate.h"
#import "GitHubServiceDelegate.h"
#import "GravatarServiceDelegate.h"
#import "NewsFeedViewControllerDelegate.h"
#import "NewsFeedItemViewControllerDelegate.h"
#import "UserDisplayMgr.h"
#import "RepoSelector.h"

@interface PrimaryUserNewsFeedDisplayMgr :
    NewsFeedDisplayMgr
    <NetworkAwareViewControllerDelegate>
{
}

#pragma mark Initialization

- (id)initWithNavigationController:(UINavigationController *)nc
        networkAwareViewController:(NetworkAwareViewController *)navc
            newsFeedViewController:(NewsFeedViewController *)nfvc
                    userDisplayMgr:(NSObject<UserDisplayMgr> *)aUserDisplayMgr
                      repoSelector:(NSObject<RepoSelector> *)aRepoSelector
                  logInStateReader:(NSObject<LogInStateReader> *)lisReader
               newsFeedCacheReader:(NSObject<NewsFeedCacheReader> *)nfCache
                   userCacheReader:(NSObject<UserCacheReader> *)uCache
                 avatarCacheReader:(NSObject<AvatarCacheReader> *)avCache
                   newsFeedService:(GitHubNewsFeedService *)aNewsFeedService
                     gitHubService:(GitHubService *)aGitHubService
                   gravatarService:(GravatarService *)aGravatarService;

#pragma mark Updating the news feed

- (void)updateNewsFeed;

@end
