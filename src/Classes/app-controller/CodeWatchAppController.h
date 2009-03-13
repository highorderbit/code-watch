//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"
#import "LogInStateReader.h"
#import "PersistenceStore.h"

@interface CodeWatchAppController : NSObject {
    IBOutlet NSObject<LogInMgr>* logInMgr;
    IBOutlet NSObject<PersistenceStore>* logInPersistenceStore;
    IBOutlet NSObject<LogInStateReader>* logInState;
}

- (void) start;
- (void) persistState;

@end
