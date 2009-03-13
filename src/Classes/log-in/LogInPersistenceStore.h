//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceStore.h"
#import "LogInState.h"
#import "PListUtils.h"

@interface LogInPersistenceStore : NSObject <PersistenceStore>
{
    IBOutlet LogInState* logInState;
}

@end
