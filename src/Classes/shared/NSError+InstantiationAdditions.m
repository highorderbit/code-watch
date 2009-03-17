//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSError+InstantiationAdditions.h"

@implementation NSError (BuildWatchAdditions)

+ (NSString *) applicationErrorDomain
{
    return @"CodeWatchErrorDomain";
}

+ (NSError *) errorWithLocalizedDescription:(NSString *)localizedDescription
{
    return [[self class] errorWithLocalizedDescription:localizedDescription
                                             rootCause:nil];
}

+ (NSError *) errorWithLocalizedDescription:(NSString *)localizedDescription
                                  rootCause:(NSError *)rootCause
{
    NSMutableDictionary * userInfo =
        [NSMutableDictionary dictionaryWithCapacity:2];

    [userInfo setObject:localizedDescription forKey:NSLocalizedDescriptionKey];
    if (rootCause)
        [userInfo setObject:rootCause.localizedDescription
                     forKey:NSLocalizedFailureReasonErrorKey];

    return [[self class] errorWithDomain:[[self class] applicationErrorDomain]
                                    code:1
                                userInfo:userInfo];
}

@end