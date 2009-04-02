//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitHubNewsFeedParser : NSObject
{
}

#pragma mark Initialization

- (id)init;

#pragma mark Parsing receive XML

- (NSArray *)parseXml:(NSData *)xmlData;

@end