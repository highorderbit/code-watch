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
    networkAwareViewController.navigationItem.title =
        NSLocalizedString(@"commit.view.title", @"");

    CommitInfo * commitInfo = [commitCacheReader commitWithKey:commitKey];

    // TODO: Consider moving changeset into its own dictionary.
    BOOL cached = [commitInfo.details objectForKey:@"added"] != nil;


    if (cached) {
        [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
        [networkAwareViewController setCachedDataAvailable:YES];

        [commitViewController updateWithCommitInfo:commitInfo];
    } else {
        [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
        [networkAwareViewController setCachedDataAvailable:NO];

        // commits don't change, so only update if needed
        [gitHub fetchInfoForCommit:commitKey repo:repoName username:username];
    }

    [navigationController
        pushViewController:networkAwareViewController animated:YES];
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
