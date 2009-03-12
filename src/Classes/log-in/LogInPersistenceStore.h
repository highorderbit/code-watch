//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LogInPersistenceStore

- (void) persistLogin:(NSString*)login token:(NSString*)token prompt:(BOOL)prompt;

@end
