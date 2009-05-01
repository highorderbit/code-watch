//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RepoActivityTableViewCell.h"
#import "NSDate+StringHelpers.h"
#import "UIColor+CodeWatchColors.h"
#import "UIImage+AvatarHelpers.h"
#import "UILabel+DrawingAdditions.h"

@interface RepoActivityTableViewCell (Private)

- (void)setSelectedTextColors;
- (void)setNonselectedTextColors;

@end

@implementation RepoActivityTableViewCell

- (void)dealloc
{
    [messageLabel release];
    [committerLabel release];
    [dateLabel release];
    [avatarImageView release];

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }

    return self;
}

- (void)awakeFromNib
{
    [self setNonselectedTextColors];

    UIImage * backgroundImage =
        [UIImage imageNamed:@"TableViewCellGradient.png"];
    self.backgroundView =
        [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
    self.backgroundView.contentMode =  UIViewContentModeBottom;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    static const CGFloat USABLE_WIDTH = 220.0;

    [dateLabel sizeToFit:UILabelSizeToFitAlignmentRight];

    CGFloat width = USABLE_WIDTH - dateLabel.frame.size.width - 5.0;

    CGRect committerFrame = committerLabel.frame;
    committerFrame.size.width = width;
    committerLabel.frame = committerFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected)
        [self setSelectedTextColors];
    else
        [self setNonselectedTextColors];
}

#pragma mark Updating cell content

- (void)setMessage:(NSString *)message
{
    messageLabel.text = message;
}

- (void)setCommitter:(NSString *)committer
{
    committerLabel.text = committer;
}

- (void)setDate:(NSDate *)date
{
    dateLabel.text = [date shortDescription];
}

- (void)setAvatar:(UIImage *)avatar
{
    avatarImageView.image = avatar ? avatar : [UIImage imageUnavailableImage];
}

#pragma mark Managing cell element colors

- (void)setSelectedTextColors
{
    messageLabel.textColor = [UIColor whiteColor];
    committerLabel.textColor = [UIColor whiteColor];
    dateLabel.textColor = [UIColor whiteColor];
}

- (void)setNonselectedTextColors
{
    messageLabel.textColor = [UIColor blackColor];
    committerLabel.textColor = [UIColor blackColor];
    dateLabel.textColor = [UIColor codeWatchBlueColor];
}

@end
