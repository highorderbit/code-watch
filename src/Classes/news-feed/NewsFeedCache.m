//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "NewsFeedCache.h"

@implementation NewsFeedCache

@synthesize rssItems;

- (void)dealloc
{
    [rssItems release];
    [super dealloc];
}

- (void)setRssItems:(NSArray *)someRssItems
{
    someRssItems = [someRssItems copy];
    [rssItems release];
    rssItems = someRssItems;
}

@end
