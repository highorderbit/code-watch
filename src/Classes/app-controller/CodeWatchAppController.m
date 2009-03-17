//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "CodeWatchAppController.h"

@implementation CodeWatchAppController

- (void) dealloc
{
    [logInMgr release];
    [logInState release];
    [logInPersistenceStore release];
    
    [userCachePersistenceStore release];
    
    [super dealloc];
}

- (void) start
{
    [logInPersistenceStore load];
    [userCachePersistenceStore load];
    
    if ([logInState prompt])
        [logInMgr collectCredentials];
}

- (void) persistState
{
    [logInPersistenceStore save];
    [userCachePersistenceStore save];
}

@end
