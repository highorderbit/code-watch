//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "GitHubSearchViewControllerDelegate.h"

@interface GitHubSearchViewControllerDelegate (Private)

+ (NSString * )userSectionKey;

@end

@implementation GitHubSearchViewControllerDelegate

@synthesize userDisplayMgr;

- (void)dealloc
{
    [navigationController release];
    [userDisplayMgrFactory release];
    [userDisplayMgr release];
    [super dealloc];
}

- (void)processSelection:(NSString *)text fromSection:(NSString *)section
{
    if ([section isEqual:[[self class] userSectionKey]])
        [self.userDisplayMgr displayUserInfoForUsername:text];
}

- (NSObject<UserDisplayMgr> *)userDisplayMgr
{
    if (!userDisplayMgr)
        userDisplayMgr =
            [userDisplayMgrFactory
            createUserDisplayMgrWithNavigationContoller:navigationController];

    return userDisplayMgr;
}

+ (NSString *)userSectionKey
{
    return @"User";
}

@end
