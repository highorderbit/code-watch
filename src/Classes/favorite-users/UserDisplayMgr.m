//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserDisplayMgr.h"

@implementation UserDisplayMgr

@synthesize username;

- (void)dealloc
{
    [networkAwareViewController release];
    [userViewController release];

    [userCacheReader release];
    [repoSelector release];
    [gitHubService release];
    
    [username release];
    
    [super dealloc];
}

- (id)initWithNetworkAwareViewController:
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
        networkAwareViewController = aNetworkAwareViewController;
        userViewController = aUserViewController;
        userCacheReader = aUserCacheReader;
        repoSelector = aRepoSelector;
        gitHubService = aGitHubService;
    }
    
    return self;
}

- (void)viewWillAppear
{
    [networkAwareViewController
        setNoConnectionText:
        NSLocalizedString(@"nodata.noconnection.text", @"")];
    
    [gitHubService fetchInfoForUsername:username];

    UserInfo * userInfo = [userCacheReader primaryUser];
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

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    [networkAwareViewController setUpdatingState:kDisconnected];
}

@end
