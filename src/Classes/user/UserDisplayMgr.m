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
    [networkAwareViewController setNoConnectionText:@"No Connection"];
    [networkAwareViewController
        setNoConnectionCachedDataText:@"No Connection - Stale Data"];
    
    gitHub =
        [[GitHub alloc] initWithBaseUrl:@"http://github.com/api"
        format:JsonApiFormat delegate:self];
}

- (void)display
{
    [gitHub fetchInfoForUsername:logInState.login];

    UserInfo * userInfo = [userCache primaryUser];
    [userViewController setUsername:logInState.login];
    [userViewController updateWithUserInfo:userInfo];
    
    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    [networkAwareViewController setCachedDataAvailable:!!userInfo];
}

- (void)username:(NSString *)username hasInfo:(UserInfo *)info
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
