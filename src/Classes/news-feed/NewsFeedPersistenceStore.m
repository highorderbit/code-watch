//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewsFeedPersistenceStore.h"
#import "RssItem.h"
#import "PListUtils.h"

@interface NewsFeedPersistenceStore (Private)

+ (RssItem *) rssItemFromDictionary:(NSDictionary *)dict;
+ (NSDictionary *) dictionaryFromRssItem:(RssItem *)rssItem;

+ (NSString *)typeKey;
+ (NSString *)authorKey;
+ (NSDate *)pubDateKey;
+ (NSString *)subjectKey;
+ (NSString *)summaryKey;

+ (NSString *)plistName;

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
{
    NSArray * array =
        [PlistUtils getArrayFromPlist:[[self class] plistName]];
    
    NSMutableArray * rssItems = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        RssItem * rssItem =
            [[self class] rssItemFromDictionary:dict];
        [rssItems addObject:rssItem];
    }
    
    [cacheSetter setPrimaryUserNewsFeed:rssItems];
}

- (void)save
{
    NSMutableArray * array = [NSMutableArray array];

    NSArray * rssItems = [cacheReader primaryUserNewsFeed];
    for (RssItem * rssItem in rssItems) {
        NSDictionary * rssItemDict =
            [[self class] dictionaryFromRssItem:rssItem];
        [array addObject:rssItemDict];
    }

    [PlistUtils saveArray:array toPlist:[[self class] plistName]];
}

#pragma mark Static elper methods

+ (RssItem *)rssItemFromDictionary:(NSDictionary *)dict
{
    RssItem * rssItem;
    
    if (dict) {
        NSString * type = [dict objectForKey:[[self class] typeKey]];
        NSString * author = [dict objectForKey:[[self class] authorKey]];
        NSDate * pubDate = [dict objectForKey:[[self class] pubDateKey]];
        NSString * subject = [dict objectForKey:[[self class] subjectKey]];
        NSString * summary = [dict objectForKey:[[self class] summaryKey]];
        rssItem =
            [[[RssItem alloc] initWithType:type author:author pubDate:pubDate
            subject:subject summary:summary] autorelease];
    } else
        rssItem = nil;

    return rssItem;
}

+ (NSDictionary *)dictionaryFromRssItem:(RssItem *)rssItem
{
    NSMutableDictionary * dict;
    
    if (rssItem) {
        dict = [NSMutableDictionary dictionary];
        [dict setObject:rssItem.type forKey:[[self class] typeKey]];
        [dict setObject:rssItem.author forKey:[[self class] authorKey]];
        [dict setObject:rssItem.pubDate forKey:[[self class] pubDateKey]];
        [dict setObject:rssItem.subject forKey:[[self class] subjectKey]];
        [dict setObject:rssItem.summary forKey:[[self class] summaryKey]];
    } else
        dict = nil;
    
    return dict;
}

+ (NSString *)typeKey
{
    return @"type";
}

+ (NSString *)authorKey
{
    return @"author";
}

+ (NSDate *)pubDateKey
{
    return @"pubDate";
}

+ (NSString *)subjectKey
{
    return @"subject";
}

+ (NSString *)summaryKey
{
    return @"summary";
}

+ (NSString *)plistName
{
    return @"NewsFeedCache";
}

@end
