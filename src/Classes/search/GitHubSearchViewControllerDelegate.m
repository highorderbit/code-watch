//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "GitHubSearchViewControllerDelegate.h"
#import "RepoKey.h"

@interface GitHubSearchViewControllerDelegate (Private)

+ (NSString * )userSectionKey;

@end

@implementation GitHubSearchViewControllerDelegate

@synthesize userDisplayMgr;

- (void)dealloc
{
    [navigationController release];
    [userDisplayMgrFactory release];
    [userDisplayMgr release];
    [repoSelectorFactory release];
    [repoSelector release];
    [super dealloc];
}

- (void)processSelection:(NSObject *)selection fromSection:(NSString *)section
{
    if ([section isEqual:[[self class] userSectionKey]])
        [self.userDisplayMgr
            displayUserInfoForUsername:[selection description]];
    else {
        RepoKey * repoKey = (RepoKey *)selection;
        [self.repoSelector user:repoKey.username
            didSelectRepo:repoKey.repoName];
    }
}

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

+ (NSString *)userSectionKey
{
    return @"User";
}

@end
