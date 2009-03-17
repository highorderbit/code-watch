//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LogInStateReader

@property (copy, readonly) NSString * login;
@property (copy, readonly) NSString * token;
@property (readonly) BOOL prompt;

@end
