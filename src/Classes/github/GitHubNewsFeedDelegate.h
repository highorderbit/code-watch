//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GitHubNewsFeedDelegate <NSObject>

- (void)activityFeed:(NSArray *)activityFeed
    receivedForUsername:(NSString *)username;
- (void)failedToFetchActivityFeedForUsername:(NSString *)username
    error:(NSError *)error;

@end
