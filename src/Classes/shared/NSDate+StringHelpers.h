//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (StringHelpers)

- (NSString *)shortDescription;
- (NSString *)shortDateAndTimeDescription;

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)formatString;

@end
