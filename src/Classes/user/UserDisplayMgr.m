//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserDisplayMgr.h"

@implementation UserDisplayMgr

- (void)dealloc
{
    [networkAwareViewController release];
    [userViewController release];
    
    [userCache release];
    [logInState release];

    [repoSelector release];
    
    [gitHub release];
    
    [super dealloc];
}

- (void)viewWillAppear
{
    if (logInState && logInState.login) {
        [networkAwareViewController
            setNoConnectionText:
            NSLocalizedString(@"nodata.noconnection.text", @"")];
        
        [gitHub fetchInfoForUsername:logInState.login];

        UserInfo * userInfo = [userCache primaryUser];
        [userViewController setUsername:logInState.login];
        [userViewController updateWithUserInfo:userInfo];
    
        [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
        [networkAwareViewController setCachedDataAvailable:!!userInfo];
    } else {
        // This is a bit of a hack, but a relatively simple solution:
        // Configure the network-aware controller to 'disconnected' and set the
        // disconnected text accordingly
        [networkAwareViewController
            setNoConnectionText:
            NSLocalizedString(@"userdisplaymgr.login.text", @"")];
        [networkAwareViewController setUpdatingState:kDisconnected];
        [networkAwareViewController setCachedDataAvailable:NO];
    }
}

#pragma mark UserViewControllerDelegate implementation

- (void)userDidSelectRepo:(NSString *)repo
{
    [repoSelector user:logInState.login didSelectRepo:repo];
}

#pragma mark GitHubServiceDelegate implementation

- (void)userInfo:(UserInfo *)info repoInfos:(NSDictionary *)repos
    fetchedForUsername:(NSString *)username
{
    [userViewController updateWithUserInfo:info];

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToFetchInfoForUsername:(NSString *)username error:(NSError *)error
{
    [networkAwareViewController setUpdatingState:kDisconnected];
}

@end
