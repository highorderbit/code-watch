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

- (void)viewWillAppear
{
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
    
    if (logInState.login) {
        [networkAwareViewController
        setNoConnectionText:NSLocalizedString(@"nodata.noconnection.text", @"")];
        
        NSArray * rssItems = cacheReader.rssItems;
        [newsFeedTableViewController updateRssItems:rssItems];
        
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

@end
