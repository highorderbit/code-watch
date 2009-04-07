//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedDisplayMgrFactory.h"
#import "NewsFeedDisplayMgr.h"
#import "UserDisplayMgrFactory.h"
#import "RepoSelectorFactory.h"
#import "GitHubNewsFeedServiceFactory.h"
#import "GitHubServiceFactory.h"
#import "GravatarServiceFactory.h"
#import "NewsFeedViewController.h"

@interface NewsFeedDisplayMgrFactory (Private)

- (id)createNewsFeedDisplayMgr:(UINavigationController *)nc
    networkAwareViewController:(NetworkAwareViewController *)navc
        newsFeedViewController:(NewsFeedViewController *)nfvc;

@end

@implementation NewsFeedDisplayMgrFactory

- (void)dealloc
{
    [navigationController release];
    [networkAwareViewController release];
    [newsFeedViewController release];

    [userDisplayMgrFactory release];
    [repoSelectorFactory release];

    [logInStateReader release];
    [newsFeedCacheReader release];
    [userCacheReader release];
    [avatarCacheReader release];

    [gitHubNewsFeedServiceFactory release];
    [gitHubServiceFactory release];
    [gravatarServiceFactory release];

    [super dealloc];
}

- (id)createPrimaryUserNewsFeedDisplayMgr
{
    NewsFeedDisplayMgr * mgr =
        [self createNewsFeedDisplayMgr:navigationController
               networkAwareViewController:networkAwareViewController
                   newsFeedViewController:newsFeedViewController];

    mgr.username = logInStateReader.login;

    return mgr;
}

- (id)createNewsFeedDisplayMgr:(UINavigationController *)nc
{
    NewsFeedViewController * nfvc =
        [[[NewsFeedViewController alloc]
        initWithNibName:@"NewsFeedView" bundle:nil] autorelease];

    NetworkAwareViewController * navc =
        [[[NetworkAwareViewController alloc]
        initWithTargetViewController:newsFeedViewController] autorelease];

    return [self createNewsFeedDisplayMgr:nc
               networkAwareViewController:navc
                   newsFeedViewController:nfvc];
}

- (id)createNewsFeedDisplayMgr:(UINavigationController *)nc
    networkAwareViewController:(NetworkAwareViewController *)navc
        newsFeedViewController:(NewsFeedViewController *)nfvc
{
    NSObject<UserDisplayMgr> * userDisplayMgr =
        [userDisplayMgrFactory createUserDisplayMgrWithNavigationContoller:nc];

    NSObject<RepoSelector> * repoSelector =
        [repoSelectorFactory createRepoSelectorWithNavigationController:nc];

    GitHubNewsFeedService * newsFeedService =
        [gitHubNewsFeedServiceFactory createGitHubNewsFeedService];
    GitHubService * gitHubService = [gitHubServiceFactory createGitHubService];
    GravatarService * gravatarService =
        [gravatarServiceFactory createGravatarService];

    NewsFeedDisplayMgr * mgr =
        [[NewsFeedDisplayMgr alloc]
        initWithNavigationController:nc
          networkAwareViewController:navc
              newsFeedViewController:nfvc
                      userDisplayMgr:userDisplayMgr
                        repoSelector:repoSelector
                    logInStateReader:logInStateReader
                 newsFeedCacheReader:newsFeedCacheReader
                     userCacheReader:userCacheReader
                   avatarCacheReader:avatarCacheReader
                     newsFeedService:newsFeedService
                       gitHubService:gitHubService
                     gravatarService:gravatarService];

    return [mgr autorelease];
}

@end
