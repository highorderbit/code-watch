//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSDictionary+NonRetainedKeyAdditions.h"

@interface NSMutableDictionary (Private)

+ (NSValue *)keyForNonRetainedObject:(id)obj;

@end

@implementation NSMutableDictionary (NonRetainedKeyAdditions)

- (void)setObject:(id)obj forNonRetainedKey:(id)key
{
    [self setObject:obj forKey:[[self class] keyForNonRetainedObject:key]];
}

- (void)removeObjectForNonRetainedKey:(id)key
{
    [self removeObjectForKey:[[self class] keyForNonRetainedObject:key]];
}

- (void)removeObjectsForNonRetainedKeys:(NSArray *)keys
{
    for (id key in keys)
        [self removeObjectForNonRetainedKey:key];
}

- (id)objectForNonRetainedKey:(id)key
{
    return [self objectForKey:[[self class] keyForNonRetainedObject:key]];
}

#pragma mark Helper methods

+ (NSValue *)keyForNonRetainedObject:(id)obj
{
    return [NSValue valueWithNonretainedObject:obj];
}

@end
