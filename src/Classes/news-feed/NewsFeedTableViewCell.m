//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewsFeedTableViewCell.h"
#import "NSDate+StringHelpers.h"
#import "UIColor+CodeWatchColors.h"
#import "UIImage+AvatarHelpers.h"

@interface NewsFeedTableViewCell (Private)

- (void)setNonSelectedTextColors;

@end

@implementation NewsFeedTableViewCell

- (void)dealloc
{
    [authorLabel release];
    [pubDateLabel release];
    [subjectLabel release];
    [summaryLabel release];
    [avatarImageView release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [self setNonSelectedTextColors];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
        
    if (selected) {
        authorLabel.textColor = self.selectedTextColor;
        pubDateLabel.textColor = self.selectedTextColor;
        subjectLabel.textColor = self.selectedTextColor;
        summaryLabel.textColor = self.selectedTextColor;
    } else
        [self setNonSelectedTextColors];
}

- (void)updateAuthor:(NSString *)author pubDate:(NSDate *)pubDate
    subject:(NSString *)subject summary:(NSString *)summary
    avatar:(UIImage *)avatar
{
    authorLabel.text = author;
    pubDateLabel.text = [pubDate shortDescription];
    subjectLabel.text = subject;
    summaryLabel.text = summary;
    avatarImageView.image = avatar ? avatar : [UIImage imageUnavailableImage];
}

- (void)setNonSelectedTextColors
{
    authorLabel.textColor = [UIColor blackColor];
    pubDateLabel.textColor = [UIColor codeWatchBlueColor];
    subjectLabel.textColor = [UIColor blackColor];
    summaryLabel.textColor = [UIColor codeWatchGrayColor];
}
    
@end
