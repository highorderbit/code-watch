//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "PrimaryUserNewsFeedDisplayMgr.h"

@implementation PrimaryUserNewsFeedDisplayMgr

- (void)dealloc
{
    [super dealloc];
}

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
                   gravatarService:(GravatarService *)aGravatarService
{
    id spr = [super initWithNavigationController:nc
                      networkAwareViewController:navc
                          newsFeedViewController:nfvc
                                  userDisplayMgr:aUserDisplayMgr
                                    repoSelector:aRepoSelector
                                logInStateReader:lisReader
                             newsFeedCacheReader:nfCache
                                 userCacheReader:uCache
                               avatarCacheReader:avCache
                                 newsFeedService:aNewsFeedService
                                   gitHubService:aGitHubService
                                 gravatarService:aGravatarService];

    networkAwareViewController.delegate = spr;

    return self = spr;
}

- (void)viewWillAppear
{
    [super viewWillAppear];

    // make sure that the view is refreshed if application state changed
    // (e.g. the user has logged out or logged in)
    if (logInStateReader.login != username)
        [self updateNewsFeed];
}

- (void)updateNewsFeed
{
    [super updateNewsFeed];
}

@end
