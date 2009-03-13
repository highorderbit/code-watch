//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"
#import "LogInState.h"
#import "PersistenceStore.h"

@interface CodeWatchAppController : NSObject {
    IBOutlet NSObject<LogInMgr>* logInMgr;
    IBOutlet LogInState* logInState;
    IBOutlet NSObject<PersistenceStore>* logInPersistenceStore;
}

- (void) start;
- (void) persistState;

@end
