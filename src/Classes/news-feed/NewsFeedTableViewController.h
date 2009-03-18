//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedTableViewController : UITableViewController {
    NSArray * rssItems;
}

- (void)updateRssItems:(NSArray *)someRssItems;

@end
