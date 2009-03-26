//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecentActivityDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "NewsFeedTableViewController.h"
#import "GitHubService.h"

@interface UIRecentActivityDisplayMgr : NSObject <RecentActivityDisplayMgr>
{
    UINavigationController * navigationController;
    NetworkAwareViewController * networkAwareViewController;
    NewsFeedTableViewController * newsFeedTableViewController;
    
    GitHubService * gitHubService;
    
    NSString * username;
}

- (id)initWithNavigationController:
    (UINavigationController *) navigationController
    networkAwareViewController:
    (NetworkAwareViewController *) networkAwareViewController
    newsFeedTableViewController:
    (NewsFeedTableViewController *) newsFeedTableViewController
    gitHubService:
    (GitHubService *) gitHubService;

@end
