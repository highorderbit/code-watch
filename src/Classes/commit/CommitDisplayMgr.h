//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommitSelector.h"
#import "GitHubServiceDelegate.h"

@class NetworkAwareViewController, CommitViewController, GitHubService;

@interface CommitDisplayMgr : NSObject <CommitSelector, GitHubServiceDelegate>
{
    IBOutlet UINavigationController * navigationController;

    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet CommitViewController * commitViewController;

    IBOutlet GitHubService * gitHub;
}

@end