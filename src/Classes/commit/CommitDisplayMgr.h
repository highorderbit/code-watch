//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommitSelector.h"
#import "CommitCacheReader.h"
#import "GitHubServiceDelegate.h"
#import "CommitViewControllerDelegate.h"
#import "ChangesetViewControllerDelegate.h"

@class NetworkAwareViewController;
@class CommitViewController, ChangesetViewController, DiffViewController;
@class GitHubService;

@interface CommitDisplayMgr :
    NSObject
    <CommitSelector, GitHubServiceDelegate,
     CommitViewControllerDelegate, ChangesetViewControllerDelegate>
{
    IBOutlet UINavigationController * navigationController;

    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet CommitViewController * commitViewController;

    ChangesetViewController * changesetViewController;
    DiffViewController * diffViewController;

    IBOutlet NSObject<CommitCacheReader> * commitCacheReader;

    IBOutlet GitHubService * gitHub;
}

- (id)initWithNavigationController:
    (UINavigationController *) navigationController
    networkAwareViewController:
    (NetworkAwareViewController *)networkAwareViewController
    commitViewController:
    (CommitViewController *)commitViewController
    commitCacheReader:
    (NSObject<CommitCacheReader> *) commitCacheReader
    gitHubService:
    (GitHubService *) gitHub;

@end
