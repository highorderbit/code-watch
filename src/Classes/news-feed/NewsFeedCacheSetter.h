//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewsFeedCacheSetter

- (void)setPrimaryUserNewsFeed:(NSArray *)newsFeed;
- (void)setNewsFeed:(NSArray *)newsFeed forUsername:(NSString *)username;

@end
