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

- (NetworkAwareViewController *)networkAwareViewController;
- (CommitViewController *)commitViewController;
- (ChangesetViewController *)changesetViewController;
- (DiffViewController *)diffViewController;

@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * repoName;
@property (nonatomic, copy) NSString * commitKey;

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
    [username release];
    [repoName release];
    [commitKey release];
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

#pragma mark CommitSelector implementation

- (void)user:(NSString *)user didSelectCommit:(NSString *)commit
    forRepo:(NSString *)repo
{
    BOOL needsToScrollToTop =
        ![username isEqualToString:user] ||
        ![repoName isEqualToString:repo] ||
        ![commitKey isEqualToString:commit];

    self.username = user;
    self.repoName = repo;
    self.commitKey = commit;

    gitHubFailure = NO;
    avatarFailure = NO;

    [self networkAwareViewController].navigationItem.title =
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
        [[self networkAwareViewController]
            setUpdatingState:kConnectedAndNotUpdating];
        [[self networkAwareViewController] setCachedDataAvailable:YES];

        [[self commitViewController] updateWithCommitInfo:commitInfo
                                                  forRepo:repoName];
    } else {
        [[self networkAwareViewController]
            setUpdatingState:kConnectedAndUpdating];
        [[self networkAwareViewController] setCachedDataAvailable:NO];

        // commits don't change, so only update if needed
        [gitHubService
            fetchInfoForCommit:commitKey repo:repoName username:username];
    }

    [navigationController
        pushViewController:[self networkAwareViewController] animated:YES];

    if (needsToScrollToTop)
        [commitViewController scrollToTop];
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
  fetchedForCommit:(NSString *)commit
              repo:(NSString *)repo
          username:(NSString *)user
{
    if (![username isEqualToString:user] || ![repoName isEqualToString:repo] ||
        ![commitKey isEqualToString:commit])
        return;  // this is not the update we're waiting for

    BOOL cachedDataWasAvailable =
        networkAwareViewController.cachedDataAvailable;

    [[self commitViewController] updateWithCommitInfo:commitInfo forRepo:repo];

    [[self networkAwareViewController]
        setUpdatingState:kConnectedAndNotUpdating];
    [[self networkAwareViewController] setCachedDataAvailable:YES];

    if (!cachedDataWasAvailable)
        [commitViewController scrollToTop];
}

- (void)failedToFetchInfoForCommit:(NSString *)commit
                              repo:(NSString *)repo
                          username:(NSString *)user
                             error:(NSError *)error
{
    if (![username isEqualToString:user] || ![repoName isEqualToString:repo] ||
        ![commitKey isEqualToString:commit])
        return;  // this is not the update we're waiting for

    if (!gitHubFailure) {
        gitHubFailure = YES;
        
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

        [[self networkAwareViewController] setUpdatingState:kDisconnected];
    }
}

- (void)avatar:(UIImage *)avatar fetchedForEmailAddress:(NSString *)emailAddress
{
    [[self commitViewController] updateWithAvatar:avatar];
}

- (void)failedToFetchAvatarForEmailAddress:(NSString *)emailAddress
                                     error:(NSError *)error
{
    if (!avatarFailure) {
        avatarFailure = YES;
        
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

- (NetworkAwareViewController *)networkAwareViewController
{
    if (!networkAwareViewController)
        networkAwareViewController = [[NetworkAwareViewController alloc]
            initWithTargetViewController:[self commitViewController]];

    return networkAwareViewController;
}

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

- (void)setUsername:(NSString *)aUsername
{
    NSString * tmp = [aUsername copy];
    [username release];
    username = tmp;
}

- (void)setRepoName:(NSString *)aRepoName
{
    NSString * tmp = [aRepoName copy];
    [repoName release];
    repoName = tmp;
}

- (void)setCommitKey:(NSString *)aCommitKey
{
    NSString * tmp = [aCommitKey copy];
    [commitKey release];
    commitKey = tmp;
}

@end
