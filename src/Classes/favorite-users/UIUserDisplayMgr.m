//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UIUserDisplayMgr.h"

@implementation UIUserDisplayMgr

- (void)dealloc
{
    [navigationController release];
    [networkAwareViewController release];
    [userViewController release];

    [userCacheReader release];
    [repoSelector release];
    [gitHubService release];

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
    repoSelector:
    (NSObject<RepoSelector> *)aRepoSelector
    gitHubService:
    (GitHubService *)aGitHubService
{
    if (self = [super init]) {
        navigationController = aNavigationController;
        networkAwareViewController = aNetworkAwareViewController;
        userViewController = aUserViewController;
        userCacheReader = aUserCacheReader;
        repoSelector = aRepoSelector;
        gitHubService = aGitHubService;
        
        [networkAwareViewController
            setNoConnectionText:
            NSLocalizedString(@"nodata.noconnection.text", @"")];
    }
    
    return self;
}

- (void)viewWillAppear
{
    [self displayUserInfoForUsername:username];
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

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    [networkAwareViewController setUpdatingState:kDisconnected];
}

#pragma mark UserDisplayMgr implementation

- (void)displayUserInfoForUsername:(NSString *)aUsername
{
    aUsername = [aUsername copy];
    [username release];
    username = aUsername;
    
    [gitHubService fetchInfoForUsername:username];

    UserInfo * userInfo = [userCacheReader userWithUsername:username];
    [userViewController setUsername:username];
    [userViewController updateWithUserInfo:userInfo];

    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    [networkAwareViewController setCachedDataAvailable:!!userInfo];
    
    [navigationController
        pushViewController:networkAwareViewController animated:YES];
    networkAwareViewController.navigationItem.title =
        NSLocalizedString(@"user.view.title", @"");
}

@end
