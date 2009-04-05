//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CommitDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "CommitViewController.h"
#import "ChangesetViewController.h"
#import "DiffViewController.h"
#import "GitHubService.h"
#import "GravatarService.h"
#import "GravatarServiceFactory.h"

@interface CommitDisplayMgr (Private)

+ (NSString *)changesetTypeLabel:(ChangesetType)type;

- (CommitViewController *)commitViewController;
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
    [avatarCacheReader release];
    [gitHubService release];
    [gravatarService release];
    [gravatarServiceFactory release];
    [super dealloc];
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
    (GravatarServiceFactory *)aGravatarServiceFactory
{
    if (self = [super init]) {
        navigationController = [aNavigationController retain];
        networkAwareViewController = [aNetworkAwareViewController retain];
        commitViewController = [aCommitViewController retain];
        commitCacheReader = [aCommitCacheReader retain];
        avatarCacheReader = [anAvatarCacheReader retain];
        gitHubService = [aGitHubService retain];

        gravatarServiceFactory = [aGravatarServiceFactory retain];
        gravatarService =
            [[gravatarServiceFactory createGravatarService] retain];
        gravatarService.delegate = self;
    }
    
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"Awaking form nib.");
}

#pragma mark CommitSelector implementation

- (void)user:(NSString *)username didSelectCommit:(NSString *)commitKey
    forRepo:(NSString *)repoName
{
    networkAwareViewController.navigationItem.title =
        NSLocalizedString(@"commit.view.title", @"");

    CommitInfo * commitInfo = [commitCacheReader commitWithKey:commitKey];

    NSString * email = 
        [[commitInfo.details objectForKey:@"committer"] objectForKey:@"email"];
    UIImage * avatar = [avatarCacheReader avatarForEmailAddress:email];
    if (avatar)
        [[self commitViewController] updateWithAvatar:avatar];
    else
        [gravatarService fetchAvatarForEmailAddress:email];

    BOOL cached = !!commitInfo.changesets;

    if (cached) {
        [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
        [networkAwareViewController setCachedDataAvailable:YES];

        [[self commitViewController] updateWithCommitInfo:commitInfo];
    } else {
        [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
        [networkAwareViewController setCachedDataAvailable:NO];

        // commits don't change, so only update if needed
        [gitHubService
            fetchInfoForCommit:commitKey repo:repoName username:username];
    }

    [navigationController
        pushViewController:networkAwareViewController animated:YES];
}

#pragma mark CommitViewControllerDelegate implementation

- (void)userDidSelectChangeset:(NSArray *)changeset ofType:(ChangesetType)type
{
    NSString * label = [[self class] changesetTypeLabel:type];

    [[self changesetViewController] updateWithChangeset:changeset];
    changesetViewController.navigationItem.title = label;
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
    [[self commitViewController] updateWithCommitInfo:commitInfo];

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToFetchInfoForCommit:(NSString *)commitKey
                              repo:(NSString *)repo
                          username:(NSString *)username
                             error:(NSError *)error
{
    NSLog(@"Failed to retrieve info for commit: '%@' for user: '%@' repo: '%@' "
        "error: '%@'.", commitKey, repo, username, error);

    NSString * title =
        NSLocalizedString(@"github.commitupdate.failed.alert.title", @"");
    NSString * cancelTitle =
        NSLocalizedString(@"github.commitupdate.failed.alert.ok", @"");
    NSString * message = error.localizedDescription;

    UIAlertView * alertView =
        [[[UIAlertView alloc]
          initWithTitle:title
                message:message
               delegate:self
      cancelButtonTitle:cancelTitle
      otherButtonTitles:nil]
         autorelease];

    [alertView show];

    [networkAwareViewController setUpdatingState:kDisconnected];
}

- (void)avatar:(UIImage *)avatar fetchedForEmailAddress:(NSString *)emailAddress
{
    [[self commitViewController] updateWithAvatar:avatar];
}

- (void)failedToFetchAvatarForEmailAddress:(NSString *)emailAddress
                                     error:(NSError *)error
{
    NSLog(@"Failed to retrieve avatar for email address: '%@' error: '%@'.",
        emailAddress, error);

    NSString * title =
        NSLocalizedString(@"gravatar.repoupdate.failed.alert.title", @"");
    NSString * cancelTitle =
        NSLocalizedString(@"gravatar.repoupdate.failed.alert.ok", @"");
    NSString * message = error.localizedDescription;

    UIAlertView * alertView =
        [[[UIAlertView alloc]
          initWithTitle:title
                message:message
               delegate:self
      cancelButtonTitle:cancelTitle
      otherButtonTitles:nil]
         autorelease];

    [alertView show];
}

#pragma mark Helpers

+ (NSString *)changesetTypeLabel:(ChangesetType)type
{
    switch (type) {
        case kChangesetTypeAdded:
            return NSLocalizedString(@"commit.changeset.added.label", @"");
        case kChangesetTypeRemoved:
            return NSLocalizedString(@"commit.changeset.removed.label", @"");
        case kChangesetTypeModified:
            return NSLocalizedString(@"commit.changeset.modified.label", @"");
    }

    return nil;
}

#pragma mark Accessors

- (CommitViewController *)commitViewController
{
    if (!commitViewController) {
        commitViewController = [[CommitViewController alloc]
            initWithNibName:@"CommitView" bundle:nil];
        commitViewController.delegate = self;
    }

    return commitViewController;
}

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
