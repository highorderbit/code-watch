//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewsFeedDisplayMgr.h"
#import "GitHubNewsFeedService.h"
#import "GitHubNewsFeedServiceFactory.h"
#import "GravatarService.h"
#import "GravatarServiceFactory.h"
#import "RssItem.h"
#import "RssItem+ParsingHelpers.h"
#import "RepoKey.h"
#import "RepoSelectorFactory.h"
#import "UserDisplayMgrFactory.h"
#import "NewsFeedItemViewController.h"
#import "NewsFeedItemDetailsViewController.h"
#import "NSString+RegexKitLiteHelpers.h"
#import "UIAlertView+CreationHelpers.h"

@interface NewsFeedDisplayMgr (Private)

- (NSDictionary *)cachedAvatarsFromRssItems:(NSArray *)rssItems;

- (NSSet *)userEmailAddressesFromRssItems:(NSArray *)rssItems;

- (UserInfo *)cachedUserInfoForUsername:(NSString *)username;
- (NSString *)usernameForEmailAddress:(NSString *)emailAddress;

- (BOOL)isPrimaryUser:(NSString *)username;

- (NSObject<UserDisplayMgr> *)userDisplayMgr;
- (NSObject<RepoSelector> *)repoSelector;
- (NewsFeedItemViewController *)newsFeedItemViewController;
- (NewsFeedItemDetailsViewController *)newsFeedItemDetailsViewController;

@end

@implementation NewsFeedDisplayMgr

- (void)dealloc
{
    [userDisplayMgrFactory release];
    [userDisplayMgr release];

    [repoSelectorFactory release];
    [repoSelector release];

    [navigationController release];    
    [networkAwareViewController release];
    [newsFeedTableViewController release];

    [newsFeedItemViewController release];
    [newsFeedItemDetailsViewController release];
    
    [newsFeedCacheReader release];
    [logInState release];
    [userCacheReader release];
    [avatarCacheReader release];

    [newsFeed release];

    [gravatarServiceFactory release];
    [gravatarService release];

    [usernames release];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    newsFeed = [[newsFeedServiceFactory createGitHubNewsFeedService] retain];
    newsFeed.delegate = self;

    gravatarService = [[gravatarServiceFactory createGravatarService] retain];
    gravatarService.delegate = self;

    usernames = [[NSMutableDictionary alloc] init];
    
    UIBarButtonItem * refreshButton =
        [[[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
        target:self
        action:@selector(updateNewsFeed)] autorelease];

    [networkAwareViewController.navigationItem
        setRightBarButtonItem:refreshButton animated:NO];
}

- (void)viewWillAppear
{
    [self updateNewsFeed];
}

- (void)updateNewsFeed
{
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
    
    if (logInState.login) {
        [networkAwareViewController
        setNoConnectionText:
        NSLocalizedString(@"nodata.noconnection.text", @"")];
        
        NSArray * rssItems = [newsFeedCacheReader primaryUserNewsFeed];
        NSDictionary * avatars = [self cachedAvatarsFromRssItems:rssItems];
        [newsFeedTableViewController updateRssItems:rssItems];
        [newsFeedTableViewController updateAvatars:avatars];

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
        RepoKey * repoKey = [rssItem repoKey];

        if (repoKey)
            [[self repoSelector]
                user:repoKey.username didSelectRepo:repoKey.repoName];
        else {
            NSLog(@"Failed to parse RSS item: '%@'.", rssItem);
            NSString * title =
                NSLocalizedString(@"newsfeed.item.display.failed.title", @"");
            NSString * message =
                NSLocalizedString(@"newsfeed.item.parse.failed.message", @"");

            UIAlertView * alertView =
                [UIAlertView simpleAlertViewWithTitle:title
                                              message:message];
            [alertView show];

            [newsFeedTableViewController viewWillAppear:NO];
        }
    } else {
        [[self newsFeedItemViewController] updateWithRssItem:rssItem];
        [navigationController
            pushViewController:[self newsFeedItemViewController] animated:YES];
    }
}

#pragma mark NewsFeedItemViewControllerDelegate implementation

- (void)userDidSelectDetails:(RssItem *)item
{
    [[self newsFeedItemDetailsViewController] updateWithDetails:item.summary];
    [navigationController
        pushViewController:[self newsFeedItemDetailsViewController]
                  animated:YES];
}

- (void)userDidSelectRepo:(NSString *)repoName ownedByUser:(NSString *)username
{
    [[self repoSelector] user:username didSelectRepo:repoName];
}

- (void)userDidSelectUsername:(NSString *)username
{
    [[self userDisplayMgr] displayUserInfoForUsername:username];
}

#pragma mark GitHubNewsFeedDelegate implementation

- (void)newsFeed:(NSArray *)newsItems fetchedForUsername:(NSString *)username
{
    // display any available cached avatars
    NSDictionary * avatars = [self cachedAvatarsFromRssItems:newsItems];

    [newsFeedTableViewController updateRssItems:newsItems];
    [newsFeedTableViewController updateAvatars:avatars];

    // fetch fresh avatars
    NSSet * emailAddresses = [self userEmailAddressesFromRssItems:newsItems];
    for (NSString * emailAddress in emailAddresses)
        [gravatarService fetchAvatarForEmailAddress:emailAddress];

    // update the network aware view controller
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
                                      message:error.localizedDescription];

    [alertView show];

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

#pragma mark GravatarServiceDelegate implementation

- (void)avatar:(UIImage *)avatar fetchedForEmailAddress:(NSString *)emailAddress
{
    NSLog(@"Avatar received: '%@' => %@", emailAddress, avatar);

    NSString * username = [self usernameForEmailAddress:emailAddress];

    [newsFeedTableViewController updateAvatar:avatar forUsername:username];
}

- (void)failedToFetchAvatarForEmailAddress:(NSString *)emailAddress
                                     error:(NSError *)error
{
    NSLog(@"Failed to retrieve avatar for email address: '%@' error: '%@'.",
        emailAddress, error);

    NSString * title =
        NSLocalizedString(@"github.newsfeedupdate.failed.alert.title", @"");
    UIAlertView * alertView =
        [UIAlertView simpleAlertViewWithTitle:title
                                      message:error.localizedDescription];

    [alertView show];
}

#pragma mark Working with avatars

- (NSDictionary *)cachedAvatarsFromRssItems:(NSArray *)rssItems
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    for (RssItem * item in rssItems) {
        if ([dict objectForKey:item.author] == nil) {
            UserInfo * ui = [self cachedUserInfoForUsername:item.author];

            NSString * email = [ui.details objectForKey:@"email"];
            if (email) {
                [usernames setObject:item.author forKey:email];

                UIImage * avatar =
                    [avatarCacheReader avatarForEmailAddress:email];
                if (avatar)
                    [dict setObject:avatar forKey:item.author];
            }
        }
    }

    return dict;
}

- (NSSet *)userEmailAddressesFromRssItems:(NSArray *)rssItems
{
    NSMutableSet * emails = [NSMutableSet setWithCapacity:rssItems.count];

    for (RssItem * item in rssItems) {
        UserInfo * ui = [self cachedUserInfoForUsername:item.author];

        NSString * email = [ui.details objectForKey:@"email"];
        if (email) {
            [emails addObject:email];
            [usernames setObject:item.author forKey:email];
        }
    }

    return emails;
}

#pragma mark Working with users

- (UserInfo *)cachedUserInfoForUsername:(NSString *)username
{
    return [self isPrimaryUser:username] ?
        userCacheReader.primaryUser :
        [userCacheReader userWithUsername:username];
}

- (NSString *)usernameForEmailAddress:(NSString *)emailAddress
{
    return [usernames objectForKey:emailAddress];
}

#pragma mark General helpers

- (BOOL)isPrimaryUser:(NSString *)username
{
    return [logInState.login isEqualToString:username];
}

#pragma mark Accessors

- (NSObject<UserDisplayMgr> *)userDisplayMgr
{
    if (!userDisplayMgr)
        userDisplayMgr =
            [userDisplayMgrFactory
            createUserDisplayMgrWithNavigationContoller:navigationController];

    return userDisplayMgr;
}

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
        newsFeedItemViewController.delegate = self;
        newsFeedItemViewController.repoSelectorFactory = repoSelectorFactory;
    }

    return newsFeedItemViewController;
}

- (NewsFeedItemDetailsViewController *)newsFeedItemDetailsViewController
{
    if (!newsFeedItemDetailsViewController)
        newsFeedItemDetailsViewController =
            [[NewsFeedItemDetailsViewController alloc]
            initWithNibName:@"NewsFeedItemDetailsView" bundle:nil];

    return newsFeedItemDetailsViewController;
}

@end
