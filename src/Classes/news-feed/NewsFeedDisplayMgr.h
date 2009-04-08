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
    NSObject<UserDisplayMgr> * userDisplayMgr;
    NSObject<RepoSelector> * repoSelector;

    UINavigationController * navigationController;

    NetworkAwareViewController * networkAwareViewController;
    NewsFeedViewController * newsFeedViewController;
    NewsFeedItemViewController * newsFeedItemViewController;
    NewsFeedItemDetailsViewController * newsFeedItemDetailsViewController;

    NSObject<LogInStateReader> * logInStateReader;
    NSObject<NewsFeedCacheReader> * newsFeedCacheReader;
    NSObject<UserCacheReader> * userCacheReader;
    NSObject<AvatarCacheReader> * avatarCacheReader;

    GitHubNewsFeedService * newsFeedService;
    GitHubService * gitHubService;
    GravatarService * gravatarService;

    NSString * username;

    // mapping of email address -> usernames
    NSMutableDictionary * usernames;

    RssItem * selectedRssItem;

    // HACK: Used to decide with which feed the view updates itself when
    // called from 'viewWillAppear'. It could be from the network aware
    // view controller that sits in the tab bar, or from one of the nested
    // feeds. When we pop back to the view, or when it's displayed for the
    // first time in the case of the tab bar view, we call this selector to
    // refresh the displayed data.
    SEL refreshSelector;
    NSObject * refreshObject;
}

@property (nonatomic, copy) NSString * username;

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
- (void)updateActivityFeedForPrimaryUser;
- (void)updateActivityFeedForUsername:(NSString *)user;

@end
