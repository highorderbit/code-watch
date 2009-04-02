//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegexKitListHelpers)

- (NSString *) stringByMatchingRegex:(NSString *)regex;
- (NSString *) stringByMatchingRegex:(NSString *)regex
                             capture:(NSInteger)capture;

@end
