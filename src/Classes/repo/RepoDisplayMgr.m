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
    [repoViewController updateWithCommits:commits];

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
