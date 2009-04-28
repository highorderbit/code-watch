//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UIUserDisplayMgr.h"
#import "GitHubService.h"
#import "GravatarService.h"
#import "NewsFeedDisplayMgr.h"
#import "NewsFeedDisplayMgrFactory.h"
#import "GitHubServiceFactory.h"
#import "FollowersDisplayMgr.h"
#import "FollowingDisplayMgr.h"
#import "UserDisplayMgrFactory.h"

@interface UIUserDisplayMgr (Private)

- (NewsFeedDisplayMgr *)newsFeedDisplayMgr;
- (FollowersDisplayMgr *)followersDisplayMgr;
- (FollowingDisplayMgr *)followingDisplayMgr;
- (void)setRepoAccessRights:(UserInfo*)userInfo;

@end

@implementation UIUserDisplayMgr

- (void)dealloc
{
    [navigationController release];
    [networkAwareViewController release];
    [userViewController release];

    [userCacheReader release];
    [repoCacheReader release];
    [avatarCacheReader release];
    [repoSelector release];
    [avatarCacheReader release];
    [gitHubService release];
    [gravatarService release];
    [contactCacheSetter release];
    [newsFeedDisplayMgrFactory release];
    [newsFeedDisplayMgr release];
    [gitHubServiceFactory release];
    [userDisplayMgrFactory release];
    [followersDisplayMgr release];
    [followingDisplayMgr release];

    [username release];
    
    [super dealloc];
}

- (id)initWithNavigationController:
    (UINavigationController *)aNavigationController
    networkAwareViewController:
    (NetworkAwareViewController *)aNetworkAwareViewController
    userViewController:
    (UserViewController *)aUserViewController
    userCacheReader:
    (NSObject<UserCacheReader> *)aUserCacheReader
    repoCacheReader:
    (NSObject<RepoCacheReader> *)aRepoCacheReader
    avatarCacheReader:
    (NSObject<AvatarCacheReader> *)anAvatarCacheReader
    repoSelector:
    (NSObject<RepoSelector> *)aRepoSelector
    gitHubService:
    (GitHubService *)aGitHubService
    gravatarService:
    (GravatarService *)aGravatarService
    contactCacheSetter:
    (NSObject<ContactCacheSetter> *)aContactCacheSetter
    newsFeedDisplayMgrFactory:
    (NewsFeedDisplayMgrFactory *)aNewsFeedDisplayMgrFactory
    gitHubServiceFactory:
    (GitHubServiceFactory *)aGitHubServiceFactory
    userDisplayMgrFactory:
    (UserDisplayMgrFactory *)aUserDisplayMgrFactory
{
    if (self = [super init]) {
        navigationController = [aNavigationController retain];
        networkAwareViewController = [aNetworkAwareViewController retain];
        userViewController = [aUserViewController retain];
        userCacheReader = [aUserCacheReader retain];
        repoCacheReader = [aRepoCacheReader retain];
        avatarCacheReader = [anAvatarCacheReader retain];
        repoSelector = [aRepoSelector retain];
        gitHubService = [aGitHubService retain];
        gravatarService = [aGravatarService retain];
        contactCacheSetter = [aContactCacheSetter retain];
        newsFeedDisplayMgrFactory = [aNewsFeedDisplayMgrFactory retain];
        gitHubServiceFactory = [aGitHubServiceFactory retain];
        userDisplayMgrFactory = [aUserDisplayMgrFactory retain];
        
        [networkAwareViewController
            setNoConnectionText:
            NSLocalizedString(@"nodata.noconnection.text", @"")];
            
        UIBarButtonItem * refreshButton =
            [[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
            target:self
            action:@selector(displayUserInfo)] autorelease];

        [networkAwareViewController.navigationItem
            setRightBarButtonItem:refreshButton animated:NO];
    }
    
    return self;
}

- (void)displayUserInfo
{
    gitHubFailure = NO;
    avatarFailure = NO;
    
    [gitHubService fetchInfoForUsername:username];

    UserInfo * userInfo = [userCacheReader userWithUsername:username];
    NSString * email = [userInfo.details objectForKey:@"email"];
    if (email) {
        UIImage * avatar = [avatarCacheReader avatarForEmailAddress:email];
        [userViewController updateWithAvatar:avatar];
    } else
        [userViewController updateWithAvatar:nil];

    [userViewController setUsername:username];
    [userViewController updateWithUserInfo:userInfo];

    if (userInfo)
        [self setRepoAccessRights:userInfo];

    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    [networkAwareViewController setCachedDataAvailable:!!userInfo];
}

- (void)setRepoAccessRights:(UserInfo*)userInfo
{
    for (NSString * repoName in userInfo.repoKeys) {
        RepoInfo * repoInfo =
            [repoCacheReader primaryUserRepoWithName:repoName];
        if (repoInfo)
            [userViewController
                setAccess:[[repoInfo.details objectForKey:@"private"] boolValue]
                forRepoName:repoName];
        else
            [gitHubService fetchInfoForRepo:repoName username:username];
    }
}

#pragma mark UserViewControllerDelegate implementation

- (void)userDidSelectRepo:(NSString *)repo
{
    [repoSelector user:username didSelectRepo:repo];
}

- (void)userDidSelectRecentActivity
{
    [[self newsFeedDisplayMgr] updateActivityFeedForUsername:username];
}

- (void)userDidSelectFollowing
{
    [[self followingDisplayMgr] displayFollowingForUsername:username];
}

- (void)userDidSelectFollowers
{
    [[self followersDisplayMgr] displayFollowersForUsername:username];
}

#pragma mark GitHubServiceDelegate implementation

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)user
{
    if (![username isEqualToString:user])
        return;  // this is not the update we're waiting for

    BOOL cachedDataWasAvailable =
        networkAwareViewController.cachedDataAvailable;

    for (NSString * repoName in [repos allKeys]) {
        RepoInfo * repoInfo = [repos objectForKey:repoName];
        BOOL private = [[repoInfo.details objectForKey:@"private"] boolValue];
        [userViewController setAccess:private forRepoName:repoName];
    }

    [userViewController updateWithUserInfo:info];

    NSString * email = [info.details objectForKey:@"email"];
    if (email)
        [gravatarService fetchAvatarForEmailAddress:email];
    else
        [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];

    [networkAwareViewController setCachedDataAvailable:YES];

    if (!cachedDataWasAvailable)
        [userViewController scrollToTop];
}

- (void)failedToFetchInfoForUsername:(NSString *)user
                               error:(NSError *)error
{
    NSLog(@"Failed to retrieve info for user: '%@' error: '%@'.", user, error);

    if (![username isEqualToString:user])
        return;  // this is not the update we're waiting for

    if (!gitHubFailure) {
        gitHubFailure = YES;

        NSString * title =
            NSLocalizedString(@"github.userupdate.failed.alert.title", @"");
        NSString * cancelTitle =
            NSLocalizedString(@"github.userupdate.failed.alert.ok", @"");
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

        [networkAwareViewController setUpdatingState:kDisconnected];
    }
}

#pragma mark GravatarServiceDelegate implementation

- (void)avatar:(UIImage *)avatar fetchedForEmailAddress:(NSString *)emailAddress
{
    [userViewController updateWithAvatar:avatar];
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

- (void)failedToFetchAvatarForEmailAddress:(NSString *)emailAddress
    error:(NSError *)error
{
    if (!avatarFailure) {
        avatarFailure = YES;
        
        NSLog(@"Failed to retrieve avatar for email address: '%@' error: '%@'.",
            emailAddress, error);

        NSString * title =
            NSLocalizedString(@"gravatar.userupdate.failed.alert.title", @"");
        NSString * cancelTitle =
            NSLocalizedString(@"gravatar.userupdate.failed.alert.ok", @"");
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
    }
}

#pragma mark UserDisplayMgr implementation

- (void)displayUserInfoForUsername:(NSString *)aUsername
{
    BOOL needsToScrollToTop = ![username isEqualToString:aUsername];

    aUsername = [aUsername copy];
    [username release];
    username = aUsername;

    [self displayUserInfo];

    networkAwareViewController.navigationItem.title =
        NSLocalizedString(@"user.view.title", @"");

    [navigationController
        pushViewController:networkAwareViewController animated:YES];

    if (needsToScrollToTop)
        [userViewController scrollToTop];
}

#pragma mark NewsFeedDisplayMgrDelegate

- (void)userDidRequestRefresh
{
    [[self newsFeedDisplayMgr] updateActivityFeedForUsername:username];
}

#pragma mark Accessors

- (NewsFeedDisplayMgr *)newsFeedDisplayMgr
{
    if (!newsFeedDisplayMgr) {
        newsFeedDisplayMgr =
            [newsFeedDisplayMgrFactory
            createNewsFeedDisplayMgr:navigationController];
        newsFeedDisplayMgr.delegate = self;
    }

    return newsFeedDisplayMgr;
}

- (FollowersDisplayMgr *)followersDisplayMgr
{
    if (!followersDisplayMgr) {
        GitHubService * ghs = [gitHubServiceFactory createGitHubService];
        NSObject<UserDisplayMgr> * udm =
            [userDisplayMgrFactory
            createUserDisplayMgrWithNavigationContoller:navigationController];

        followersDisplayMgr =
            [[FollowersDisplayMgr alloc]
            initWithNavigationController:navigationController
            gitHubService:ghs userDisplayMgr:udm];
    }

    return followersDisplayMgr;
}

- (FollowingDisplayMgr *)followingDisplayMgr
{
    if (!followingDisplayMgr) {
        GitHubService * ghs = [gitHubServiceFactory createGitHubService];
        NSObject<UserDisplayMgr> * udm =
            [userDisplayMgrFactory
            createUserDisplayMgrWithNavigationContoller:navigationController];

        followingDisplayMgr =
            [[FollowingDisplayMgr alloc]
            initWithNavigationController:navigationController
            gitHubService:ghs userDisplayMgr:udm];
    }

    return followingDisplayMgr;
}

@end
