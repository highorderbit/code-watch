//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceStore.h"
#import "UIState.h"

@interface UIStatePersistenceStore : NSObject <PersistenceStore>
{
    IBOutlet UIState * state;
}

@end
