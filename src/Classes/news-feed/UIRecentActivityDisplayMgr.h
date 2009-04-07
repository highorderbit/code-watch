//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecentActivityDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "newsFeedViewController.h"
#import "GitHubService.h"

@interface UIRecentActivityDisplayMgr : NSObject <RecentActivityDisplayMgr>
{
    UINavigationController * navigationController;
    NetworkAwareViewController * networkAwareViewController;
    NewsFeedViewController * newsFeedViewController;
    
    GitHubService * gitHubService;
    
    NSString * username;
}

- (id)initWithNavigationController:
    (UINavigationController *) navigationController
    networkAwareViewController:
    (NetworkAwareViewController *) networkAwareViewController
    newsFeedViewController:
    (NewsFeedViewController *) newsFeedViewController
    gitHubService:
    (GitHubService *) gitHubService;

@end
