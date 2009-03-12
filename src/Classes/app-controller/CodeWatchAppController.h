//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInMgr.h"

@interface CodeWatchAppController : NSObject {
    IBOutlet NSObject<LogInMgr>* logInMgr;
}

- (void) start;

@end
