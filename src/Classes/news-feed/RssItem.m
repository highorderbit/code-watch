//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "RssItem.h"

@implementation RssItem

@synthesize type;
@synthesize author;
@synthesize pubDate;
@synthesize subject;
@synthesize summary;

- (void)dealloc
{
    [type release];
    [author release];
    [pubDate release];
    [subject release];
    [summary release];
    [super dealloc];
}

+ (id)itemWithType:(NSString *)aType author:(NSString *)anAuthor
    pubDate:(NSDate *)aPubDate subject:(NSString *)aSubject
    summary:(NSString *)aSummary
{
    return [[[[self class] alloc] initWithType:aType
                                        author:anAuthor
                                         pubDate:aPubDate
                                         subject:aSubject
                                         summary:aSummary] autorelease];
}

- (id)initWithType:(NSString *)aType author:(NSString *)anAuthor
       pubDate:(NSDate *)aPubDate subject:(NSString *)aSubject
       summary:(NSString *)aSummary
{
    if (self = [super init]) {
        type = [aType copy];
        author = [anAuthor copy];
        pubDate = [aPubDate copy];
        subject = [aSubject copy];
        summary = [aSummary copy];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@ on %@: %@:\n%@", type, author,
        pubDate, subject, summary];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone]
        initWithType:type author:author pubDate:pubDate subject:subject
        summary:summary];
}

@end
