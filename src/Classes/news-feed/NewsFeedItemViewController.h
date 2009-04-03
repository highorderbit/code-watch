//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeedItemViewControllerDelegate.h"
#import "RepoSelector.h"

@class RssItem, RepoSelectorFactory;

@interface NewsFeedItemViewController : UITableViewController
{
    NSObject<NewsFeedItemViewControllerDelegate> * delegate;

    RepoSelectorFactory * repoSelectorFactory;
    NSObject<RepoSelector> * repoSelector;

    IBOutlet UIView * headerView;
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * descriptionLabel;
    IBOutlet UILabel * subjectLabel;
    IBOutlet UIImageView * avatarImageView;

    IBOutlet UIView * footerView;

    RssItem * rssItem;
}

@property (nonatomic, retain) NSObject<NewsFeedItemViewControllerDelegate> *
    delegate;
@property (nonatomic, retain) RepoSelectorFactory * repoSelectorFactory;
@property (nonatomic, copy, readonly) RssItem * rssItem;

#pragma mark Updating the display

- (void)updateWithRssItem:(RssItem *)item;

@end
