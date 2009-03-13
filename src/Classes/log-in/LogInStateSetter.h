//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LogInStateSetter

- (void) setLogin:(NSString*)login token:(NSString*)token prompt:(BOOL)prompt;

@end
