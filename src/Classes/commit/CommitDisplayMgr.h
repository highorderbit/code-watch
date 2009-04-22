//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommitSelector.h"
#import "CommitCacheReader.h"
#import "AvatarCacheReader.h"
#import "GitHubServiceDelegate.h"
#import "GravatarServiceDelegate.h"
#import "CommitViewControllerDelegate.h"
#import "ChangesetViewControllerDelegate.h"

@class NetworkAwareViewController;
@class CommitViewController, ChangesetViewController, DiffViewController;
@class GitHubService, GitHubServiceFactory;
@class GravatarService, GravatarServiceFactory;

@interface CommitDisplayMgr :
    NSObject
    <CommitSelector, GitHubServiceDelegate, GravatarServiceDelegate,
     CommitViewControllerDelegate, ChangesetViewControllerDelegate>
{
    IBOutlet UINavigationController * navigationController;

    NetworkAwareViewController * networkAwareViewController;
    CommitViewController * commitViewController;

    ChangesetViewController * changesetViewController;
    DiffViewController * diffViewController;

    IBOutlet NSObject<CommitCacheReader> * commitCacheReader;
    IBOutlet NSObject<AvatarCacheReader> * avatarCacheReader;

    IBOutlet GitHubService * gitHubService;

    IBOutlet GravatarServiceFactory * gravatarServiceFactory;
    GravatarService * gravatarService;

    NSString * username;
    NSString * repoName;
    NSString * commitKey;
    
    BOOL gitHubFailure;
    BOOL avatarFailure;
}

- (id)initWithNavigationController:
    (UINavigationController *)aNavigationController
    networkAwareViewController:
    (NetworkAwareViewController *)aNetworkAwareViewController
    commitViewController:
    (CommitViewController *)aCommitViewController
    commitCacheReader:
    (NSObject<CommitCacheReader> *)aCommitCacheReader
    avatarCacheReader:
    (NSObject<AvatarCacheReader> *)anAvatarCacheReader
    gitHubService:
    (GitHubService *)aGitHubService
    gravatarServiceFactory:
    (GravatarServiceFactory *)aGravatarServiceFactory;

@end
