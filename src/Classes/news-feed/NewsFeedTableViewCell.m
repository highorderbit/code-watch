//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewsFeedTableViewCell.h"
#import "NSDate+StringHelpers.h"
#import "UIColor+CodeWatchColors.h"
#import "UIImage+AvatarHelpers.h"
#import "UILabel+DrawingAdditions.h"

@interface NewsFeedTableViewCell (Private)

- (void)setNonSelectedTextColors;

@end

@implementation NewsFeedTableViewCell

- (void)dealloc
{
    [authorLabel release];
    [pubDateLabel release];
    [subjectLabel release];
    [avatarImageView release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setNonSelectedTextColors];

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

    [pubDateLabel sizeToFit:UILabelSizeToFitAlignmentRight];

    CGFloat width = USABLE_WIDTH - pubDateLabel.frame.size.width - 5.0;

    CGRect authorFrame = authorLabel.frame;
    authorFrame.size.width = width;
    authorLabel.frame = authorFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected) {
        authorLabel.textColor = self.selectedTextColor;
        pubDateLabel.textColor = self.selectedTextColor;
        subjectLabel.textColor = self.selectedTextColor;
    } else
        [self setNonSelectedTextColors];
}

- (void)updateAuthor:(NSString *)author pubDate:(NSDate *)pubDate
    subject:(NSString *)subject avatar:(UIImage *)avatar
{
    authorLabel.text = author;
    pubDateLabel.text = [pubDate shortDescription];
    subjectLabel.text = subject;
    avatarImageView.image = avatar ? avatar : [UIImage imageUnavailableImage];
}

- (void)setNonSelectedTextColors
{
    authorLabel.textColor = [UIColor blackColor];
    pubDateLabel.textColor = [UIColor codeWatchBlueColor];
    subjectLabel.textColor = [UIColor blackColor];
}
    
@end
