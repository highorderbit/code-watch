//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeedTableViewControllerDelegate.h"

@interface NewsFeedTableViewController : UITableViewController
{
    IBOutlet NSObject<NewsFeedTableViewControllerDelegate> * delegate;

    NSArray * rssItems;
}

- (void)updateRssItems:(NSArray *)someRssItems;

@end
