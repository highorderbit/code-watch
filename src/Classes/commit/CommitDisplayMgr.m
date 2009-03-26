//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CommitDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "CommitViewController.h"
#import "ChangesetViewController.h"
#import "DiffViewController.h"
#import "GitHubService.h"

@interface CommitDisplayMgr (Private)
- (ChangesetViewController *)changesetViewController;
- (DiffViewController *)diffViewController;
@end

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

- (void)awakeFromNib
{
    // TODO: Remove when wired in the nib
    commitViewController.delegate = self;
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

#pragma mark CommitViewControllerDelegate implementation

- (void)userDidSelectChangeset:(NSArray *)changeset
{
    [[self changesetViewController] updateWithChangeset:changeset];
    [navigationController
        pushViewController:changesetViewController animated:YES];
}

#pragma mark ChangesetViewControllerDelegate implementation

- (void)userDidSelectDiff:(NSDictionary *)diff
{
    [[self diffViewController] updateWithDiff:diff];
    [navigationController pushViewController:diffViewController animated:YES];
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

#pragma mark Accessors

- (ChangesetViewController *)changesetViewController
{
    if (!changesetViewController) {
        changesetViewController = [[ChangesetViewController alloc]
            initWithNibName:@"ChangesetView" bundle:nil];
        changesetViewController.delegate = self;
    }

    return changesetViewController;
}

- (DiffViewController *)diffViewController
{
    if (!diffViewController)
        diffViewController = [[DiffViewController alloc]
            initWithNibName:@"DiffView" bundle:nil];

    return diffViewController;
}

@end
