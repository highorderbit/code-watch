//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RepoDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "RepoViewController.h"
#import "GitHubService.h"
#import "GravatarService.h"
#import "GravatarServiceFactory.h"

@interface RepoDisplayMgr (Private)

- (void)addRefreshButton;
- (BOOL)loadCachedData;
- (RepoInfo *)cachedRepoInfoForUsername:(NSString *)username
                               repoName:(NSString *)repoName;
- (NSDictionary *)cachedCommitsForRepoInfo:(RepoInfo *)info;
- (BOOL)isPrimaryUser:(NSString *)username;

- (void)setUsername:(NSString *)username;
- (void)setRepoInfo:(RepoInfo *)info;
- (void)setRepoName:(NSString *)name;
- (void)setAvatar:(UIImage *)avatar;
- (void)setCommits:(NSDictionary *)someCommits;

@end

@implementation RepoDisplayMgr

@synthesize username, repoName, repoInfo, avatar, commits;

- (void)dealloc
{
    [username release];
    [repoName release];
    [repoInfo release];
    [avatar release];
    [commits release];
    [logInStateReader release];
    [repoCacheReader release];
    [navigationController release];
    [networkAwareViewController release];
    [repoViewController release];
    [gitHubService release];
    [gravatarService release];
    [gravatarServiceFactory release];
    [commitSelector release];
    [super dealloc];
}

- (id)initWithLogInStateReader:
    (NSObject<LogInStateReader> *) aLogInStateReader
    repoCacheReader:
    (NSObject<RepoCacheReader> *) aRepoCacheReader
    commitCacheReader:
    (NSObject<CommitCacheReader> *) aCommitCacheReader
    avatarCacheReader:
    (NSObject<AvatarCacheReader> *)anAvatarCacheReader
    navigationController:
    (UINavigationController *) aNavigationController
    networkAwareViewController:
    (NetworkAwareViewController *) aNetworkAwareViewController
    repoViewController:
    (RepoViewController *) aRepoViewController
    gitHubService:
    (GitHubService *) aGitHubService
    gravatarServiceFactory:
    (GravatarServiceFactory *)aGravatarServiceFactory
    commitSelector:
    (NSObject<CommitSelector> *) aCommitSelector
{
    if (self = [super init]) {
        logInStateReader = [aLogInStateReader retain];
        repoCacheReader = [aRepoCacheReader retain];
        commitCacheReader = [aCommitCacheReader retain];
        avatarCacheReader = [anAvatarCacheReader retain];
        navigationController = [aNavigationController retain];
        networkAwareViewController = [aNetworkAwareViewController retain];
        repoViewController = [aRepoViewController retain];
        gitHubService = [aGitHubService retain];
        commitSelector = [aCommitSelector retain];

        gravatarServiceFactory = [aGravatarServiceFactory retain];
        gravatarService = [gravatarServiceFactory createGravatarService];
        
        [self addRefreshButton];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self addRefreshButton];
}

- (void)addRefreshButton
{
    UIBarButtonItem * refreshButton =
        [[[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
        target:self
        action:@selector(refreshRepoInfo)] autorelease];

    [networkAwareViewController.navigationItem
        setRightBarButtonItem:refreshButton animated:NO];
}

- (void)refreshRepoInfo
{
    [self user:username didSelectRepo:repoName];
}

#pragma mark RepoSelector implementation

- (void)user:(NSString *)user didSelectRepo:(NSString *)repo
{
    [self setUsername:user];
    [self setRepoName:repo];

    BOOL cachedDataAvailable = [self loadCachedData];
    if (cachedDataAvailable)
        [repoViewController updateWithCommits:commits
                                      forRepo:repoName
                                         info:repoInfo];

    // refresh user info so we can refresh repo metadata (description, etc.)
    [gitHubService fetchInfoForUsername:username];

    networkAwareViewController.navigationItem.title =
        NSLocalizedString(@"repo.view.title", @"");

    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    [networkAwareViewController setCachedDataAvailable:cachedDataAvailable];    

    [navigationController
        pushViewController:networkAwareViewController animated:YES];
}

#pragma mark GitHubServiceDelegate implementation

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)updatedUsername
{
    for (NSString * repo in repos.allKeys)
        if ([repoName isEqualToString:repo]) {
            [self setRepoInfo:[repos objectForKey:repo]];
            // get the commit details
            [gitHubService fetchInfoForRepo:repo username:updatedUsername];

            break;
        }
}

- (void)failedToFetchInfoForUsername:(NSString *)user
                               error:(NSError *)error
{
    NSLog(@"Failed to retrieve info for user: '%@' error: '%@'.", user, error);

    NSString * title =
        NSLocalizedString(@"github.repoupdate.failed.alert.title", @"");
    NSString * cancelTitle =
        NSLocalizedString(@"github.repoupdate.failed.alert.ok", @"");
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

- (void)commits:(NSDictionary*)newCommits
 fetchedForRepo:(NSString *)updatedRepoName
       username:(NSString *)user
{
    [self setUsername:user];
    [self setRepoName:updatedRepoName];

    RepoInfo * info =
        [self cachedRepoInfoForUsername:user repoName:updatedRepoName];
    [self setRepoInfo:info];

    [self setCommits:newCommits];

    [repoViewController updateWithCommits:commits
                                  forRepo:repoName
                                     info:repoInfo];

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToFetchInfoForRepo:(NSString *)repo
                        username:(NSString *)user
                           error:(NSError *)error
{
    NSLog(@"Failed to retrieve info for repo: '%@' for user: '%@' error: '%@'.",
        repo, user, error);

    NSString * title =
        NSLocalizedString(@"github.repoupdate.failed.alert.title", @"");
    NSString * cancelTitle =
        NSLocalizedString(@"github.repoupdate.failed.alert.ok", @"");
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

- (void)avatar:(UIImage *)anAvatar
    fetchedForEmailAddress:(NSString *)emailAddress
{
    [self setAvatar:avatar];
    [repoViewController updateWithAvatar:avatar forEmailAddress:emailAddress];
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

#pragma mark RepoViewControllerDelegate implementation

- (void)userDidSelectCommit:(NSString *)commitKey
{
    [commitSelector user:username didSelectCommit:commitKey forRepo:repoName];
}

#pragma mark Helper methods

- (BOOL)loadCachedData
{
    RepoInfo * cachedInfo =
        [self cachedRepoInfoForUsername:username repoName:repoName];
    [self setRepoInfo:cachedInfo];

    NSDictionary * cachedCommits = [self cachedCommitsForRepoInfo:cachedInfo];
    [self setCommits:cachedCommits];

    return cachedInfo && cachedCommits;
}

- (RepoInfo *)cachedRepoInfoForUsername:(NSString *)user
                               repoName:(NSString *)repo
{
    return [self isPrimaryUser:user] ?
        [repoCacheReader primaryUserRepoWithName:repo] :
        [repoCacheReader repoWithUsername:user repoName:repo];
}

- (NSDictionary *)cachedCommitsForRepoInfo:(RepoInfo *)info
{
    NSMutableDictionary * cachedCommits = [NSMutableDictionary dictionary];
    for (NSString * commitKey in info.commitKeys) {
        CommitInfo * commitInfo = [commitCacheReader commitWithKey:commitKey];
        if (commitInfo)
            [cachedCommits setObject:commitInfo forKey:commitKey];
    }

    return cachedCommits.count > 0 ? cachedCommits : nil;
}

- (BOOL)isPrimaryUser:(NSString *)user
{
    return [user isEqualToString:logInStateReader.login];
}

#pragma mark Accessors

- (void)setUsername:(NSString *)user
{
    NSString * tmp = [user copy];
    [username release];
    username = tmp;
}

- (void)setRepoInfo:(RepoInfo *)info
{
    RepoInfo * tmp = [info copy];
    [repoInfo release];
    repoInfo = tmp;
}

- (void)setRepoName:(NSString *)name
{
    NSString * tmp = [name copy];
    [repoName release];
    repoName = tmp;
}

- (void)setAvatar:(UIImage *)anAvatar
{
    UIImage * tmp = [anAvatar retain];
    [avatar release];
    avatar = tmp;
}

- (void)setCommits:(NSDictionary *)someCommits
{
    NSDictionary * tmp = [someCommits copy];
    [commits release];
    commits = tmp;
}

@end
