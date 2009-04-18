//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewsFeedDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "GitHubNewsFeedService.h"
#import "GitHubNewsFeedServiceFactory.h"
#import "GitHubService.h"
#import "GitHubServiceFactory.h"
#import "GravatarService.h"
#import "GravatarServiceFactory.h"
#import "RssItem.h"
#import "RssItem+ParsingHelpers.h"
#import "RepoKey.h"
#import "NewsFeedViewController.h"
#import "NewsFeedItemViewController.h"
#import "NewsFeedItemDetailsViewController.h"
#import "NSString+RegexKitLiteHelpers.h"
#import "UIAlertView+CreationHelpers.h"

@interface NewsFeedDisplayMgr (Private)

- (void)updateDisplay:(NSArray *)cachedRssItems;

- (UIImage *)cachedAvatarForUsername:(NSString *)username;
- (NSDictionary *)cachedAvatarsForRssItems:(NSArray *)rssItems;

- (NSSet *)userEmailAddressesFromRssItems:(NSArray *)rssItems;

- (UserInfo *)cachedUserInfoForUsername:(NSString *)username;

//- (NSArray *)cachedNewsFeedForUsername:(NSString *)user;

- (NSString *)usernameForEmailAddress:(NSString *)emailAddress;
- (void)username:(NSString *)username
    mapsToEmailAddress:(NSString *)emailAddress;

- (void)fetchUserInfoForUnknownUsersInRssItems:(NSArray *)rssItems;

- (BOOL)isPrimaryUser:(NSString *)username;

- (NetworkAwareViewController *)networkAwareViewController;
- (NewsFeedViewController *)newsFeedViewController;
- (NewsFeedItemViewController *)newsFeedItemViewController;
- (NewsFeedItemDetailsViewController *)newsFeedItemDetailsViewController;
- (void)setSelectedRssItem:(RssItem *)rssItem;

@end

@implementation NewsFeedDisplayMgr

@synthesize delegate, username;

- (void)dealloc
{
    [userDisplayMgr release];
    [repoSelector release];

    [navigationController release];    

    [networkAwareViewController release];
    [newsFeedViewController release];
    [newsFeedItemViewController release];
    [newsFeedItemDetailsViewController release];

    [newsFeedCacheReader release];
    [logInStateReader release];
    [userCacheReader release];
    [avatarCacheReader release];

    [newsFeedService release];
    [gitHubService release];
    [gravatarService release];

    [delegate release];

    [username release];

    [usernames release];

    [selectedRssItem release];
    
    [super dealloc];
}

#pragma mark Initialization

- (id)initWithNavigationController:(UINavigationController *)nc
        networkAwareViewController:(NetworkAwareViewController *)navc
            newsFeedViewController:(NewsFeedViewController *)nfvc
                    userDisplayMgr:(NSObject<UserDisplayMgr> *)aUserDisplayMgr
                      repoSelector:(NSObject<RepoSelector> *)aRepoSelector
                  logInStateReader:(NSObject<LogInStateReader> *)lisReader
               newsFeedCacheReader:(NSObject<NewsFeedCacheReader> *)nfCache
                   userCacheReader:(NSObject<UserCacheReader> *)uCache
                 avatarCacheReader:(NSObject<AvatarCacheReader> *)avCache
                   newsFeedService:(GitHubNewsFeedService *)aNewsFeedService
                     gitHubService:(GitHubService *)aGitHubService
                   gravatarService:(GravatarService *)aGravatarService
{
    if (self = [super init]) {
        navigationController = [nc retain];

        networkAwareViewController = [navc retain];
        networkAwareViewController.delegate = self;

        newsFeedViewController = [nfvc retain];
        newsFeedViewController.delegate = self;

        userDisplayMgr = [aUserDisplayMgr retain];
        repoSelector = [aRepoSelector retain];

        logInStateReader = [lisReader retain];
        newsFeedCacheReader = [nfCache retain];
        userCacheReader = [uCache retain];
        avatarCacheReader = [avCache retain];

        newsFeedService = [aNewsFeedService retain];
        newsFeedService.delegate = self;

        gitHubService = [aGitHubService retain];
        gitHubService.delegate = self;

        gravatarService = [aGravatarService retain];
        gravatarService.delegate = self;

        usernames = [[NSMutableDictionary alloc] init];

        UIBarButtonItem * refreshButton =
            [[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
            target:self
            action:@selector(requestRefreshDisplay)] autorelease];

        [[self networkAwareViewController].navigationItem
            setRightBarButtonItem:refreshButton animated:NO];

        waitingForNewsFeedRefresh = NO;
    }

    return self;
}

- (void)viewWillAppear
{
    [self setSelectedRssItem:nil];
}

- (void)requestRefreshDisplay
{
    waitingForNewsFeedRefresh = NO;
    [delegate userDidRequestRefresh];
}

#pragma mark Display the news feed

- (void)updateNewsFeed
{
    gitHubFailure = NO;
    avatarFailure = NO;
    
    if (logInStateReader.login) {
        self.username = logInStateReader.login;

        [[self networkAwareViewController]
            setNoConnectionText:
            NSLocalizedString(@"nodata.noconnection.text", @"")];

        if (!waitingForNewsFeedRefresh) {
            [newsFeedService fetchNewsFeedForPrimaryUser];
            waitingForNewsFeedRefresh = YES;

            [[self networkAwareViewController]
                setUpdatingState:kConnectedAndUpdating];    
        }

        NSArray * cachedRssItems = [newsFeedCacheReader primaryUserNewsFeed];
        [self updateDisplay:cachedRssItems];
    } else {
        // This is a bit of a hack, but a relatively simple solution:
        // Configure the network-aware controller to 'disconnected' and set the
        // disconnected text accordingly
        [[self networkAwareViewController]
            setNoConnectionText:
            NSLocalizedString(@"newsfeeddisplaymgr.login.text", @"")];
        [[self networkAwareViewController] setUpdatingState:kDisconnected];
        [[self networkAwareViewController] setCachedDataAvailable:NO];
    }
}

- (void)updateActivityFeedForPrimaryUser
{
    [self updateActivityFeedForUsername:logInStateReader.login];
}

- (void)updateActivityFeedForUsername:(NSString *)user
{
    self.username = user;

    if (!waitingForNewsFeedRefresh) {
        [newsFeedService fetchActivityFeedForUsername:user];
        waitingForNewsFeedRefresh = YES;

        [[self networkAwareViewController]
            setUpdatingState:kConnectedAndUpdating];
    }

    NSArray * cachedRssItems =
        [newsFeedCacheReader activityFeedForUsername:user];
    [self updateDisplay:cachedRssItems];

    [self networkAwareViewController].navigationItem.title =
        NSLocalizedString(@"newsfeeddisplaymgr.view.title", @"");
    [navigationController
         pushViewController:[self networkAwareViewController] animated:YES];
}

- (void)updateDisplay:(NSArray *)cachedRssItems
{
    [[self networkAwareViewController]
        setNoConnectionText:
        NSLocalizedString(@"nodata.noconnection.text", @"")];

    if (cachedRssItems && cachedRssItems.count > 0) {
        NSDictionary * avatars = [self cachedAvatarsForRssItems:cachedRssItems];
        [[self newsFeedViewController] updateRssItems:cachedRssItems];
        [[self newsFeedViewController] updateAvatars:avatars];

        [self fetchUserInfoForUnknownUsersInRssItems:cachedRssItems];

        [[self networkAwareViewController] setCachedDataAvailable:YES];
    } else
        [[self networkAwareViewController] setCachedDataAvailable:NO];
}

#pragma mark NewsFeedViewControllerDelegate implementation

- (void)userDidSelectRssItem:(RssItem *)rssItem
{
    [self setSelectedRssItem:rssItem];

    [[self newsFeedItemViewController] updateWithRssItem:rssItem];
    UIImage * avatar = [self cachedAvatarForUsername:rssItem.author];
    [[self newsFeedItemViewController] updateWithAvatar:avatar];

    [newsFeedItemViewController scrollToTop];

    [navigationController
        pushViewController:[self newsFeedItemViewController]
        animated:YES];
}

#pragma mark NewsFeedItemViewControllerDelegate implementation

- (void)userDidSelectDetails:(RssItem *)item
{
    [[self newsFeedItemDetailsViewController] updateWithDetails:item.summary];
    [navigationController
        pushViewController:[self newsFeedItemDetailsViewController]
                  animated:YES];
}

- (void)userDidSelectRepo:(NSString *)repo ownedByUser:(NSString *)user
{
    [repoSelector user:user didSelectRepo:repo];
}

- (void)userDidSelectUsername:(NSString *)user
{
    [userDisplayMgr displayUserInfoForUsername:user];
}

#pragma mark GitHubNewsFeedDelegate implementation

- (void)newsFeed:(NSArray *)newsItems
    fetchedForUsername:(NSString *)user
{
    [self activityFeed:newsItems fetchedForUsername:user];
}

- (void)failedToFetchNewsFeedForUsername:(NSString *)user
                                   error:(NSError *)error
{
    [self failedToFetchActivityFeedForUsername:user error:error];
}

- (void)activityFeed:(NSArray *)newsItems
    fetchedForUsername:(NSString *)username
{
    // display any available cached avatars
    NSDictionary * avatars = [self cachedAvatarsForRssItems:newsItems];

    [[self newsFeedViewController] updateRssItems:newsItems];
    [[self newsFeedViewController] updateAvatars:avatars];

    // fetch fresh avatars
    NSSet * emailAddresses = [self userEmailAddressesFromRssItems:newsItems];
    for (NSString * emailAddress in emailAddresses)
        [gravatarService fetchAvatarForEmailAddress:emailAddress];

    [self fetchUserInfoForUnknownUsersInRssItems:newsItems];

    // update the network aware view controller
    [[self networkAwareViewController]
        setUpdatingState:kConnectedAndNotUpdating];
    [[self networkAwareViewController] setCachedDataAvailable:YES];

    waitingForNewsFeedRefresh = NO;
}

- (void)failedToFetchActivityFeedForUsername:(NSString *)user
                                       error:(NSError *)error
{
    NSLog(@"Failed to retrieve news feed for username: '%@' error: '%@'.", user,
        error);

    if (!gitHubFailure) {
        gitHubFailure = YES;
        NSString * title =
            NSLocalizedString(@"github.newsfeedupdate.failed.alert.title", @"");
        UIAlertView * alertView =
            [UIAlertView simpleAlertViewWithTitle:title
                                          message:error.localizedDescription];

        [alertView show];

        [[self networkAwareViewController] setUpdatingState:kDisconnected];
    }

    waitingForNewsFeedRefresh = NO;
}

#pragma mark GravatarServiceDelegate implementation

- (void)avatar:(UIImage *)avatar fetchedForEmailAddress:(NSString *)emailAddress
{
    NSLog(@"Avatar received: '%@' => %@", emailAddress, avatar);

    NSString * user = [self usernameForEmailAddress:emailAddress];

    [[self newsFeedViewController] updateAvatar:avatar forUsername:user];
    if ([selectedRssItem.author isEqualToString:user])
        [[self newsFeedItemViewController] updateWithAvatar:avatar];
}

- (void)failedToFetchAvatarForEmailAddress:(NSString *)emailAddress
                                     error:(NSError *)error
{
    if (!avatarFailure) {
        avatarFailure = YES;
        NSLog(@"Failed to retrieve avatar for email address: '%@' error: '%@'.",
            emailAddress, error);

        NSString * title =
            NSLocalizedString(@"github.newsfeedupdate.failed.alert.title", @"");
        UIAlertView * alertView =
            [UIAlertView simpleAlertViewWithTitle:title
                                          message:error.localizedDescription];

        [alertView show];
    }
}

#pragma mark GitHubServiceDelegate implementation

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)user
{
    NSString * email = [info.details objectForKey:@"email"];
    if (email) {
        // fetch avatar for new user
        [gravatarService fetchAvatarForEmailAddress:email];

        // remember this association
        [self username:user mapsToEmailAddress:email];
    }
}

- (void)failedToFetchInfoForUsername:(NSString *)user
                               error:(NSError *)error
{
    NSLog(@"Failed to fetch info for user: '%@' error: '%@'.", user, error);

    if (!gitHubFailure) {
        gitHubFailure = YES;

        NSString * title =
            NSLocalizedString(@"github.userupdate.failed.alert.title", @"");
        UIAlertView * alertView =
            [UIAlertView simpleAlertViewWithTitle:title
                                          message:error.localizedDescription];

        [alertView show];

        [[self networkAwareViewController] setUpdatingState:kDisconnected];
    }
}

#pragma mark Working with avatars

- (UIImage *)cachedAvatarForUsername:(NSString *)user
{
    UserInfo * ui = [self cachedUserInfoForUsername:user];
    NSString * email = [ui.details objectForKey:@"email"];

    if (email) {
        [self username:user mapsToEmailAddress:email];
        return [avatarCacheReader avatarForEmailAddress:email];
    }

    return nil;
}

- (NSDictionary *)cachedAvatarsForRssItems:(NSArray *)rssItems
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    for (RssItem * item in rssItems) {
        if ([dict objectForKey:item.author] == nil) {
            UIImage * avatar = [self cachedAvatarForUsername:item.author];
            if (avatar)
                [dict setObject:avatar forKey:item.author];
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
            [self username:item.author mapsToEmailAddress:email];
        }
    }

    return emails;
}

#pragma mark Working with users

- (UserInfo *)cachedUserInfoForUsername:(NSString *)user
{
    return [self isPrimaryUser:user] ?
        userCacheReader.primaryUser :
        [userCacheReader userWithUsername:user];
}

- (NSString *)usernameForEmailAddress:(NSString *)emailAddress
{
    return [usernames objectForKey:emailAddress];
}

- (void)username:(NSString *)user mapsToEmailAddress:(NSString *)email
{
    [usernames setObject:user forKey:email];
}

- (void)fetchUserInfoForUnknownUsersInRssItems:(NSArray *)rssItems
{
    NSMutableSet * users = [NSMutableSet setWithCapacity:rssItems.count];

    for (RssItem * item in rssItems)
        if ([self cachedUserInfoForUsername:item.author] == nil)
            [users addObject:item.author];

    for (NSString * user in users) {
        NSLog(@"Fetching info for username: '%@'.", user);
        [gitHubService fetchInfoForUsername:user];
    }
}

#pragma mark Working with cached RSS items

- (NSArray *)cachedNewsFeedForUsername:(NSString *)user
{
    return [self isPrimaryUser:user] ?
        [newsFeedCacheReader primaryUserNewsFeed] :
        [newsFeedCacheReader activityFeedForUsername:user];
}

#pragma mark General helpers

- (BOOL)isPrimaryUser:(NSString *)user
{
    return [logInStateReader.login isEqualToString:user];
}

#pragma mark Accessors

- (NetworkAwareViewController *)networkAwareViewController
{
    if (!networkAwareViewController) {
        networkAwareViewController =
            [[NetworkAwareViewController alloc]
            initWithTargetViewController:[self newsFeedViewController]];
        networkAwareViewController.delegate = self;
    }

    return networkAwareViewController;
}

- (NewsFeedViewController *)newsFeedViewController
{
    if (!newsFeedViewController) {
        newsFeedViewController =
            [[NewsFeedViewController alloc]
            initWithNibName:@"NewsFeedView" bundle:nil];
        newsFeedViewController.delegate = self;
    }

    return newsFeedViewController;
}

- (NewsFeedItemViewController *)newsFeedItemViewController
{
    if (!newsFeedItemViewController) {
        newsFeedItemViewController =
            [[NewsFeedItemViewController alloc]
            initWithNibName:@"NewsFeedItemView" bundle:nil];
        newsFeedItemViewController.delegate = self;
        newsFeedItemViewController.repoSelector = repoSelector;
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

- (void)setSelectedRssItem:(RssItem *)rssItem
{
    RssItem * tmp = [rssItem copy];
    [selectedRssItem release];
    selectedRssItem = tmp;
}

@end
