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
    [gitHub release];
    [super dealloc];
}

#pragma mark CommitSelector implementation

- (void)user:(NSString *)username didSelectCommit:(NSString *)commitKey
    fromRepo:(NSString *)repoName
{
    [navigationController
        pushViewController:networkAwareViewController animated:YES];
    networkAwareViewController.navigationItem.title =
        NSLocalizedString(@"commit.view.title", @"");

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];    
}

@end