//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RssItem;

@protocol NewsFeedItemViewControllerDelegate

- (void)userDidSelectDetails:(RssItem *)rssItem;
- (void)userDidSelectRepo:(NSString *)repoName ownedByUser:(NSString *)username;

@end
