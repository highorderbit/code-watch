//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "NewsFeedCache.h"
#import "RssItem.h"

@implementation NewsFeedCache

@synthesize rssItems;

- (void)dealloc
{
    [rssItems release];
    [super dealloc];
}

- (void)awakeFromNib
{
    // TEMPORARY: set some rssItems
    
    NSMutableArray * tempRssItems = [NSMutableArray array];
    
    NSDate * now = [NSDate date];
    
    NSString * author1 = @"jad";
    NSString * subject1 = @"jad pushed to master at highorderbit/code-watch";
    NSString * summary1 = @"HEAD is a94a0aa279ed58a8286966659ae85bb74b4f8544   John A. Debay committed a94a0aa2:  Reading GitHub API version from Info.plist.   John A. Debay committed 752607c2:  Merge branch 'master' of git@github.com:highorderbit/code-watch   John A. Debay committed c43f458c:  Reading GitHub API format from Info.plist.";
    
    RssItem * update1 =
        [[RssItem alloc] initWithAuthor:author1 pubDate:now subject:subject1
        summary:summary1];
    
    NSString * author2 = @"mrtrumbe";
    NSString * subject2 = @"mrtrumbe started watching euphoria/thrifty";
    NSString * summary2 = @"thrifty's description: Thrifty is a Python-based parser generator for Apache Thrift sourc";
    
    RssItem * update2 =
        [[RssItem alloc] initWithAuthor:author2 pubDate:now subject:subject2
        summary:summary2];
    
    [tempRssItems addObject:update1];
    [tempRssItems addObject:update2];
    
    [self setRssItems:tempRssItems];
    
    // TEMPORARY
}

- (void)setRssItems:(NSArray *)someRssItems
{
    someRssItems = [someRssItems copy];
    [rssItems release];
    rssItems = someRssItems;
}

@end
