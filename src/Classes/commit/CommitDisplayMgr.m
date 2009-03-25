//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CommitDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "CommitViewController.h"
#import "GitHubService.h"

@implementation CommitDisplayMgr

- (void)dealloc
{
    [navigationController release];
    [networkAwareViewController release];
    [commitViewController release];
    [commitCacheReader release];
    [gitHub release];
    [super dealloc];
}

#pragma mark CommitSelector implementation

- (void)user:(NSString *)username didSelectCommit:(NSString *)commitKey
    forRepo:(NSString *)repoName
{
    [navigationController
        pushViewController:networkAwareViewController animated:YES];
    networkAwareViewController.navigationItem.title =
        NSLocalizedString(@"commit.view.title", @"");

    CommitInfo * commitInfo = [commitCacheReader commitWithKey:commitKey];
    [commitViewController updateWithCommitInfo:commitInfo];

    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    [networkAwareViewController setCachedDataAvailable:!!commitInfo];    

    [gitHub fetchInfoForCommit:commitKey repo:repoName username:username];
}

#pragma mark GitHubServiceDelegate implementation

- (void)commitInfo:(CommitInfo *)commitInfo
  fetchedForCommit:(NSString *)commitKey
              repo:(NSString *)repo
          username:(NSString *)username
{
    [commitViewController updateWithCommitInfo:commitInfo];

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToFetchInfoForCommit:(NSString *)commitKey
                              repo:(NSString *)repo
                          username:(NSString *)username
                             error:(NSError *)error
{
    // TODO: Display an error
}

@end
