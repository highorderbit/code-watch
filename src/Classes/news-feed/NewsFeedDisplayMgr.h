//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkAwareViewControllerDelegate.h"
#import "NetworkAwareViewController.h"
#import "NewsFeedTableViewController.h"
#import "NewsFeedCacheReader.h"
#import "LogInStateReader.h"
#import "GitHubNewsFeedServiceDelegate.h"
#import "NewsFeedTableViewControllerDelegate.h"
#import "RepoSelector.h"

@class RepoSelectorFactory;
@class GitHubNewsFeedService, GitHubNewsFeedServiceFactory;

@interface NewsFeedDisplayMgr :
    NSObject
    <NetworkAwareViewControllerDelegate, GitHubNewsFeedServiceDelegate,
    NewsFeedTableViewControllerDelegate>
{
    IBOutlet RepoSelectorFactory * repoSelectorFactory;
    NSObject<RepoSelector> * repoSelector;

    IBOutlet UINavigationController * navigationController;
    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet NewsFeedTableViewController * newsFeedTableViewController;
    
    IBOutlet NSObject<NewsFeedCacheReader> * cacheReader;
    IBOutlet NSObject<LogInStateReader> * logInState;

    IBOutlet GitHubNewsFeedServiceFactory * newsFeedServiceFactory;

    GitHubNewsFeedService * newsFeed;
}

@end
