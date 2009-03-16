//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSString+NSDataAdditions.h"

@implementation NSString (NSDataAdditions)

+ (NSString *)stringWithUTF8EncodedData:(NSData *)data
{
    return [[self class] stringWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding
{
    NSString * s = [[[self class] alloc] initWithData:data encoding:encoding];
    return [s autorelease];
}

@end