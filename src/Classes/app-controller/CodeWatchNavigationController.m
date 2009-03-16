//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "CodeWatchNavigationController.h"

@implementation CodeWatchNavigationController

- (void)dealloc
{
    [displayMgr release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [displayMgr display];
}

@end
