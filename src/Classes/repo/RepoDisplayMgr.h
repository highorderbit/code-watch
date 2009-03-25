//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepoSelector.h"
#import "GitHubServiceDelegate.h"
#import "LogInStateReader.h"
#import "RepoCacheReader.h"
#import "CommitCacheReader.h"
#import "RepoViewControllerDelegate.h"
#import "CommitSelector.h"

@class RepoInfo, NetworkAwareViewController, RepoViewController, GitHubService;

@interface RepoDisplayMgr :
    NSObject <RepoSelector, GitHubServiceDelegate, RepoViewControllerDelegate>
{
    NSString * username;
    NSString * repoName;
    RepoInfo * repoInfo;
    NSDictionary * commits;

    IBOutlet NSObject<LogInStateReader> * logInStateReader;
    IBOutlet NSObject<RepoCacheReader> * repoCacheReader;
    IBOutlet NSObject<CommitCacheReader> * commitCacheReader;

    IBOutlet UINavigationController * navigationController;

    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet RepoViewController * repoViewController;

    IBOutlet GitHubService * gitHub;

    IBOutlet NSObject<CommitSelector> * commitSelector;
}

@property (nonatomic, copy, readonly) NSString * repoName;
@property (nonatomic, copy, readonly) RepoInfo * repoInfo;
@property (nonatomic, copy, readonly) NSDictionary * commits;

@end
