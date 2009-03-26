//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UIRecentActivityDisplayMgr.h"

@implementation UIRecentActivityDisplayMgr

- (id)initWithNavigationController:
    (UINavigationController *) aNavigationController
    networkAwareViewController:
    (NetworkAwareViewController *) aNetworkAwareViewController
    newsFeedTableViewController:
    (NewsFeedTableViewController *) aNewsFeedTableViewController
    gitHubService:
    (GitHubService *) aGitHubService;
{
    if (self = [super init]) {
        navigationController = [aNavigationController retain];
        networkAwareViewController = [aNetworkAwareViewController retain];
        newsFeedTableViewController = [aNewsFeedTableViewController retain];
        gitHubService = [aGitHubService retain];
    }
    
    return self;
}

- (void)displayRecentHistoryForUser:(NSString *)aUsername
{
    aUsername = [aUsername copy];
    [username release];
    username = aUsername;
    
    [gitHubService fetchInfoForUsername:username];

    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    [networkAwareViewController setCachedDataAvailable:NO];

    [navigationController
        pushViewController:networkAwareViewController animated:YES];
    networkAwareViewController.navigationItem.title =
        NSLocalizedString(@"recentactivity.view.title", @"");
}

@end
