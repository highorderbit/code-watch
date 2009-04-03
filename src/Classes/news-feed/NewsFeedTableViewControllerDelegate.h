//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RssItem;

@protocol NewsFeedTableViewControllerDelegate

- (void)userDidSelectRssItem:(RssItem *)item;

@end
