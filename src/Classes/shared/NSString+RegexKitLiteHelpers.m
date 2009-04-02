//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSString+RegexKitLiteHelpers.h"
#import "RegexKitLite.h"

@implementation NSString (RegexKitLiteHelpers)

- (NSString *) stringByMatchingRegex:(NSString *)regex
{
    return [self stringByMatchingRegex:regex capture:1];
}

- (NSString *) stringByMatchingRegex:(NSString *)regex
                             capture:(NSInteger)capture
{
    static const NSRange NOT_FOUND = { NSNotFound, 0 };
    
    NSError * error = nil;
    NSRange matchedRange = [self rangeOfRegex:regex
                                      options:RKLNoOptions
                                      inRange:NSMakeRange(0, self.length)
                                      capture:capture
                                        error:&error];
    
    if (error || NSEqualRanges(matchedRange, NOT_FOUND))
        return nil;
    else
        return [self substringWithRange:matchedRange];
}

@end
