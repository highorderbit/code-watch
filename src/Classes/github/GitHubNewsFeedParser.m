//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "GitHubNewsFeedParser.h"
#import "NSString+NSDataAdditions.h"
#import "NSDate+StringHelpers.h"
#import "RssItem.h"

#import "RegexKitLite.h"
#import "NSString+RegexKitLiteHelpers.h"

#import "TouchXML.h"

@interface GitHubNewsFeedParser (Private)

+ (RssItem *)parseEntry:(CXMLElement *)entry error:(NSError **)error;
+ (CXMLElement *)singleNodeAtXpath:(NSString *)xpath
                     withinElement:(CXMLElement *)element
                             error:(NSError **)error;
+ (NSString *)hackXmlStringIfNecessary:(NSString *)xmlString;

@end

@implementation GitHubNewsFeedParser

#pragma mark Initialization

- (id)init
{
    return self = [super init];
}

- (NSArray *)parseXml:(NSData *)xmlData
{
    NSError * error = nil;

    NSString * xmlString =
        [[self class] hackXmlStringIfNecessary:
           [NSString stringWithUTF8EncodedData:xmlData]];
    CXMLDocument * xmlDoc = [[[CXMLDocument alloc]
         initWithXMLString:xmlString options:0 error:&error] autorelease];
    if (error) return nil;

    NSArray * entries = [xmlDoc nodesForXPath:@"//entry" error:&error];
    if (error) return nil;

    NSMutableArray * newsItems =
        [NSMutableArray arrayWithCapacity:entries.count];

    for (CXMLElement * entry in entries) {
        RssItem * item = [[self class] parseEntry:entry error:&error];
        if (error || !item)
            return nil;
        else
            [newsItems addObject:item];
    }

    return newsItems;
}

#pragma mark Parsing helper methods

+ (RssItem *)parseEntry:(CXMLElement *)entry error:(NSError **)error
{
    // Dates are formatted as: 2009-04-02T09:16:24-07:00
    static NSString * DATE_FORMAT = @"yyyy-MM-dd'T'HH:mm:SSZZZ";

    NSString * type, * author, * pubDateString, * subject, * summary;
    NSString * linkString;

    NSDate * pubDate;
    NSURL * link;

    type = [[[self class]
        singleNodeAtXpath:@"./id" withinElement:entry error:error] stringValue];
    type = [type stringByMatchingRegex:@":.*:(.*?Event)/"];
    if (!type || *error) return nil;

    author = [[[self class]
        singleNodeAtXpath:@"./author/name" withinElement:entry error:error]
        stringValue];
    if (!author || *error) return nil;

    pubDateString = [[[self class]
        singleNodeAtXpath:@"./published" withinElement:entry error:error]
        stringValue];
    if (!pubDateString || *error) return nil;
    pubDate = [NSDate dateFromString:pubDateString format:DATE_FORMAT];

    subject = [[[self class]
        singleNodeAtXpath:@"./title" withinElement:entry error:error]
        stringValue];
    if (!subject || *error) return nil;

    summary = [[[self class]
        singleNodeAtXpath:@"./content" withinElement:entry error:error]
        stringValue];
    if (!summary || *error) return nil;

    linkString = [[[self class]
        singleNodeAtXpath:@"./link/@href" withinElement:entry error:error]
        stringValue];
    if (!linkString || *error) return nil;
    link = [NSURL URLWithString:linkString];

    return [RssItem itemWithType:type author:author pubDate:pubDate
        subject:subject summary:summary link:link];
}

+ (CXMLElement *)singleNodeAtXpath:(NSString *)xpath
                     withinElement:(CXMLElement *)element
                             error:(NSError **)error
{
    NSArray * values = [element nodesForXPath:xpath error:error];
    return *error || values.count != 1 ? nil : [values lastObject];
}

+ (NSString *)hackXmlStringIfNecessary:(NSString *)xmlString
{
//
    // Need to hack strings from certain CI servers (e.g. TeamCity) to
    // remove xmlns attributes from the root node. If it contains these,
    // all xpath operations fail.
    //

    static NSString * xmlnsHackRegex = @"<feed(.*\\s+(xmlns=.*))>";
    static NSString * xmlnsHackReplacementString = @"<feed>";

    return [xmlString
        stringByReplacingOccurrencesOfRegex:xmlnsHackRegex
                                 withString:xmlnsHackReplacementString];
}    

@end
