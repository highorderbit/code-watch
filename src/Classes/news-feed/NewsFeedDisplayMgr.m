//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewsFeedDisplayMgr.h"
#import "GitHubNewsFeedService.h"
#import "GitHubNewsFeedServiceFactory.h"

@implementation NewsFeedDisplayMgr

- (void)dealloc
{
    [networkAwareViewController release];
    [newsFeedTableViewController release];
    
    [cacheReader release];
    [logInState release];

    [newsFeed release];
    
    [super dealloc];
}

- (void)awakFromNib
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
        
        NSArray * rssItems = cacheReader.rssItems;
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

#pragma mark GitHubNewsFeedDelegate implementation

- (void)newsFeed:(NSArray *)newsFeed fetchedForUsername:(NSString *)username
{
}

- (void)failedToFetchNewsFeedForUsername:(NSString *)username
                                   error:(NSError *)error
{
}

@end
