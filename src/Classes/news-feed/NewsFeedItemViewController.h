//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RssItem;

@interface NewsFeedItemViewController : UITableViewController
{
    IBOutlet UIView * headerView;
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * subjectLabel;
    IBOutlet UIImageView * avatarImageView;

    RssItem * rssItem;
}

@property (nonatomic, copy, readonly) RssItem * rssItem;

#pragma mark Updating the display

- (void)updateWithRssItem:(RssItem *)item;

@end
