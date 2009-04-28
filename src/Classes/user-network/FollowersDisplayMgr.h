//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubServiceDelegate.h"
#import "UserDisplayMgr.h"
#import "UserNetworkDisplayMgrDelegate.h"

@class UserNetworkDisplayMgr;
@class GitHubService;

@interface FollowersDisplayMgr :
    NSObject <GitHubServiceDelegate, UserNetworkDisplayMgrDelegate>
{
    UINavigationController * navigationController;

    UserNetworkDisplayMgr * userNetworkDisplayMgr;
    GitHubService * gitHubService;

    NSString * username;

    BOOL gitHubFailure;
}

#pragma mark Initialization

- (id)initWithNavigationController:(UINavigationController *)nc
                     gitHubService:(GitHubService *)aGitHubService
                    userDisplayMgr:(NSObject<UserDisplayMgr> *)aUserDisplayMgr;

#pragma mark Displaying data

- (void)displayFollowersForUsername:(NSString *)username;

@end
