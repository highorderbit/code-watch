//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "RssItem.h"

@implementation RssItem

@synthesize author;
@synthesize pubDate;
@synthesize subject;
@synthesize summary;

- (void)dealloc
{
    [author release];
    [pubDate release];
    [subject release];
    [summary release];
    [super dealloc];
}

+ (id)itemWithAuthor:(NSString *)anAuthor pubDate:(NSDate *)aPubDate
    subject:(NSString *)aSubject summary:(NSString *)aSummary
{
    return [[[[self class] alloc] initWithAuthor:anAuthor
                                         pubDate:aPubDate
                                         subject:aSubject
                                         summary:aSummary] autorelease];
}

- (id)initWithAuthor:(NSString *)anAuthor pubDate:(NSDate *)aPubDate
    subject:(NSString *)aSubject summary:(NSString *)aSummary
{
    if (self = [super init]) {
        author = [anAuthor copy];
        pubDate = [aPubDate copy];
        subject = [aSubject copy];
        summary = [aSummary copy];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ on %@: %@:\n%@", author, pubDate,
        subject, summary];
}

@end
