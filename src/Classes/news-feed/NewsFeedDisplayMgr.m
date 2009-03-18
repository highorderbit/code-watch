//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewsFeedDisplayMgr.h"

@implementation NewsFeedDisplayMgr

- (void)dealloc
{
    [networkAwareViewController release];
    [cacheReader release];
    [super dealloc];
}

- (void)display
{
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
    
    // if (logInState && logInState.login) {
    //     [networkAwareViewController setNoConnectionText:@"No Connection"];
    //     
    //     // initiate news feed update
    // 
    //     NSArray * rssItems = cacheReader.rssItems;
    //     // set viewController
    // 
    //     [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    //     [networkAwareViewController setCachedDataAvailable:!!userInfo];
    // } else {
    //     // This is a bit of a hack, but a relatively simple solution:
    //     // Configure the network-aware controller to 'disconnected' and set the
    //     // disconnected text accordingly
    //     [networkAwareViewController
    //         setNoConnectionText:@"Please Log In to View Personal Info"];
    //     [networkAwareViewController setUpdatingState:kDisconnected];
    //     [networkAwareViewController setCachedDataAvailable:NO];
    // }
}

@end
