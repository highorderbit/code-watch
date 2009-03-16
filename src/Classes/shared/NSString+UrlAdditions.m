//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSString+UrlAdditions.h"

@implementation NSString (UrlAdditions)

- (NSString *)urlEncodedString
{
    static const NSStringEncoding encoding = NSUTF8StringEncoding;
    return [self stringByAddingPercentEscapesUsingEncoding:encoding];
}

@end