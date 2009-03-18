//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSDate+IsToday.h"

@implementation NSDate (IsToday)

- (BOOL) isToday
{
    NSCalendar * currentCalendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags =
        NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents * selfComps =
        [currentCalendar components:unitFlags fromDate:self];
    
    NSDate * now = [NSDate date];

    NSDateComponents * nowComps =
        [currentCalendar components:unitFlags fromDate:now];
    
    return [nowComps day] == [selfComps day] &&
        [nowComps month] == [selfComps month] &&
        [nowComps year] == [selfComps year];
}

- (BOOL) isLessThanWeekAgo
{
    NSCalendar * currentCalendar = [NSCalendar currentCalendar];

    unsigned unitFlags =
    NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents * selfComps =
        [currentCalendar components:unitFlags fromDate:self];
    
    NSDateComponents * comps = [[[NSDateComponents alloc] init] autorelease];
    [comps setDay:[selfComps day]];
    [comps setMonth:[selfComps month]];
    [comps setYear:[selfComps year]];
    
    NSDate * beginningOfToday = [currentCalendar dateFromComponents:comps];

    return -[beginningOfToday timeIntervalSinceNow] < 60 * 60 * 24 * 7;
}

@end
