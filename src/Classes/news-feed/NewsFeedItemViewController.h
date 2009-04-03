//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeedItemViewControllerDelegate.h"

@class RssItem;

@interface NewsFeedItemViewController : UITableViewController
{
    NSObject<NewsFeedItemViewControllerDelegate> * delegate;

    IBOutlet UIView * headerView;
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * subjectLabel;
    IBOutlet UIImageView * avatarImageView;

    IBOutlet UIView * footerView;

    RssItem * rssItem;
}

@property (nonatomic, retain) NSObject<NewsFeedItemViewControllerDelegate> *
    delegate;
@property (nonatomic, copy, readonly) RssItem * rssItem;

#pragma mark Updating the display

- (void)updateWithRssItem:(RssItem *)item;

@end
