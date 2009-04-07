//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
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

//@class UserDisplayMgrFactory, RepoSelectorFactory;
@class NetworkAwareViewController, NewsFeedViewController;
@class NewsFeedItemViewController, NewsFeedItemDetailsViewController;
@class GitHubNewsFeedService, GitHubService, GravatarService;
@class UserInfo, RssItem;

@interface NewsFeedDisplayMgr :
    NSObject
    <NetworkAwareViewControllerDelegate,
    GitHubNewsFeedServiceDelegate, GitHubServiceDelegate,
    GravatarServiceDelegate, NewsFeedViewControllerDelegate,
    NewsFeedItemViewControllerDelegate>
{
    //IBOutlet UserDisplayMgrFactory * userDisplayMgrFactory;
    NSObject<UserDisplayMgr> * userDisplayMgr;

    //IBOutlet RepoSelectorFactory * repoSelectorFactory;
    NSObject<RepoSelector> * repoSelector;

    /*IBOutlet*/ UINavigationController * navigationController;

    /*IBOutlet*/ NetworkAwareViewController * networkAwareViewController;
    NewsFeedViewController * newsFeedViewController;
    NewsFeedItemViewController * newsFeedItemViewController;
    NewsFeedItemDetailsViewController * newsFeedItemDetailsViewController;
    
    /*IBOutlet*/ NSObject<LogInStateReader> * logInStateReader;
    /*IBOutlet*/ NSObject<NewsFeedCacheReader> * newsFeedCacheReader;
    /*IBOutlet*/ NSObject<UserCacheReader> * userCacheReader;
    /*IBOutlet*/ NSObject<AvatarCacheReader> * avatarCacheReader;

    //IBOutlet GitHubNewsFeedServiceFactory * newsFeedServiceFactory;
    GitHubNewsFeedService * newsFeedService;

    //IBOutlet GitHubServiceFactory * gitHubServiceFactory;
    GitHubService * gitHubService;

    //IBOutlet GravatarServiceFactory * gravatarServiceFactory;
    GravatarService * gravatarService;

    NSString * username;
    //UserInfo * userInfo;

    // mapping of email address -> usernames
    NSMutableDictionary * usernames;

    RssItem * selectedRssItem;
}

@property (nonatomic, copy) NSString * username;
//@property (nonatomic, copy) UserInfo * userInfo;

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

#pragma mark Display the news feed

- (void)updateNewsFeed;

@end
