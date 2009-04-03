//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RssItem : NSObject {
    NSString * type;
    NSString * author;
    NSDate * pubDate;
    NSString * subject;
    NSString * summary;
}

@property (readonly, copy) NSString * type;
@property (readonly, copy) NSString * author;
@property (readonly, copy) NSDate * pubDate;
@property (readonly, copy) NSString * subject;
@property (readonly, copy) NSString * summary;
 
+ (id)itemWithType:(NSString *)aType author:(NSString *)anAuthor
    pubDate:(NSDate *)aPubDate subject:(NSString *)aSubject
    summary:(NSString *)aSummary;
- (id)initWithType:(NSString *)aType author:(NSString *)anAuthor
    pubDate:(NSDate *)aPubDate subject:(NSString *)aSubject
    summary:(NSString *)aSummary;

@end
