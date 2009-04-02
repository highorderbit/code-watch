//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewsFeedCacheReader

- (NSArray *)primaryUserNewsFeed;
- (NSArray *)newsFeedForUsername:(NSString *)username;

@end
