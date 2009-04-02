//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GitHubNewsFeedServiceDelegate <NSObject>

- (void)newsFeed:(NSArray *)newsFeed fetchedForUsername:(NSString *)username;
- (void)failedToFetchNewsFeedForUsername:(NSString *)username
                                   error:(NSError *)error;

@end
