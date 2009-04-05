//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkAwareViewControllerDelegate.h"
#import "NetworkAwareViewController.h"
#import "NewsFeedTableViewController.h"
#import "NewsFeedCacheReader.h"
#import "LogInStateReader.h"
#import "UserCacheReader.h"
#import "AvatarCacheReader.h"
#import "GitHubNewsFeedServiceDelegate.h"
#import "GitHubServiceDelegate.h"
#import "GravatarServiceDelegate.h"
#import "NewsFeedTableViewControllerDelegate.h"
#import "NewsFeedItemViewControllerDelegate.h"
#import "UserDisplayMgr.h"
#import "RepoSelector.h"

@class UserDisplayMgrFactory, RepoSelectorFactory;
@class GitHubNewsFeedService, GitHubNewsFeedServiceFactory;
@class GitHubService, GitHubServiceFactory;
@class GravatarService, GravatarServiceFactory;
@class NewsFeedItemViewController, NewsFeedItemDetailsViewController;
@class RssItem;

@interface NewsFeedDisplayMgr :
    NSObject
    <NetworkAwareViewControllerDelegate,
    GitHubNewsFeedServiceDelegate, GitHubServiceDelegate,
    GravatarServiceDelegate, NewsFeedTableViewControllerDelegate,
    NewsFeedItemViewControllerDelegate>
{
    IBOutlet UserDisplayMgrFactory * userDisplayMgrFactory;
    NSObject<UserDisplayMgr> * userDisplayMgr;

    IBOutlet RepoSelectorFactory * repoSelectorFactory;
    NSObject<RepoSelector> * repoSelector;

    IBOutlet UINavigationController * navigationController;
    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet NewsFeedTableViewController * newsFeedTableViewController;

    NewsFeedItemViewController * newsFeedItemViewController;
    NewsFeedItemDetailsViewController * newsFeedItemDetailsViewController;
    
    IBOutlet NSObject<NewsFeedCacheReader> * newsFeedCacheReader;
    IBOutlet NSObject<LogInStateReader> * logInState;
    IBOutlet NSObject<UserCacheReader> * userCacheReader;
    IBOutlet NSObject<AvatarCacheReader> * avatarCacheReader;

    IBOutlet GitHubNewsFeedServiceFactory * newsFeedServiceFactory;

    GitHubNewsFeedService * newsFeed;

    IBOutlet GitHubServiceFactory * gitHubServiceFactory;
    GitHubService * gitHubService;

    IBOutlet GravatarServiceFactory * gravatarServiceFactory;
    GravatarService * gravatarService;

    // mapping of email address -> usernames
    NSMutableDictionary * usernames;

    RssItem * selectedRssItem;
}

- (void)updateNewsFeed;

@end
