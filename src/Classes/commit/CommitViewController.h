//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommitInfo;

@interface CommitViewController : UITableViewController
{
    IBOutlet UIView * headerView;

    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * emailLabel;
    IBOutlet UIImageView * avatarImageView;

    CommitInfo * commitInfo;
}

@property (nonatomic, copy, readonly) CommitInfo * commitInfo;

#pragma mark Updating the view with new data

- (void)updateWithCommitInfo:(CommitInfo *)info;

@end
