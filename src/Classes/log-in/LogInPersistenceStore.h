//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceStore.h"
#import "LogInStateReader.h"
#import "LogInStateSetter.h"

@interface LogInPersistenceStore : NSObject <PersistenceStore>
{
    IBOutlet NSObject<LogInStateReader>* logInStateReader;
    IBOutlet NSObject<LogInStateSetter>* logInStateSetter;
}

@end
