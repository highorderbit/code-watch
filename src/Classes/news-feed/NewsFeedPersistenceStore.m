//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewsFeedPersistenceStore.h"
#import "RssItem.h"

@interface NewsFeedPersistenceStore (Private)

- (RssItem *) rssItemFromDictionary:(NSDictionary *)dict;
- (NSDictionary *) dictionaryFromRssItem:(RssItem *)rssItem;

@end

@implementation NewsFeedPersistenceStore

- (void)dealloc
{
    [cacheReader release];
    [cacheSetter release];
    [super dealloc];
}

#pragma mark PersistenceStore implementation

- (void)load
{}

- (void)save
{}

#pragma mark Helper methods

- (RssItem *) rssItemFromDictionary:(NSDictionary *)dict
{
    RssItem * rssItem;
    
    // if (dict) {
    //     NSString * author;
    //     NSDate * date;
    //     NSString * subject;
    //     NSString * summary;
    //     rssItem =
    //         [[RssItem alloc] initWithAuthor:author pubDate:pubDate
    //         subject:subject summary:summary];
    // } else
    //     rssItem = nil;

    return rssItem;
}

- (NSDictionary *) dictionaryFromRssItem:(RssItem *)rssItem
{
    return nil;
}

@end
