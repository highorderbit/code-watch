//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewsFeedDisplayMgr.h"
#import "GitHubNewsFeedService.h"
#import "GitHubNewsFeedServiceFactory.h"
#import "RssItem.h"
#import "RepoSelectorFactory.h"
#import "NSString+RegexKitLiteHelpers.h"
#import "UIAlertView+CreationHelpers.h"
#import "NewsFeedItemViewController.h"

@interface NewsFeedDisplayMgr (Private)

- (NSObject<RepoSelector> *)repoSelector;
- (NewsFeedItemViewController *)newsFeedItemViewController;

@end

@implementation NewsFeedDisplayMgr

- (void)dealloc
{
    [repoSelectorFactory release];
    [repoSelector release];

    [navigationController release];    
    [networkAwareViewController release];
    [newsFeedTableViewController release];

    [newsFeedItemViewController release];
    
    [cacheReader release];
    [logInState release];

    [newsFeed release];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    newsFeed = [[newsFeedServiceFactory createGitHubNewsFeedService] retain];
    newsFeed.delegate = self;
}

- (void)viewWillAppear
{
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
    
    if (logInState.login) {
        [networkAwareViewController
        setNoConnectionText:
        NSLocalizedString(@"nodata.noconnection.text", @"")];
        
        NSArray * rssItems = [cacheReader primaryUserNewsFeed];
        [newsFeedTableViewController updateRssItems:rssItems];

        [newsFeed fetchNewsFeedForUsername:logInState.login];
        
        [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
        [networkAwareViewController setCachedDataAvailable:!!rssItems];
    } else {
        // This is a bit of a hack, but a relatively simple solution:
        // Configure the network-aware controller to 'disconnected' and set the
        // disconnected text accordingly
        [networkAwareViewController
            setNoConnectionText:
            NSLocalizedString(@"newsfeeddisplaymgr.login.text", @"")];
        [networkAwareViewController setUpdatingState:kDisconnected];
        [networkAwareViewController setCachedDataAvailable:NO];
    }
}

#pragma mark NewsFeedTableViewControllerDelegate implementation

- (void)userDidSelectRssItem:(RssItem *)rssItem
{
    if ([rssItem.type isEqualToString:@"WatchEvent"]) {
        NSString * user =
            [rssItem.subject stringByMatchingRegex:
            @"started watching (.+)/.*$"];
        NSString * repo =
            [rssItem.subject stringByMatchingRegex:
            @"started watching .+/(.+)$"];

        if (user && repo)
            [[self repoSelector] user:user didSelectRepo:repo];
        else {
            NSLog(@"Failed to parse RSS item: '%@'.", rssItem);
            NSString * title =
                NSLocalizedString(@"newsfeed.item.display.failed.title", @"");
            NSString * message =
                NSLocalizedString(@"newsfeed.item.parse.failed.message", @"");

            UIAlertView * alertView =
                [UIAlertView simpleAlertViewWithTitle:title
                                         errorMessage:message];
            [alertView show];

            [newsFeedTableViewController viewWillAppear:NO];
        }
    } else {
        [[self newsFeedItemViewController] updateWithRssItem:rssItem];
        [navigationController
            pushViewController:[self newsFeedItemViewController] animated:YES];
    }
}

#pragma mark GitHubNewsFeedDelegate implementation

- (void)newsFeed:(NSArray *)newsItems fetchedForUsername:(NSString *)username
{
    [newsFeedTableViewController updateRssItems:newsItems];

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToFetchNewsFeedForUsername:(NSString *)username
                                   error:(NSError *)error
{
    NSLog(@"Failed to retrieve news feed for username: '%@' error: '%@'.",
        username, error);

    NSString * title =
        NSLocalizedString(@"github.newsfeedupdate.failed.alert.title", @"");
    UIAlertView * alertView =
        [UIAlertView simpleAlertViewWithTitle:title
                                 errorMessage:error.localizedDescription];

    [alertView show];

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

#pragma mark Accessors

- (NSObject<RepoSelector> *)repoSelector
{
    if (!repoSelector)
        repoSelector =
            [repoSelectorFactory
            createRepoSelectorWithNavigationController:navigationController];

    return repoSelector;
}

- (NewsFeedItemViewController *)newsFeedItemViewController
{
    if (!newsFeedItemViewController) {
        newsFeedItemViewController =
            [[NewsFeedItemViewController alloc]
            initWithNibName:@"NewsFeedItemView" bundle:nil];
    }

    return newsFeedItemViewController;
}

@end
