//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UIUserDisplayMgr.h"
#import "GitHubService.h"
#import "GravatarService.h"

@implementation UIUserDisplayMgr

- (void)dealloc
{
    [navigationController release];
    [networkAwareViewController release];
    [userViewController release];

    [userCacheReader release];
    [avatarCacheReader release];
    [repoSelector release];
    [avatarCacheReader release];
    [gitHubService release];
    [gravatarService release];
    [contactCacheSetter release];

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
{
    if (self = [super init]) {
        navigationController = [aNavigationController retain];
        networkAwareViewController = [aNetworkAwareViewController retain];
        userViewController = [aUserViewController retain];
        userCacheReader = [aUserCacheReader retain];
        avatarCacheReader = [anAvatarCacheReader retain];
        repoSelector = [aRepoSelector retain];
        gitHubService = [aGitHubService retain];
        gravatarService = [aGravatarService retain];
        contactCacheSetter = [aContactCacheSetter retain];
        
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

- (void)viewWillAppear
{
    [self displayUserInfo];
}

- (void)displayUserInfo
{
    [gitHubService fetchInfoForUsername:username];

    UserInfo * userInfo = [userCacheReader userWithUsername:username];
    NSString * email = [userInfo.details objectForKey:@"email"];
    if (email) {
        UIImage * avatar = [avatarCacheReader avatarForEmailAddress:email];
        [userViewController updateWithAvatar:avatar];
    }

    [userViewController setUsername:username];
    [userViewController updateWithUserInfo:userInfo];

    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    [networkAwareViewController setCachedDataAvailable:!!userInfo];
}

#pragma mark UserViewControllerDelegate implementation

- (void)userDidSelectRepo:(NSString *)repo
{
    [repoSelector user:username didSelectRepo:repo];
}

#pragma mark GitHubServiceDelegate implementation

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username
{
    [userViewController updateWithUserInfo:info];

    NSString * email = [info.details objectForKey:@"email"];
    if (email)
        [gravatarService fetchAvatarForEmailAddress:email];
    else
        [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];

    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    [networkAwareViewController setUpdatingState:kDisconnected];
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
    [networkAwareViewController setUpdatingState:kDisconnected];
}

#pragma mark UserDisplayMgr implementation

- (void)displayUserInfoForUsername:(NSString *)aUsername
{
    aUsername = [aUsername copy];
    [username release];
    username = aUsername;
    
    [navigationController
        pushViewController:networkAwareViewController animated:YES];
    networkAwareViewController.navigationItem.title =
        NSLocalizedString(@"user.view.title", @"");
}

@end
