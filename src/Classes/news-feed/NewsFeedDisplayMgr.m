//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewsFeedDisplayMgr.h"

@implementation NewsFeedDisplayMgr

- (void)dealloc
{
    [networkAwareViewController release];
    [newsFeedTableViewController release];
    
    [cacheReader release];
    [logInState release];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    [networkAwareViewController setUpdatingText:@"Updating..."];
    [networkAwareViewController
        setNoConnectionCachedDataText:@"No Connection - Stale Data"];
}

- (void)display
{
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
    
    if (logInState.login) {
        [networkAwareViewController setNoConnectionText:@"No Connection"];
        
        NSArray * rssItems = cacheReader.rssItems;
        [newsFeedTableViewController updateRssItems:rssItems];
        
        [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
        [networkAwareViewController setCachedDataAvailable:!!rssItems];
    } else {
        // This is a bit of a hack, but a relatively simple solution:
        // Configure the network-aware controller to 'disconnected' and set the
        // disconnected text accordingly
        [networkAwareViewController
            setNoConnectionText:@"Please Log In to View News Feed"];
        [networkAwareViewController setUpdatingState:kDisconnected];
        [networkAwareViewController setCachedDataAvailable:NO];
    }
}

@end
