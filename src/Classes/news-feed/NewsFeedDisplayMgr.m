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
    NSString * cancelTitle =
        NSLocalizedString(@"github.newsfeedupdate..failed.alert.ok", @"");
    NSString * message = error.localizedDescription;

    UIAlertView * alertView =
        [[[UIAlertView alloc]
          initWithTitle:title
                message:message
               delegate:self
      cancelButtonTitle:cancelTitle
      otherButtonTitles:nil]
         autorelease];

    [alertView show];

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

@end
