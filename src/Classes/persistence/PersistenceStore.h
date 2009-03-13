//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PersistenceStore

- (void) load;
- (void) save;

@end
