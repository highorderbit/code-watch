//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"
#import "LogInStateReader.h"
#import "PersistenceStore.h"

@interface CodeWatchAppController : NSObject
{
    IBOutlet NSObject<LogInMgr> * logInMgr;
    IBOutlet NSObject<LogInStateReader> * logInState;

    IBOutlet NSObject<PersistenceStore> * logInPersistenceStore;    
    IBOutlet NSObject<PersistenceStore> * userCachePersistenceStore;
    IBOutlet NSObject<PersistenceStore> * newsFeedPersistenceStore;
    IBOutlet NSObject<PersistenceStore> * repoCachePersistenceStore;
    IBOutlet NSObject<PersistenceStore> * favoriteUsersPersistenceStore;
}

- (void) start;
- (void) persistState;

@end
