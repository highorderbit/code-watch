//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSDate+StringHelpers.h"
#import "NSDate+IsToday.h"

@implementation NSDate (StringHelpers)

- (NSString *)shortDescription
{
    NSString * description;
    
    if ([self isYesterday])
        description = @"Yesterday";
    else {
        NSDateFormatter * formatter =
            [[[NSDateFormatter alloc] init] autorelease];

        if ([self isToday])
            [formatter setTimeStyle:NSDateFormatterShortStyle];
        else if ([self isLessThanWeekAgo])
            formatter.dateFormat = @"EEEE";
        else
            [formatter setDateStyle:NSDateFormatterShortStyle];

        description = [formatter stringFromDate:self];
    }

    return description;
}

- (NSString *)shortDateAndTimeDescription
{
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];

    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];

    return [formatter stringFromDate:self];
}

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)formatString
{
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = formatString;
    NSDate * date = [formatter dateFromString:string];
    
    return date;
}

@end
