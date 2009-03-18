//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RepoDisplayMgr.h"
#import "NetworkAwareViewController.h"
#import "RepoViewController.h"
#import "GitHubService.h"

@implementation RepoDisplayMgr

- (void)dealloc
{
    [networkAwareViewController release];
    [repoViewController release];
    [gitHub release];
    [super dealloc];
}

- (void)display
{
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];    
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

    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    [networkAwareViewController setCachedDataAvailable:NO];
}

#pragma mark GitHubServiceDelegate implementation

- (void)repoInfo:(RepoInfo *)info fetchedForUsername:(NSString *)username
{
    NSLog(@"Providing info: '%@'.", info);
    [repoViewController updateWithRepoInfo:info];

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

@end
