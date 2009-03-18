//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+CodeWatchAdditions.h"

@interface RepoActivityTableViewCell : UITableViewCell
{
    IBOutlet UITextView * messageTextView;
    IBOutlet UILabel * committerLabel;
    IBOutlet UILabel * dateLabel;
}

- (void)setMessage:(NSString *)message;
- (void)setCommitter:(NSString *)committer;
- (void)setDate:(NSDate *)date;

@end
