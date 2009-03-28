//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+CodeWatchAdditions.h"

@interface RepoActivityTableViewCell : UITableViewCell
{
    IBOutlet UILabel * messageLabel;
    IBOutlet UILabel * committerLabel;
    IBOutlet UILabel * dateLabel;
    IBOutlet UIImageView * avatarImageView;
}

- (void)setMessage:(NSString *)message;
- (void)setCommitter:(NSString *)committer;
- (void)setDate:(NSDate *)date;
- (void)setAvatar:(UIImage *)avatar;

@end
