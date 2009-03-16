//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RuntimeAdditions)

#if TARGET_OS_IPHONE

/*
 * These functions are defined and valid on the simulator but not the device,
 * so we are providing our own implementations.
 */

+ (NSString *)className;
- (NSString *)className;

#endif

@end
