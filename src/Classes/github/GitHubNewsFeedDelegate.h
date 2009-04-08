//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GitHubNewsFeedDelegate <NSObject>

- (void)newsFeed:(NSArray *)newsFeed fetchedForUsername:(NSString *)username;
- (void)failedToFetchNewsFeedForUsername:(NSString *)username
    error:(NSError *)error;

- (void)activityFeed:(NSArray *)activityFeed
    fetchedForUsername:(NSString *)username;
- (void)failedToFetchActivityFeedForUsername:(NSString *)username
   error:(NSError *)error;

@end
