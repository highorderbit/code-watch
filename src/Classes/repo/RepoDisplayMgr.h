//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepoSelector.h"
#import "GitHubServiceDelegate.h"
#import "GravatarServiceDelegate.h"
#import "GravatarServiceDelegate.h"
#import "LogInStateReader.h"
#import "RepoCacheReader.h"
#import "CommitCacheReader.h"
#import "AvatarCacheReader.h"
#import "RepoViewControllerDelegate.h"
#import "CommitSelector.h"

@class RepoInfo, NetworkAwareViewController, RepoViewController;
@class GitHubService, GravatarService, GravatarServiceFactory;

@interface RepoDisplayMgr :
    NSObject <RepoSelector, GitHubServiceDelegate, GravatarServiceDelegate,
    RepoViewControllerDelegate>
{
    NSString * username;
    NSString * repoName;
    RepoInfo * repoInfo;
    NSDictionary * commits;

    IBOutlet NSObject<LogInStateReader> * logInStateReader;
    IBOutlet NSObject<RepoCacheReader> * repoCacheReader;
    IBOutlet NSObject<CommitCacheReader> * commitCacheReader;
    IBOutlet NSObject<AvatarCacheReader> * avatarCacheReader;

    IBOutlet UINavigationController * navigationController;

    IBOutlet NetworkAwareViewController * networkAwareViewController;
    IBOutlet RepoViewController * repoViewController;

    IBOutlet GitHubService * gitHubService;

    GravatarService * gravatarService;
    IBOutlet GravatarServiceFactory * gravatarServiceFactory;

    IBOutlet NSObject<CommitSelector> * commitSelector;
}

- (id)initWithLogInStateReader:
    (NSObject<LogInStateReader> *) logInStateReader
    repoCacheReader:
    (NSObject<RepoCacheReader> *) repoCacheReader
    commitCacheReader:
    (NSObject<CommitCacheReader> *) commitCacheReader
    avatarCacheReader:
    (NSObject<AvatarCacheReader> *)anAvatarCacheReader
    navigationController:
    (UINavigationController *) navigationController
    networkAwareViewController:
    (NetworkAwareViewController *) networkAwareViewController
    repoViewController:
    (RepoViewController *) repoViewController
    gitHubService:
    (GitHubService *)aGitHubService
    gravatarServiceFactory:
    (GravatarServiceFactory *)aGravatarServiceFactory
    commitSelector:
    (NSObject<CommitSelector> *) commitSelector;

@property (nonatomic, copy, readonly) NSString * username;
@property (nonatomic, copy, readonly) NSString * repoName;
@property (nonatomic, copy, readonly) RepoInfo * repoInfo;
//@property (nonatomic, retain, readonly) UIImage * avatar;
@property (nonatomic, copy, readonly) NSDictionary * commits;

- (void)refreshRepoInfo;

@end
