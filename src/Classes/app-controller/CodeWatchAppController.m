//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "CodeWatchAppController.h"

@implementation CodeWatchAppController

- (void)dealloc
{
    [logInMgr release];
    [logInState release];
    [logInPersistenceStore release];
    
    [userCachePersistenceStore release];
    
    [newsFeedPersistenceStore release];
    
    [super dealloc];
}

- (void)start
{
    [logInPersistenceStore load];
    [userCachePersistenceStore load];
    [newsFeedPersistenceStore load];
    
    if ([logInState prompt])
        [logInMgr collectCredentials:self];
    else
        [logInMgr init];
}

- (void)persistState
{
    [logInPersistenceStore save];
    [userCachePersistenceStore save];
    [newsFeedPersistenceStore save];
}

@end
