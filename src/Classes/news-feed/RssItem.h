//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RssItem : NSObject {
    NSString * author;
    NSDate * pubDate;
    NSString * subject;
    NSString * summary;
}

@property (readonly, copy) NSString * author;
@property (readonly, copy) NSDate * pubDate;
@property (readonly, copy) NSString * subject;
@property (readonly, copy) NSString * summary;
 
+ (id)itemWithAuthor:(NSString *)anAuthor pubDate:(NSDate *)aPubDate
    subject:(NSString *)aSubject summary:(NSString *)aSummary;
- (id)initWithAuthor:(NSString *)anAuthor pubDate:(NSDate *)aPubDate
    subject:(NSString *)aSubject summary:(NSString *)aSummary;

@end
