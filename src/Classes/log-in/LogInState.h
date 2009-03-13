//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInStateReader.h"
#import "LogInStateSetter.h"

@interface LogInState : NSObject <LogInStateReader, LogInStateSetter>
{
    NSString* login;
    NSString* token;
    BOOL prompt;
}

@end
