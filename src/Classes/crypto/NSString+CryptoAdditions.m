//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSString+CryptoAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CryptoAdditions)

- (NSString *) md5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );

    NSString * hash = [NSString stringWithFormat:
        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
        result[0], result[1], result[2], result[3], result[4], result[5],
        result[6], result[7], result[8], result[9], result[10], result[11],
        result[12], result[13], result[14], result[15] ];

    // TODO: Can the hash be generated in lower case directly through a
    //       different format string?
    return [hash lowercaseString];
}

@end