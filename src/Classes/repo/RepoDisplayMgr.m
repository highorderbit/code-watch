//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RepoDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "RepoViewController.h"
#import "GitHubService.h"

@interface RepoDisplayMgr (Private)
- (BOOL)loadCachedDataForUsername:(NSString *)username
                         repoName:(NSString *)repoName;
- (RepoInfo *)repoInfoForUsername:(NSString *)username
                         repoName:(NSString *)repoName;
- (NSArray *)commitsForUsername:(NSString *)username
                       repoName:(NSString *)repoName;
- (BOOL)isPrimaryUser:(NSString *)username;

- (void)setRepoInfo:(RepoInfo *)info;
- (void)setRepoName:(NSString *)name;
- (void)setCommits:(NSArray *)someCommits;
@end

@implementation RepoDisplayMgr

@synthesize repoName, repoInfo, commits;

- (void)dealloc
{
    [repoName release];
    [repoInfo release];
    [commits release];
    [logInStateReader release];
    [repoCacheReader release];
    [networkAwareViewController release];
    [repoViewController release];
    [gitHub release];
    [super dealloc];
}

#pragma mark RepoSelector implementation

- (void)user:(NSString *)username didSelectRepo:(NSString *)repo
{
    [self setRepoName:repo];

    BOOL cachedDataAvailable =
        [self loadCachedDataForUsername:username repoName:repo];

    if (cachedDataAvailable)  // cached data is available
        [repoViewController updateWithCommits:commits
                                      forRepo:repoName
                                         info:repoInfo];

    [gitHub fetchInfoForRepo:repo username:username];

    [navigationController
        pushViewController:networkAwareViewController animated:YES];
    networkAwareViewController.navigationItem.title =
        NSLocalizedString(@"repo.view.title", @"");

    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    [networkAwareViewController setCachedDataAvailable:cachedDataAvailable];    
}

#pragma mark GitHubServiceDelegate implementation

- (void)commits:(NSArray *)newCommits fetchedForRepo:(NSString *)updatedRepoName
    username:(NSString *)username
{
    RepoInfo * info =
        [self repoInfoForUsername:username repoName:updatedRepoName];
    [self setRepoInfo:info];

    [self setRepoName:updatedRepoName];
    [self setCommits:newCommits];

    [repoViewController updateWithCommits:commits
                                  forRepo:repoName
                                     info:repoInfo];

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToFetchInfoForRepo:(NSString *)repo
                        username:(NSString *)username
                           error:(NSError *)error
{
    NSLog(@"Failed to retrieve info for repo: '%@' for user: '%@' error: '%@'.",
        repo, username, error);

    //
    // TODO: Display the error to the user.
    //
}

#pragma mark Helper methods

- (BOOL)loadCachedDataForUsername:(NSString *)username
                         repoName:(NSString *)repo
{
    RepoInfo * cachedInfo =
        [self repoInfoForUsername:username repoName:repo];
    [self setRepoInfo:cachedInfo];

    NSArray * cachedCommits = [self commitsForUsername:username repoName:repo];
    [self setCommits:cachedCommits];

    return cachedInfo && cachedCommits;
}

- (RepoInfo *)repoInfoForUsername:(NSString *)username
                         repoName:(NSString *)repo
{
    return [self isPrimaryUser:username] ?
        [repoCacheReader primaryUserRepoWithName:repo] :
        [repoCacheReader repoWithUsername:username repoName:repo];
}

- (NSArray *)commitsForUsername:(NSString *)username
                       repoName:(NSString *)repo
{
    //
    // TODO: Provide real implementation
    //

    if ([self repoInfoForUsername:username repoName:repo])
        return [NSArray array];
    return nil;
}

- (BOOL)isPrimaryUser:(NSString *)username
{
    return [username isEqualToString:logInStateReader.login];
}

#pragma mark Accessors

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

- (void)setCommits:(NSArray *)someCommits
{
    NSArray * tmp = [someCommits copy];
    [commits release];
    commits = tmp;
}

@end
