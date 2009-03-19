//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RepoActivityTableViewCell.h"
#import "NSDate+StringHelpers.h"

@implementation RepoActivityTableViewCell

- (void)dealloc
{
    [messageTextView release];
    [committerLabel release];
    [dateLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(NSString *)message
{
    messageTextView.text = message;
}

- (void)setCommitter:(NSString *)committer
{
    committerLabel.text = committer;
}

- (void)setDate:(NSDate *)date
{
    dateLabel.text = [date shortDescription];
}

- (void)setCommitId:(NSString *)commitId
{
    commitIdLabel.text = commitId;
}

@end
