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

#pragma mark FavoriteUsersViewControllerDelegate implementation

- (void)viewWillAppear
{
    // read favorite users from state
    // set favorite users in view
    
    // TEMPORARY
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:@"jad"];
    [array addObject:@"kurthd"];
    [viewController setUsernames:array];
    // TEMPORARY
}

@end
