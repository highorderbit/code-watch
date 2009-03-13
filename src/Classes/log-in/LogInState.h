//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogInState : NSObject
{
    NSString* login;
    NSString* token;
    BOOL prompt;
}

@property (copy, readonly) NSString* login;
@property (copy, readonly) NSString* token;
@property (readonly) BOOL prompt;

- (void) setLogin:(NSString*)login token:(NSString*)token prompt:(BOOL)prompt;

@end
