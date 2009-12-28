//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewsFeedPersistenceStore.h"
#import "RssItem.h"
#import "PListUtils.h"

@interface NewsFeedPersistenceStore (Private)

+ (RssItem *) rssItemFromDictionary:(NSDictionary *)dict;
+ (NSDictionary *) dictionaryFromRssItem:(RssItem *)rssItem;

+ (NSString *)primaryUserKey;
+ (NSString *)everyoneElseKey;
+ (NSString *)typeKey;
+ (NSString *)authorKey;
+ (NSDate *)pubDateKey;
+ (NSString *)subjectKey;
+ (NSString *)summaryKey;
+ (NSString *)linkKey;

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
    NSDictionary * data =
        [PlistUtils getDictionaryFromPlist:[[self class] plistName]];
    if (!data)
        return;

    NSArray * rawPrimaryUserItems =
        [data objectForKey:[[self class] primaryUserKey]];
    NSMutableArray * primaryUserItems =
        [NSMutableArray arrayWithCapacity:rawPrimaryUserItems.count];
    for (NSDictionary * d in rawPrimaryUserItems) {
        RssItem * item = [[self class] rssItemFromDictionary:d];
        [primaryUserItems addObject:item];
    }
    [cacheSetter setPrimaryUserNewsFeed:primaryUserItems];

    NSDictionary * everythingElse =
        [data objectForKey:[[self class] everyoneElseKey]];

    for (NSString * user in everythingElse) {
        NSArray * rawFeed = [everythingElse objectForKey:user];
        NSMutableArray * activityFeed =
            [NSMutableArray arrayWithCapacity:rawFeed.count];

        for (NSDictionary * d in rawFeed) {
            RssItem * item = [[self class] rssItemFromDictionary:d];
            [activityFeed addObject:item];
        }

        [cacheSetter setActivityFeed:activityFeed forUsername:user];
    }
}

- (void)save
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    NSMutableArray * rssItemsAsDicts = [NSMutableArray array];

    NSArray * primaryUserRssItems = [cacheReader primaryUserNewsFeed];
    for (RssItem * rssItem in primaryUserRssItems) {
        NSDictionary * rssItemDict =
            [[self class] dictionaryFromRssItem:rssItem];
        [rssItemsAsDicts addObject:rssItemDict];
    }
    [dict setObject:rssItemsAsDicts forKey:[[self class] primaryUserKey]];

    NSDictionary * everyoneElse = [cacheReader allActivityFeeds];
    NSMutableDictionary * everyoneElseConverted =
        [NSMutableDictionary dictionaryWithCapacity:everyoneElse.count];
    for (NSString * user in everyoneElse) {
        NSArray * rssItems = [everyoneElse objectForKey:user];
        NSMutableArray * convertedItems =
            [NSMutableArray arrayWithCapacity:rssItems.count];
        for (RssItem * item in rssItems) {
            NSDictionary * rssItemDict =
                [[self class] dictionaryFromRssItem:item];
            [convertedItems addObject:rssItemDict];
        }
        [everyoneElseConverted setObject:convertedItems forKey:user];
    }
    [dict setObject:everyoneElseConverted
             forKey:[[self class] everyoneElseKey]];

    [PlistUtils saveDictionary:dict toPlist:[[self class] plistName]];
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

        NSString * linkString = [dict objectForKey:[[self class] linkKey]];
        NSURL * link = linkString ? [NSURL URLWithString:linkString] : nil;

        rssItem =
            [[[RssItem alloc] initWithType:type author:author pubDate:pubDate
            subject:subject summary:summary link:link] autorelease];
    } else
        rssItem = nil;

    return rssItem;
}

+ (NSDictionary *)dictionaryFromRssItem:(RssItem *)rssItem
{
    NSMutableDictionary * dict = nil;

    if (rssItem) {
        dict = [NSMutableDictionary dictionary];
        [dict setObject:rssItem.type forKey:[[self class] typeKey]];
        [dict setObject:rssItem.author forKey:[[self class] authorKey]];
        [dict setObject:rssItem.pubDate forKey:[[self class] pubDateKey]];
        [dict setObject:rssItem.subject forKey:[[self class] subjectKey]];
        [dict setObject:rssItem.summary forKey:[[self class] summaryKey]];
        [dict setObject:[rssItem.link absoluteString]
            forKey:[[self class] linkKey]];
    }

    return dict;
}

+ (NSString *)primaryUserKey
{
    return @"primaryUser";
}

+ (NSString *)everyoneElseKey
{
    return @"everyoneElse";
}

+ (NSString *)typeKey
{
    return @"type";
}

+ (NSString *)authorKey
{
    return @"author";
}

+ (NSString *)pubDateKey
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

+ (NSString *)linkKey
{
    return @"link";
}

+ (NSString *)plistName
{
    return @"NewsFeedCache";
}

@end
