//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepoSelector.h"
#import "GitHubServiceDelegate.h"
#import "LogInStateReader.h"
#import "RepoCacheReader.h"

@class NetworkAwareViewController, RepoViewController, GitHubService;

@interface RepoDisplayMgr : NSObject <RepoSelector, GitHubServiceDelegate>
{
    IBOutlet NSObject<LogInStateReader> * logInStateReader;
    IBOutlet NSObject<RepoCacheReader> * repoCacheReader;

    IBOutlet UINavigationController * navigationController;

    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet RepoViewController * repoViewController;

    IBOutlet GitHubService * gitHub;
}

@end
