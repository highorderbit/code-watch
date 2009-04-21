//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "FavoriteUsersDisplayMgr.h"

@implementation FavoriteUsersDisplayMgr

- (void)dealloc
{
    [viewController release];
    
    [super dealloc];
}

- (id)initWithViewController:(FavoriteUsersViewController *)aViewController
    userDisplayMgr:(NSObject<UserDisplayMgr> *)aUserDisplayMgr
{
    if (self = [super init]) {
        viewController = [aViewController retain];
        userDisplayMgr = [aUserDisplayMgr retain];
    }
    
    return self;
}

#pragma mark FavoriteUsersViewControllerDelegate implementation

- (void)viewWillAppear
{
    // set view controller usernames
}

- (void)selectedUsername:(NSString *)username
{    
    [userDisplayMgr displayUserInfoForUsername:username];
}

@end
