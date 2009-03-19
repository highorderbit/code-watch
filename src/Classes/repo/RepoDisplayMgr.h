//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceDelegate.h"
#import "RepoSelector.h"

@class NetworkAwareViewController, RepoViewController, GitHubService;

@interface RepoDisplayMgr :
    NSObject <RepoSelector, GitHubServiceDelegate>
{
    IBOutlet UINavigationController * navigationController;

    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet RepoViewController * repoViewController;

    IBOutlet GitHubService * gitHub;
}

@end
