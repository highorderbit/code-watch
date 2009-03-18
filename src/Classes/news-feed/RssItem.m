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

- (id)initWithAuthor:(NSString *)anAuthor pubDate:(NSDate *)aPubDate
    subject:(NSString *)aSubject summary:(NSString *)aSummary
{
    author = [anAuthor copy];
    pubDate = [aPubDate copy];
    subject = [aSubject copy];
    summary = [aSummary copy];
    
    return self;
}

@end
