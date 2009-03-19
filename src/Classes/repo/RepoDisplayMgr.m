//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RepoDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "RepoViewController.h"
#import "GitHubService.h"

@interface RepoDisplayMgr (Private)
- (BOOL)isPrimaryUser:(NSString *)username;
@end

@implementation RepoDisplayMgr

- (void)dealloc
{
    [logInStateReader release];
    [repoCacheReader release];
    [networkAwareViewController release];
    [repoViewController release];
    [gitHub release];
    [super dealloc];
}

- (void)display
{
    [navigationController
        pushViewController:networkAwareViewController animated:YES];

    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    [networkAwareViewController setCachedDataAvailable:NO];    
}

#pragma mark RepoSelector implementation

- (void)user:(NSString *)username didSelectRepo:(NSString *)repo
{
    //
    // TODO: Display cached data if available
    //

    //
    // TODO: Token needs to be provided here or by the GitHubService
    //
    [gitHub fetchInfoForRepo:repo username:username];

    [self display];
}

#pragma mark GitHubServiceDelegate implementation

- (void)commits:(NSArray *)commits fetchedForRepo:(NSString *)repo
    username:(NSString *)username;
{
    RepoInfo * repoInfo = nil;
    if ([self isPrimaryUser:username])
        repoInfo = [repoCacheReader primaryUserRepoWithName:repo];
    else
        repoInfo = [repoCacheReader repoWithUsername:username repoName:repo];

    [repoViewController updateWithCommits:commits forRepo:repoInfo];

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToFetchInfoForRepo:(NSString *)repo
                        username:(NSString *)username
                           error:(NSError *)error
{
    NSLog(@"Failed to retrieve info for repo: '%@' for user: '%@' error: '%@'.",
        repo, username, error);
}

#pragma mark Helper methods

- (BOOL)isPrimaryUser:(NSString *)username
{
    return [username isEqualToString:logInStateReader.login];
}

@end
