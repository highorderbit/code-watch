//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (NonRetainedKeyAdditions)

- (void)setObject:(id)obj forNonRetainedKey:(id)key;

- (void)removeObjectForNonRetainedKey:(id)key;
- (void)removeObjectsForNonRetainedKeys:(NSArray *)keys;

- (id)objectForNonRetainedKey:(id)key;

@end
