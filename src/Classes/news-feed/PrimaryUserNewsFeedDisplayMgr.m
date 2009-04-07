//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

/*
#import "PrimaryUserNewsFeedDisplayMgr.h"

@implementation PrimaryUserNewsFeedDisplayMgr

- (void)dealloc
{
    [factory release];

    [logInStateReader release];
    [userCacheReader release];

    [displayMgr release];

    [super dealloc];
}

- (void)awakeFromNib
{
    displayMgr = [[factory createNewsFeedDisplayMgr] retain];

    displayMgr.username = logInStateReader.login;
    displayMgr.userInfo = userCacheReader.primaryUser;

    [displayMgr updateNewsFeed];
}

@end
 */
