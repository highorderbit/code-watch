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
    
    [gitHub release];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    [networkAwareViewController setUpdatingText:@"Updating..."];
    [networkAwareViewController
        setNoConnectionCachedDataText:@"No Connection - Stale Data"];
    
    gitHub =
        [[GitHub alloc] initWithBaseUrl:@"http://github.com/api/"
        format:JsonGitHubApiFormat delegate:self];
}

- (void)display
{
    if (logInState && logInState.login) {
        [networkAwareViewController setNoConnectionText:@"No Connection"];
        
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
            setNoConnectionText:@"Please Log In to View Personal Info"];
        [networkAwareViewController setUpdatingState:kDisconnected];
        [networkAwareViewController setCachedDataAvailable:NO];
    }
}

- (void)info:(UserInfo *)info fetchedForUsername:(NSString *)username;
{
    [userViewController updateWithUserInfo:info];
    
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
}

// - (void)requestFailedForUsername:(NSString *username) withError:(NSError *)error
// {
//     [networkAwareViewController setUpdatingState:kDisconnecte];
// }

@end
