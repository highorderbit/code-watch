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

@class GitHubNewsFeedService, GitHubNewsFeedServiceFactory;

@interface NewsFeedDisplayMgr :
    NSObject <NetworkAwareViewControllerDelegate, GitHubNewsFeedServiceDelegate>
{
    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet NewsFeedTableViewController * newsFeedTableViewController;
    
    IBOutlet NSObject<NewsFeedCacheReader> * cacheReader;
    IBOutlet NSObject<LogInStateReader> * logInState;

    IBOutlet GitHubNewsFeedServiceFactory * newsFeedServiceFactory;

    GitHubNewsFeedService * newsFeed;
}

@end
